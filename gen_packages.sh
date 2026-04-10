#!/bin/bash
set -e

PACKAGE_NAME="ucentral-schema"
PACKAGE_VERSION="${repo_ucentral_schema_tag:-1.0}"

DEB_BUILD_DIR="debian/"
DEB_OUT="${DEBDIR}/${PACKAGE_NAME}_${PACKAGE_VERSION}_${DESTARCH}.deb"

echo "==> Assembling package staging tree..."
rm -rf "${DEB_BUILD_DIR}"
mkdir -p "${DEB_BUILD_DIR}/DEBIAN"
mkdir -p "${DEB_BUILD_DIR}/usr/share/ucentral"

cp -r ./renderer/* ${DEB_BUILD_DIR}/usr/share/ucentral/ && \
install -m 0755 ./schemareader.uc "${DEB_BUILD_DIR}/usr/share/ucentral/"

cat > "${DEB_BUILD_DIR}/DEBIAN/control" <<EOF
Package: ${PACKAGE_NAME}
Version: ${PACKAGE_VERSION}
Architecture: ${DESTARCH}
Maintainer: kmk18 <alex18_huang@accton.com>
Section: net
Priority: optional
Description: uCentral schema for OLG gateway devices
EOF

cat > "${DEB_BUILD_DIR}/DEBIAN/prerm" <<'EOF'
#!/usr/bin/env bash
set -e
rm -r /usr/share/ucentral/*
EOF
chmod 0755 "${DEB_BUILD_DIR}/DEBIAN/prerm"

echo "==> Building .deb..."
dpkg-deb --root-owner-group --build "${DEB_BUILD_DIR}" "${DEB_OUT}"

echo ""
echo "Package ready: ${DEB_OUT}"
