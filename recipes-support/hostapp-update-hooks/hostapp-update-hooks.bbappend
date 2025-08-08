HOSTAPP_HOOKS:remove:raspberrypicm4-ioboard-sb = "99-resin-uboot 999-resin-boot-cleaner"
HOSTAPP_HOOKS:append:raspberrypicm4-ioboard-sb = " 99-balena-bootloader"

do_install:append:raspberrypi4-64 () {
    if [ "x${SIGN_API}" != "x" ]; then
        install -m 0755 1-bootfiles ${D}${sysconfdir}/hostapp-update-hooks.d/2-rpifiles
        sed -i -e 's:@BALENA_BOOT_FINGERPRINT@:${BALENA_BOOT_FINGERPRINT}:g;' \
          ${D}${sysconfdir}/hostapp-update-hooks.d/2-rpifiles
        sed -i -e 's:@BALENA_BOOTFILES_BLACKLIST@:${BALENA_BOOTFILES_BLACKLIST}:g;' \
          ${D}${sysconfdir}/hostapp-update-hooks.d/2-rpifiles
    fi
}
