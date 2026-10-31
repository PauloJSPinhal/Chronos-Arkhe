#!/usr/bin/env bash
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAUTILUS_DIR="${HOME}/.local/share/nautilus/scripts"

echo "Ativando script do Nautilus para Chronos Arkhe..."

mkdir -p "${NAUTILUS_DIR}"
ln -sfr "${REPO_ROOT}/bin/chronos-arkhe" "${NAUTILUS_DIR}/Chronos Arkhe"

echo "✅ Script do Nautilus ativado em: ${NAUTILUS_DIR}/Chronos Arkhe"
