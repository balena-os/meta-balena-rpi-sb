# Enable the dwc2 driver
BALENA_CONFIGS:append:raspberrypicm4-ioboard = " dwc2 no_pci"
BALENA_CONFIGS[dwc2] = "CONFIG_USB_DWC2=y"

# Match the OS kernel: no PCI/PCIe in the balena bootloader either.
BALENA_CONFIGS[no_pci] = " \
    CONFIG_PCI=n \
"
