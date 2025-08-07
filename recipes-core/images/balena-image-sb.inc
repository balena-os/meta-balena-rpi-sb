# Increase boot partition size
BALENA_BOOT_SIZE:raspberrypicm4-ioboard-sb = "174080"

BALENA_ESSENTIAL_BOOT_FILES:append:raspberrypi4-64 = " \
    cmdline.txt  \
    config.txt  \
    fixup4cd.dat  \
    fixup4.dat  \
    fixup4x.dat  \
    start4cd.elf \
    start4.elf \
    start4x.elf \
    ${SDIMG_KERNELIMAGE} \
    ${KERNEL_IMAGETYPE} \
    "
do_rootfs[vardeps] += "${@oe.utils.conditional('SIGN_API','','','BALENA_ESSENTIAL_BOOT_FILES',d)}"

BALENA_BOOT_PARTITION_FILES:remove:raspberrypicm4-ioboard-sb = " \
    u-boot.bin:/${SDIMG_KERNELIMAGE} \
    boot.scr:/boot.scr \
    "

BALENA_BOOT_PARTITION_FILES:append:raspberrypicm4-ioboard-sb = " \
    balena-bootloader/${KERNEL_IMAGETYPE}-initramfs-${MACHINE}.bin:/${SDIMG_KERNELIMAGE} \
    balena-bootloader/bootenv:/bootenv \
    "

BALENA_BOOT_PARTITION_FILES:append:raspberrypi4-64 = "${@oe.utils.conditional('SIGN_API','','',' rpi-eeprom/pieeprom-latest-stable.sig:/pieeprom-latest-stable.sig',d)}"

IMAGE_INSTALL:remove:raspberrypicm4-ioboard-sb = " u-boot"
IMAGE_INSTALL:append:raspberrypicm4-ioboard-sb = " grub-editenv"

do_rootfs[depends] += "${@oe.utils.conditional('MACHINE','raspberrypicm4-ioboard-sb',' virtual/balena-bootloader:do_deploy','',d)}"
do_image_balenaos_img[depends] += "${@oe.utils.conditional('MACHINE','raspberrypicm4-ioboard-sb',' virtual/balena-bootloader:do_deploy','',d)}"

IMAGE_ROOTFS_SIZE:raspberrypicm4-ioboard-sb="655360"

inherit image-sign-rpi
