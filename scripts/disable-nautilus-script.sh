#!/usr/bin/env bash
set -e

NAUTILUS_DIR="${HOME}/.local/share/nautilus/scripts"

echo "Desativando script do Nautilus para Chronos Arkhe..."

rm -f "${NAUTILUS_DIR}/Chronos Arkhe"

echo "✅ Script do Nautilus desativado"
