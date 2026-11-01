#!/usr/bin/env bash
set -e

# Determinar a raiz do repositório
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="${REPO_ROOT}/bin/chronos-arkhe"

# 1. Verificar dependências de sistema essenciais
if ! python3 -c "import gi; gi.require_version('Gtk', '3.0')" >/dev/null 2>&1; then
    echo "❌ Erro: Bibliotecas PyGObject / GTK3 em falta. Instala com: sudo apt install python3-gi gir1.2-gtk-3.0" >&2
    exit 1
fi

# Verificar Pillow (essencial para leitura EXIF primária e miniaturas)
if ! python3 -c "from PIL import Image" >/dev/null 2>&1; then
    echo "❌ Erro: Biblioteca Pillow em falta. Instala com: sudo apt install python3-pil (ou pip install Pillow)" >&2
    exit 1
fi

# Verificar exifread (opcional — fallback para RAWs)
if ! python3 -c "import exifread" >/dev/null 2>&1; then
    echo "⚠️  Aviso: exifread não encontrada. Para melhor suporte RAW instala com: sudo apt install python3-exifread (ou pip install exifread)" >&2
fi

# 2. Garantir permissões de execução no binário
if [ ! -x "${BIN}" ]; then
    chmod +x "${BIN}"
fi

echo "🚀 A iniciar Chronos Arkhe a partir do código-fonte..."

# 3. Executar o binário passando quaisquer argumentos fornecidos (pastas ou ficheiros)
exec "${BIN}" "$@"
