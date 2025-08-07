FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://cryptsetup-rpi \
"

do_install:append() {
	install -d ${D}/init.d

	install -m 0755 ${WORKDIR}/cryptsetup-rpi ${D}/init.d/72-cryptsetup
	sed -i -e "s/@@BALENA_NONENC_BOOT_LABEL@@/${BALENA_NONENC_BOOT_LABEL}/g" ${D}/init.d/72-cryptsetup
}

RDEPENDS:initramfs-module-cryptsetup:append = " os-helpers-otp gnupg"

