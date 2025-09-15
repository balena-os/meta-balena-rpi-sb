PACKAGE_INSTALL:append = " initramfs-module-kexec-pi4-fwgpio"
IMAGE_ROOTFS_MAXSIZE = "65536"
# Required machine overrides
IMAGE_ROOTFS_MAXSIZE:raspberrypi4-64 = "65536"
IMAGE_ROOTFS_MAXSIZE:raspberrypi5 = "65536"
