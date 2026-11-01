#!/usr/bin/env bash
set -e

PREFIX="${HOME}/.local"
ICON_BASE="${PREFIX}/share/icons/hicolor"
CONFIG_DIR="${HOME}/.config/chronos"
CONFIG_FILE="${CONFIG_DIR}/arkhe.json"

echo "Desinstalando Chronos Arkhe..."

rm -f "${PREFIX}/bin/chronos-arkhe"
rm -f "${PREFIX}/share/applications/chronos-arkhe.desktop"
rm -f "${ICON_BASE}/scalable/apps/chronos-arkhe.svg"
rm -f "${PREFIX}/share/nautilus/scripts/Chronos Arkhe"

# Se for passado --purge, remove também a configuração desta aplicação em ~/.config/chronos
if [ "${1:-}" = "--purge" ]; then
    rm -f "${CONFIG_FILE}"
    rmdir "${CONFIG_DIR}" 2>/dev/null || true
    echo "🗑️  Configuração removida: ${CONFIG_FILE}"
elif [ -f "${CONFIG_FILE}" ]; then
    echo "ℹ️  Configuração e histórico preservados em: ${CONFIG_FILE} (usa '--purge' para remover)"
fi

# Forçar atualização após remoção
touch "${ICON_BASE}" 2>/dev/null || true
gtk-update-icon-cache -f -t "${ICON_BASE}" 2>/dev/null || true
update-desktop-database "${PREFIX}/share/applications" 2>/dev/null || true
xdg-desktop-menu forceupdate 2>/dev/null || true

echo "Desinstalação concluída!"
