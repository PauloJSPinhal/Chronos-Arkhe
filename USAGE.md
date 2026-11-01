# Chronos Arkhe v6.0 — Manual de Utilização

Aplicação GTK3 para organizar automaticamente fotografias em coleções por data de captura (EXIF). Suporta múltiplos formatos de imagem e RAWs, sidecars de edição e integração nativa no gestor de ficheiros **Nautilus**. Integra a suite fotográfica **Chronos** (*Arkhe*, *Nomos*, *Sfragis*, *Gnosis*).

## 🚀 Destaques da v6.0

- **Aplicação GTK3 completa** — Interface com navegador de ficheiros integrado, lista de seleção e botão **Selecionar Tudo**
- **Diálogo por Coleção/Data com Preview** — Navegação `◀`/`▶` pelas fotos de cada data, auto-completar de Evento/Local e pré-visualização do nome da pasta
- **Arquitetura de classes** — `ChronosArkheApp(Gtk.Window)`, padrão unificado da suite Chronos
- **Processamento assíncrono** — Worker em thread separada com sincronização segura (`GLib.idle_add`)
- **Logging e Progress Bar em tempo real** — Acompanhamento detalhado de cada coleção criada
- **Cancelamento seguro** — Interrompe a operação sem corromper ficheiros
- **Botão Mover/Copiar** — Alterna entre copiar ficheiros (padrão) ou movê-los
- **Configuração centralizada XDG** — `~/.config/chronos/arkhe.json` (com migração automática do histórico v5.x)
- **Integração Nautilus** — Disponível no menu de contexto (*Scripts → Chronos Arkhe*)

## 📦 Instalação

### Pré-requisitos

```bash
# Dependências principais (Debian / Ubuntu)
sudo apt install python3 python3-gi python3-gi-cairo gir1.2-gtk-3.0 python3-pil

# Recomendado para RAWs e EXIF avançado
sudo apt install python3-exifread libimage-exiftool-perl
```

### Instalar Localmente (sem root)

```bash
cd Chronos-Arkhe
./scripts/install.sh
```

O instalador:
- Copia o binário para `~/.local/bin/chronos-arkhe`
- Regista a aplicação em `~/.local/share/applications/chronos-arkhe.desktop`
- Instala o ícone vetorial em `~/.local/share/icons/hicolor/scalable/apps/chronos-arkhe.svg`
- Cria a ligação para o Nautilus em `~/.local/share/nautilus/scripts/Chronos Arkhe`

> 💡 **Execução direta**: `./scripts/run.sh` executa a partir do código-fonte verificando as dependências.
>
> 📦 **Pacote Debian**: `./scripts/build-deb.sh` gera `build/chronos-arkhe_6.0.0_all.deb`.

### Desinstalar

```bash
./scripts/uninstall.sh
```

## 🎯 Como Usar

### Modo Aplicação (Interface Gráfica)

Procura por **"Chronos Arkhe"** no menu de aplicações ou executa:

```bash
chronos-arkhe
```

1. **Navegar e selecionar fotos (`OrigensFileBrowser`)** — Na barra lateral esquerda tens acesso direto às origens permitidas: **`Imagens (~/Imagens)`**, **`Transferências (~/Transferências)`**, **Pendrives/Cartões SD** (`/media/$USER`, `/run/media/$USER`) e **Câmaras USB** (`/run/user/$UID/gvfs`). Podes selecionar fotos individuais, selecionar uma subpasta, fazer duplo clique para navegar por subpastas ou clicar em **Selecionar Tudo**.
2. **Escolher pasta de destino (em `~/Imagens`)** — Clica em **Procurar...** para escolher `~/Imagens` ou qualquer subpasta dentro de `~/Imagens` (inclui o botão **➕ Nova Subpasta** para criar novas subpastas).
3. **Configurar opções**:
   - ☑️ **Pedir Evento e Local para cada data (coleção)**
   - 🔄 **Copiar (padrão)** ou **Mover ficheiros**
   - 🛡️ **Origens e Excepções...** (gerir origens permitidas e pastas indesejadas)
4. **Iniciar Organização** — Clica em **Iniciar Organização** e preenche o Evento e Local para cada data.

### Modo Nautilus (Menu de Contexto)

1. Seleciona as fotos (ou uma pasta de fotos) no Nautilus.
2. Clica com o botão direito → **Scripts** → **Chronos Arkhe**.
3. As fotos aparecem automaticamente carregadas na aplicação; confirma o destino e clica em **Iniciar Organização**.

> 💡 Se o script não aparecer no menu, ativa-o com `./scripts/enable-nautilus-script.sh` e reinicia o Nautilus (`nautilus -q`).

### Modo Linha de Comando

```bash
# Ficheiros específicos
chronos-arkhe /caminho/para/foto1.jpg /caminho/para/foto2.jpg

# Com wildcard ou pasta inteira
chronos-arkhe ~/Fotos/*.jpg
chronos-arkhe ~/Fotos/CartaoSD/

# Modo debug (mostra diagnóstico EXIF detalhado no terminal)
chronos-arkhe --debug ~/Fotos/*.jpg
```

## 📋 Formato de Organização

As fotos são agrupadas por data de captura em pastas com o formato:

```text
AAAAMMDD_Evento_Local/
├── foto1.jpg
├── foto1.xmp (sidecar, se existir)
├── foto2.jpg
└── ...
```

**Exemplo:**
```text
20260615_Casamento_Igreja-Matriz/
├── IMG_0001.jpg
├── IMG_0001.xmp
├── IMG_0002.jpg
└── ...
```

Regras de formatação:
- `AAAAMMDD` — Data de captura EXIF (`DateTimeOriginal` / `DateTimeDigitized`)
- `Evento` — Nome do evento sanitizado (espaços e underscores internos convertidos em `-`, acentos preservados)
- `Local` — Nome do local sanitizado (espaços e underscores internos convertidos em `-`, acentos preservados)

## 🔍 Extração EXIF

O **Chronos Arkhe** extrai a data de captura seguindo esta ordem de prioridade:

1. **Pillow (`getexif` + sub-IFD `0x8769`)** — Rápido e nativo para JPEG, PNG, TIFF e WebP
2. **exifread** — Leitura direta de tags EXIF para formatos RAW (Canon CR2/CR3, Nikon NEF, Sony ARW, DNG, etc.)
3. **exiftool** — Fallback externo para metadados EXIF não-padrão
4. **mtime** — Último recurso (data de modificação do ficheiro no sistema de ficheiros)

## 📊 Sidecars Suportados

Ficheiros de edição não-destrutiva associados (`nome.ext` ou `nome.jpg.ext`) são copiados/movidos em conjunto com a fotografia principal:

- `*.xmp` — Darktable, Lightroom, Adobe Camera Raw
- `*.pp3` — RawTherapee
- `*.dop` — DxO PhotoLab

## 🔧 Configuração e Histórico

A configuração e o histórico são guardados em:

```text
~/.config/chronos/arkhe.json
```

Formato:
```json
{
  "ultima_pasta": "/home/utilizador/Imagens",
  "ultima_pasta_origem": "/home/utilizador/Imagens",
  "eventos": ["Casamento", "Férias", "Família"],
  "locais": ["Igreja Matriz", "Praia", "Casa"],
  "restringir_origens": true,
  "origens_permitidas": [
    "/home/utilizador/Imagens",
    "/home/utilizador/Transferências",
    "/media/utilizador",
    "/run/media/utilizador",
    "/run/user/1000/gvfs"
  ],
  "pastas_excluidas": [
    ".git",
    ".cache",
    ".local",
    ".config",
    ".Trash",
    ".Trash-*",
    "System Volume Information",
    "$RECYCLE.BIN",
    "LOST.DIR",
    "node_modules",
    "__pycache__",
    "/proc",
    "/sys",
    "/dev"
  ],
  "ask_mode": true,
  "usar_move": false
}
```

> **`restringir_origens` e `origens_permitidas`**: quando ativo (`true`), aceita fotos apenas de `~/Imagens`, `~/Transferências` (e respetivas subpastas), pendrives/cartões SD (`/media/$USER`, `/run/media/$USER`) e câmaras fotográficas USB (`/run/user/$UID/gvfs`), rejeitando todas as restantes pastas do sistema. A **Pasta de Destino** aceita exclusivamente pastas em `~/Imagens`.
>
> **`pastas_excluidas`**: lista de nomes de pastas (ou padrões glob como `.Trash-*`) e caminhos absolutos/com `~` onde a aplicação oculta e bloqueia a navegação e leitura de ficheiros (incluindo pastas de sistema dentro de cartões SD e pendrives). Tudo pode ser gerido na interface pelo botão **"🛡️ Origens e Excepções..."**.

> Se existir um ficheiro legado `~/.config/organizar_fotos/historico.json` (de versões 5.x), as listas de eventos, locais e última pasta são migradas automaticamente.

## 🐛 Resolução de Problemas

### "Seleciona pelo menos uma foto válida para organizar"
- Seleciona ficheiros suportados (`.jpg`, `.png`, `.tiff`, `.cr2`, `.nef`, etc.) ou abre uma pasta que contenha fotografias e clica em **Selecionar Tudo**.

### Aviso "Todas as fotos foram agrupadas na mesma data"
- Surge quando mais de 3 fotos recaem numa única data usando `mtime` (sem EXIF).
- Verifica os metadados com `chronos-arkhe --debug foto.jpg` ou `exiftool -DateTimeOriginal foto.jpg`.
- Instala `python3-exifread` e `libimage-exiftool-perl` para suporte completo a RAWs.

## 📄 Licença e Contribuições

- Licença: [LICENSE](./LICENSE)
- Guia de Contribuição: [CONTRIBUTING.md](./CONTRIBUTING.md)
