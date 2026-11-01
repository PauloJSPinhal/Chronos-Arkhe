#!/usr/bin/env bash
set -e

# Determinar a raiz do repositório (uma pasta acima da pasta scripts/)
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PREFIX="${HOME}/.local"
BIN_DIR="${PREFIX}/bin"
APP_DIR="${PREFIX}/share/applications"
ICON_BASE="${PREFIX}/share/icons/hicolor"
ICON_DIR="${ICON_BASE}/scalable/apps"
NAUTILUS_DIR="${PREFIX}/share/nautilus/scripts"
CONFIG_DIR="${HOME}/.config/chronos"
CONFIG_FILE="${CONFIG_DIR}/arkhe.json"
LEGACY_CONFIG="${HOME}/.config/organizar_fotos/historico.json"

echo "Instalando Chronos Arkhe..."

# 1. Criar pastas de destino (incluindo ~/.config/chronos)
install -d "${BIN_DIR}" "${APP_DIR}" "${ICON_DIR}" "${NAUTILUS_DIR}" "${CONFIG_DIR}"

# 2. Inicializar ou migrar configuração em ~/.config/chronos/arkhe.json
if [ ! -f "${CONFIG_FILE}" ]; then
    if [ -f "${LEGACY_CONFIG}" ]; then
        echo "Migrando histórico existente para ${CONFIG_FILE}..."
        cp "${LEGACY_CONFIG}" "${CONFIG_FILE}"
    else
        cat > "${CONFIG_FILE}" <<EOF
{
  "ultima_pasta": "${HOME}/Imagens",
  "ultima_pasta_origem": "${HOME}",
  "eventos": [],
  "locais": [],
  "pastas_excluidas": [
    ".git",
    ".cache",
    ".local",
    ".config",
    ".thumbnails",
    ".Trash",
    ".Trash-1000",
    "node_modules",
    "__pycache__",
    "venv",
    ".venv",
    "lost+found",
    "/proc",
    "/sys",
    "/dev",
    "/run",
    "/var",
    "/etc",
    "/usr",
    "/boot",
    "/root"
  ],
  "ask_mode": true,
  "usar_move": false
}
EOF
    fi
fi

# 3. Instalar binário
install -m 755 "${REPO_ROOT}/bin/chronos-arkhe" "${BIN_DIR}/chronos-arkhe"

# 4. Instalar lançador .desktop e ícone SVG
install -m 644 "${REPO_ROOT}/data/chronos-arkhe.desktop" "${APP_DIR}/chronos-arkhe.desktop"
install -m 644 "${REPO_ROOT}/data/icons/hicolor/scalable/apps/chronos-arkhe.svg" "${ICON_DIR}/chronos-arkhe.svg"

# 5. Criar ligação simbólica para o Nautilus
ln -sfr "${BIN_DIR}/chronos-arkhe" "${NAUTILUS_DIR}/Chronos Arkhe"

# 6. Garantir existência de index.theme local
if [ ! -f "${ICON_BASE}/index.theme" ] && [ -f /usr/share/icons/hicolor/index.theme ]; then
    install -m 644 /usr/share/icons/hicolor/index.theme "${ICON_BASE}/index.theme"
fi

# 7. Forçar atualização e indexação no GNOME / FreeDesktop
echo "Atualizando caches do ambiente gráfico..."
touch "${ICON_BASE}"
gtk-update-icon-cache -f -t "${ICON_BASE}" 2>/dev/null || true
update-desktop-database "${APP_DIR}" 2>/dev/null || true
xdg-desktop-menu forceupdate 2>/dev/null || true

echo "Instalação concluída com sucesso! Configuração guardada em: ${CONFIG_FILE}"
