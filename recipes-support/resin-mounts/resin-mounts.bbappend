FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:raspberrypicm4-ioboard-sb = "\
  file://balena-rpi.service \
"

do_install:append:raspberrypicm4-ioboard-sb() {
  if [ "x${SIGN_API}" != "x" ]; then
    sed -i -e "s/@@BALENA_NONENC_BOOT_LABEL@@/${BALENA_NONENC_BOOT_LABEL}/g" "${D}${systemd_unitdir}/system/balena-rpi.service"
  fi
}
