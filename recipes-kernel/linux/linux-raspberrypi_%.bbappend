# CM4 has no IOMMU. Keep the PCI/PCIe stack out of the kernel so a
# bus-master on the slot cannot DMA secrets even if the DT node is re-enabled.
# Onboard USB2, Ethernet and WiFi do not use PCI.
BALENA_CONFIGS[no_pci] = " \
    CONFIG_PCI=n \
"

BALENA_CONFIGS:append:raspberrypicm4-ioboard = " dwc2 no_pci"
BALENA_CONFIGS[dwc2] = "CONFIG_USB_DWC2=y"
