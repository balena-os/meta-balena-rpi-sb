CMDLINE:prepend:raspberrypicm4-ioboard = " ${@bb.utils.contains('DISTRO_FEATURES','osdev-image',"earlycon=uart8250,mmio32,0xfe215040 console=tty1","",d)}"
# TODO: test easrly console
CMDLINE:prepend:raspberrypi5 = " ${@bb.utils.contains('DISTRO_FEATURES','osdev-image',"earlycon=uart8250,mmio32,0x7e215040 console=tty1","",d)}"
CMDLINE += "${OS_KERNEL_CMDLINE} ${@oe.utils.conditional('SIGN_API','','',"${OS_KERNEL_SECUREBOOT_CMDLINE}",d)}"

# Necessary for balena bootloader to work
# These will not be passed to the actual kernel
CMDLINE:append := " balena_stage2"

# TODO: test whether the RPI5 does not need this
CMDLINE:append := " nr_cpus=1"
