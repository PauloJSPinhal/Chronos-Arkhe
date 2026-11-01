#!/usr/bin/env bash
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PKG_NAME="chronos-arkhe"
VERSION="6.0.0"
ARCH="all"
BUILD_BASE="${REPO_ROOT}/build"
DEB_DIR="${BUILD_BASE}/${PKG_NAME}_${VERSION}_${ARCH}"

echo "🔨 A preparar estrutura do pacote .deb..."
rm -rf "${BUILD_BASE}"
install -d -m 755 "${DEB_DIR}/DEBIAN"
install -d -m 755 "${DEB_DIR}/usr/bin"
install -d -m 755 "${DEB_DIR}/usr/share/applications"
install -d -m 755 "${DEB_DIR}/usr/share/icons/hicolor/scalable/apps"
install -d -m 755 "${DEB_DIR}/usr/share/nautilus/scripts"
install -d -m 755 "${DEB_DIR}/usr/share/doc/${PKG_NAME}"
chmod 755 "${BUILD_BASE}" "${DEB_DIR}" "${DEB_DIR}/usr" "${DEB_DIR}/usr/share" "${DEB_DIR}/usr/share/icons" "${DEB_DIR}/usr/share/icons/hicolor" "${DEB_DIR}/usr/share/icons/hicolor/scalable" "${DEB_DIR}/usr/share/nautilus" "${DEB_DIR}/usr/share/doc"

# 1. Ficheiros de controlo Debian
install -m 644 "${REPO_ROOT}/debian/control" "${DEB_DIR}/DEBIAN/control"
install -m 755 "${REPO_ROOT}/debian/postinst" "${DEB_DIR}/DEBIAN/postinst"
install -m 755 "${REPO_ROOT}/debian/prerm" "${DEB_DIR}/DEBIAN/prerm"

# 2. Binário principal
install -m 755 "${REPO_ROOT}/bin/chronos-arkhe" "${DEB_DIR}/usr/bin/chronos-arkhe"

# 3. Desktop Entry e Ícone
install -m 644 "${REPO_ROOT}/data/chronos-arkhe.desktop" "${DEB_DIR}/usr/share/applications/chronos-arkhe.desktop"
install -m 644 "${REPO_ROOT}/data/icons/hicolor/scalable/apps/chronos-arkhe.svg" "${DEB_DIR}/usr/share/icons/hicolor/scalable/apps/chronos-arkhe.svg"

# 4. Documentação e Licença
install -m 644 "${REPO_ROOT}/README.md" "${DEB_DIR}/usr/share/doc/${PKG_NAME}/README.md"
install -m 644 "${REPO_ROOT}/LICENSE" "${DEB_DIR}/usr/share/doc/${PKG_NAME}/copyright"

echo "📦 A construir pacote com dpkg-deb..."
dpkg-deb --build --root-owner-group "${DEB_DIR}"
rm -rf "${DEB_DIR}"

echo "✅ Pacote gerado com sucesso em: ${BUILD_BASE}/${PKG_NAME}_${VERSION}_${ARCH}.deb"
