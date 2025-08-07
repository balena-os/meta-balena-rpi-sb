do_deploy:append:raspberrypicm4-ioboard-sb() {
    echo "dtoverlay=dwc2,dr_mode=host" >> ${DEPLOYDIR}/bootfiles/config.txt
    # Remap audio pins to free GPIOs 40/41 for SPI0 EEPROM programming
    echo "dtoverlay=audremap" >> ${DEPLOYDIR}/bootfiles/config.txt
}
