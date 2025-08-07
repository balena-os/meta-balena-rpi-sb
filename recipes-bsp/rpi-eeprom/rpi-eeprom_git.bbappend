FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
DEPENDS += "${@oe.utils.conditional('SIGN_API','','',' usbboot-native',d)}"

do_compile:append() {
    if [ "x${SIGN_API}" != "x" ]; then
        # Make sure the firmware is secure boot capable
        BOOTLOADER_SECURE_BOOT_MIN_VERSION=1632136573
        update_version=$(strings "${WORKDIR}/${src_eeprom_bin}" | grep BUILD_TIMESTAMP | sed 's/.*=//g')
        if [ "${BOOTLOADER_SECURE_BOOT_MIN_VERSION}" -gt "${update_version}" ]; then
            bbfatal "Bootloader is not secure boot capable"
        fi

        # Configure for secure boot
        if grep -q "SIGNED_BOOT=" "${boot_conf}"; then
            sed -i 's/SIGNED_BOOT=.*/SIGNED_BOOT=1/g' "${boot_conf}"
        else
            echo "SIGNED_BOOT=1" >> "${boot_conf}"
        fi

        # Configure for self-update so that the EEPROM can be updated in secure boot mode
        if grep -q "ENABLE_SELF_UPDATE=" "${boot_conf}"; then
            sed -i 's/ENABLE_SELF_UPDATE=.*/ENABLE_SELF_UPDATE=1/g' "${boot_conf}"
        else
            echo "ENABLE_SELF_UPDATE=1" >> "${boot_conf}"
        fi

        # Sign the configuratin file
        do_sign_rsa "${boot_conf}" "${boot_conf}.sig"

        # Merge the configuration file into the firmware
        ${PYTHON} "${WORKDIR}/rpi-eeprom-config" --config "${boot_conf}" --digest "${boot_conf}.sig" \
              --out "${WORKDIR}/${tgt_eeprom_bin}" --pubkey "${DEPLOY_DIR_IMAGE}/balena-keys/rsa.pem" "${WORKDIR}/${src_eeprom_bin}"

        # Sign the firmware
        do_sign_rsa "${WORKDIR}/${tgt_eeprom_bin}" "${WORKDIR}/${tgt_eeprom_bin%.bin}.sig"
    fi
}

do_compile[network] = "1"
do_compile[depends] += " \
    curl-native:do_populate_sysroot \
    jq-native:do_populate_sysroot \
    ca-certificates-native:do_populate_sysroot \
    coreutils-native:do_populate_sysroot \
    python3-pycryptodomex-native:do_populate_sysroot \
    balena-keys:do_deploy \
"
do_compile[vardeps] = "SIGN_API"

do_deploy:append() {
    if [ "x${SIGN_API}" != "x" ]; then
        install -d ${DEPLOY_DIR_IMAGE}/rpi-eeprom/secure-boot-lock
        cp -avL ${S}/${FIRMWARE}/stable/recovery.bin ${DEPLOY_DIR_IMAGE}/rpi-eeprom/secure-boot-lock/bootcode4.bin
        echo "uart_2ndstage=1" > ${DEPLOY_DIR_IMAGE}/rpi-eeprom/secure-boot-lock/config.txt
        echo "eeprom_write_protect=1" >> ${DEPLOY_DIR_IMAGE}/rpi-eeprom/secure-boot-lock/config.txt
        echo "program_pubkey=1" >> ${DEPLOY_DIR_IMAGE}/rpi-eeprom/secure-boot-lock/config.txt
        echo "revoke_devkey=1" >> ${DEPLOY_DIR_IMAGE}/rpi-eeprom/secure-boot-lock/config.txt
        echo "program_jtag_lock=1" >> ${DEPLOY_DIR_IMAGE}/rpi-eeprom/secure-boot-lock/config.txt
        cp -av ${WORKDIR}/pieeprom-latest-stable*bin ${DEPLOY_DIR_IMAGE}/rpi-eeprom/secure-boot-lock/pieeprom.bin
        cp -av ${WORKDIR}/pieeprom-latest-stable*sig ${DEPLOY_DIR_IMAGE}/rpi-eeprom/secure-boot-lock/pieeprom.sig
    fi
}
