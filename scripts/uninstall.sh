#!/usr/bin/env bash
set -e

PREFIX="${HOME}/.local"
ICON_BASE="${PREFIX}/share/icons/hicolor"

echo "Desinstalando Chronos Arkhe..."

rm -f "${PREFIX}/bin/chronos-arkhe"
rm -f "${PREFIX}/share/applications/chronos-arkhe.desktop"
rm -f "${ICON_BASE}/scalable/apps/chronos-arkhe.svg"
rm -f "${PREFIX}/share/nautilus/scripts/Chronos Arkhe"

# Forçar atualização após remoção
touch "${ICON_BASE}" 2>/dev/null || true
gtk-update-icon-cache -f -t "${ICON_BASE}" 2>/dev/null || true
update-desktop-database "${PREFIX}/share/applications" 2>/dev/null || true
xdg-desktop-menu forceupdate 2>/dev/null || true

echo "Desinstalação concluída!"
