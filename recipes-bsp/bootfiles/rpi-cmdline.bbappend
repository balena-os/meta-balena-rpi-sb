CMDLINE:prepend:raspberrypicm4-ioboard = " ${@bb.utils.contains('DISTRO_FEATURES','osdev-image',"earlycon=uart8250,mmio32,0xfe215040 console=tty1","",d)}"
CMDLINE += "${@oe.utils.conditional('SIGN_API','','',"${OS_KERNEL_SECUREBOOT_CMDLINE}",d)}"

# Necessary for balena bootloader to work
# These will not be passed to the actual kernel
CMDLINE:append := " balena_stage2"
CMDLINE:append:raspberrypi4-64 := " nr_cpus=1"
