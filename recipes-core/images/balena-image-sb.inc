# Increase boot partition size
BALENA_BOOT_SIZE = "174080"
# Required machine overrides
BALENA_BOOT_SIZE:raspberrypi5 = "174080"


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

# TODO: bootcode.bin is also in tmp/deploy/raspberrpy5/bootfiles but RPI5 should not need it
BALENA_ESSENTIAL_BOOT_FILES:append:raspberrypi5 = " \
    cmdline.txt  \
    config.txt  \
    fixup_cd.dat  \
    fixup.dat  \
    fixup_x.dat  \
    start_cd.elf \
    start.elf \
    start_x.elf \
    ${SDIMG_KERNELIMAGE} \
    ${KERNEL_IMAGETYPE} \
    "

do_rootfs[vardeps] += "${@oe.utils.conditional('SIGN_API','','','BALENA_ESSENTIAL_BOOT_FILES',d)}"

BALENA_BOOT_PARTITION_FILES:remove = " \
    u-boot.bin:/${SDIMG_KERNELIMAGE} \
    boot.scr:/boot.scr \
    "

BALENA_BOOT_PARTITION_FILES:append = " \
    balena-bootloader/${KERNEL_IMAGETYPE}-initramfs-${MACHINE}.bin:/${SDIMG_KERNELIMAGE} \
    balena-bootloader/bootenv:/bootenv \
    "

BALENA_BOOT_PARTITION_FILES:append = "${@oe.utils.conditional('SIGN_API','','',' rpi-eeprom/pieeprom-latest-stable.sig:/pieeprom-latest-stable.sig',d)}"

IMAGE_INSTALL:remove = " u-boot"
IMAGE_INSTALL:append = " grub-editenv"

do_rootfs[depends] += " virtual/balena-bootloader:do_deploy"
do_image_balenaos_img[depends] += " virtual/balena-bootloader:do_deploy"

IMAGE_ROOTFS_SIZE ="655360"

inherit image-sign-rpi
