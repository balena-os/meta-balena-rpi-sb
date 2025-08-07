do_install:append() {
  if [ "x${SIGN_API}" != "x" ] && [ "${BALENA_SIGN_MSD}" = "1" ]; then
     install -d ${D}/secure-boot-msd/
     if ! do_sign_rsa "${S}/secure-boot-msd/boot.img" "${D}/secure-boot-msd/boot.sig"; then
        bbfatal "Failed to sign boot image"
     fi
     install -m 644 ${S}/secure-boot-msd/boot.img ${D}/secure-boot-msd/
     cp -av ${S}/secure-boot-msd/bootcode4.bin ${D}/secure-boot-msd/bootcode4.bin
  fi
}
