FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

SRC_URI += " \
    file://os-helpers-otp \
    file://os-helpers-sb \
"

RDEPENDS:${PN}-sb = "os-helpers-otp"
RDEPENDS:${PN}-otp = "userlandtools"

PACKAGES += " \
	${PN}-otp \
"

DEVICE_TREES:raspberrypicm4-ioboard = "\
    bcm2711-rpi-400.dtb \
    bcm2711-rpi-4-b.dtb \
    bcm2711-rpi-cm4.dtb \
"

DEVICE_TREES:raspberrypi5 = "\
    bcm2712d0-rpi-5-b.dtb \
    bcm2712-rpi-500.dtb \
    bcm2712-rpi-5-b.dtb \
    bcm2712-rpi-cm5-cm4io.dtb \
    bcm2712-rpi-cm5-cm5io.dtb \
    bcm2712-rpi-cm5l-cm4io.dtb \
    bcm2712-rpi-cm5l-cm5io.dtb \
"

do_install:append() {
	install -m 0775 ${WORKDIR}/os-helpers-otp ${D}${libexecdir}
	install -m 0775 ${WORKDIR}/os-helpers-sb ${D}${libexecdir}
	sed -i -e "s,@@DEVICE_TREES@@,${DEVICE_TREES},g" ${D}${libexecdir}/os-helpers-sb
	sed -i -e "s,@@KERNEL_IMAGETYPE@@,${KERNEL_IMAGETYPE},g" ${D}${libexecdir}/os-helpers-sb
	sed -i -e "s,@@BALENA_IMAGE_FLAG_FILE@@,${BALENA_IMAGE_FLAG_FILE},g" ${D}${libexecdir}/os-helpers-sb
}

FILES:${PN}-otp = "${libexecdir}/os-helpers-otp"
