# Chronos Arkhe

Aplicação nativa GTK3/GNOME e script de contexto para o **Nautilus** concebida para a organização segura de acervos fotográficos em coleções por data de captura (EXIF), com suporte a modo cópia/movimento, pré-visualização de miniaturas, diálogo de identificação de Evento e Local por coleção com histórico inteligente, e logging em tempo real.

Integra a suite fotográfica **Chronos** (*Arkhe*, *Nomos*, *Sfragis*, *Gnosis*).

---

## 📋 Padrão de Organização

O **Chronos Arkhe** agrupa as fotografias por data de captura e estrutura as pastas das coleções segundo o padrão:

```text
{AAAAMMDD}_{Evento}_{Local}/
├── foto1.jpg
├── foto2.jpg
└── foto3.jpg
```

### Exemplo Prático:

```text
20261031_Reunião_SCP/
├── IMG_001.JPG
├── IMG_002.JPG
└── RAW_001.CR2

20261030_Passeio-de-Outono_Praia-da-Rocha/
├── DSCF001.JPG
├── DSCF002.JPG
└── DSCF002.JPG.xmp  (sidecar preservado)
```

### Componentes:
* **`{AAAAMMDD}`**: Carimbo temporal obtido a partir dos metadados EXIF da imagem (`DateTimeOriginal` / `DateTimeDigitized`). Se o EXIF estiver ausente, recorre à data de modificação do ficheiro (`mtime`).
* **`{Evento}`**: Classificação do evento/coleção (ex.: `Reunião`, `Passeio de Outono`, `Trabalho`). Guardado em histórico para auto-completar.
* **`{Local}`**: Localização geográfica (ex.: `SCP`, `Praia da Rocha`, `Lisboa`). Guardado em histórico para auto-completar.

---

## ✨ Funcionalidades

* **Agrupamento por Coleção/Data EXIF:** Organiza fotos pela data real de captura (`Pillow` sub-IFD EXIF `0x8769` → `exifread` → `exiftool` → `mtime`).
* **Diálogo por Data com Preview:** Para cada data distinta encontrada, apresenta as miniaturas das fotos dessa coleção (com navegação `◀`/`▶`), campos de **Evento** e **Local** com auto-completar do histórico e pré-visualização em tempo real do nome da pasta.
* **Navegador Filtrado de Origens e Fotos (`OrigensFileBrowser`):** Disponibiliza diretamente na barra lateral apenas as origens autorizadas — **`~/Imagens`**, **`~/Transferências`** (e respetivas subpastas), **Pendrives / Cartões de Memória (SD)** (`/media/$USER`, `/run/media/$USER`) e **Máquinas Fotográficas USB** (`/run/user/$UID/gvfs`), com deteção automática ao ligar/desligar dispositivos (`Gio.VolumeMonitor`).
* **Destino Restrito a `~/Imagens`:** Garante que as coleções organizadas são guardadas exclusivamente em `~/Imagens` ou numa subpasta de `~/Imagens` (com opção **➕ Nova Subpasta** integrada no seletor de destino).
* **Toggle Copiar/Mover:** Alterna entre cópia (`shutil.copy2`, padrão seguro) e movimento (`shutil.move`) de ficheiros.
* **Suporte Automático a Sidecars:** Localiza e copia/move ficheiros `.xmp`, `.pp3` e `.dop` associados a cada fotografia.
* **Histórico e Configuração Persistente (XDG):** Guarda eventos, locais, última pasta de destino, última pasta de origem, `restringir_origens`, `origens_permitidas`, `pastas_excluidas` e preferências em `~/.config/chronos/arkhe.json` (com migração automática do histórico legado `~/.config/organizar_fotos/historico.json`).
* **Controlo de Origens e Pastas Indesejadas:** Oculta e bloqueia pastas fora de `origens_permitidas` bem como pastas de sistema/lixo definidas em `pastas_excluidas` (ex.: `.git`, `System Volume Information`, `$RECYCLE.BIN`, `LOST.DIR`, `.Trash-*`), configuráveis no botão **🛡️ Origens e Excepções...** ou em `~/.config/chronos/arkhe.json`.
* **Logging e Barra de Progresso em Tempo Real:** Painel de log e `Gtk.ProgressBar` acompanham cada passo da operação.
* **Processamento Assíncrono e Cancelamento Seguro:** Worker em thread dedicada (`_worker`) mantendo a interface responsiva e permitindo interromper a operação a qualquer momento.
* **Duplo Modo de Utilização:** Funciona como aplicação autónoma no menu do sistema ou a partir do menu de contexto do **Nautilus** (*Scripts → Chronos Arkhe*) e linha de comando.

---

## 📦 Estrutura do Projeto

```text
Chronos-Arkhe/
├── bin/
│   └── chronos-arkhe              # Executável principal Python/GTK3
├── data/
│   ├── chronos-arkhe.desktop      # Entrada XDG Desktop
│   └── icons/
│       └── hicolor/
│           └── scalable/
│               └── apps/
│                   └── chronos-arkhe.svg  # Ícone vetorial oficial
├── debian/                        # Metadados de empacotamento Debian
│   ├── control
│   ├── postinst
│   └── prerm
├── docs/                          # Documentação e recursos visuais
│   ├── REORGANIZACAO_ESTRUTURAL.md
│   ├── RELATORIO_REORGANIZACAO.md
│   ├── chronos-arkhe.jpeg
│   └── dev/                       # Documentação técnica interna
│       ├── REFACTORING_v6.0.md
│       ├── COMPARACAO_VERSOES.md
│       └── VERIFICACAO_v6.0.md
├── scripts/                       # Scripts de instalação e utilitários
│   ├── install.sh                 # Instalador local (~/.local)
│   ├── uninstall.sh               # Desinstalador local
│   ├── build-deb.sh               # Gerador de pacote .deb
│   ├── run.sh                     # Executor de desenvolvimento
│   ├── enable-nautilus-script.sh  # Ativa integração Nautilus
│   ├── disable-nautilus-script.sh # Desativa integração Nautilus
│   └── organizar-fotos-nautilus   # Wrapper de compatibilidade Nautilus
├── CHANGELOG.md                   # Histórico de versões
├── CONTRIBUTING.md                # Guia de contribuição
├── QUICK_START.md                 # Guia rápido de início
├── USAGE.md                       # Manual de utilização detalhado
├── .gitignore
├── LICENSE
└── README.md
```

---

## 🔧 Requisitos do Sistema

Distribuições baseadas em Debian / Ubuntu com GNOME:

```bash
sudo apt update
sudo apt install python3 python3-gi python3-gi-cairo gir1.2-gtk-3.0 python3-pil
```

### Dependências Recomendadas (RAWs e EXIF exótico):

```bash
# Para leitura nativa de EXIF em ficheiros RAW (CR2, NEF, ARW, DNG, etc.)
sudo apt install python3-exifread
# ou: pip install exifread

# Fallback universal para metadados EXIF
sudo apt install libimage-exiftool-perl
```

---

## 🚀 Instalação e Distribuição

### Opção 1: Instalação Local (utilizador atual, sem privilégios root)

Instala em `~/.local/bin`, cria o lançador em `~/.local/share/applications`, configura o ícone e ativa o script no Nautilus:

```bash
chmod +x scripts/install.sh scripts/uninstall.sh
./scripts/install.sh
```

Para remover a instalação local (preservando `~/.config/chronos/arkhe.json`, ou usando `--purge` para remover também a configuração):
```bash
./scripts/uninstall.sh
# ou: ./scripts/uninstall.sh --purge
```

---

### Opção 2: Empacotamento Nativo Debian (`.deb`)

Para gerar o pacote instalável ao nível do sistema:

```bash
chmod +x scripts/build-deb.sh
./scripts/build-deb.sh
```

O pacote gerado fica disponível em `build/chronos-arkhe_6.0.0_all.deb`. Para instalar:

```bash
sudo apt install ./build/chronos-arkhe_6.0.0_all.deb
```

Para desinstalar:
```bash
sudo apt remove chronos-arkhe
```

---

### Opção 3: Execução Direta do Código-Fonte

Para desenvolvimento e testes rápidos:

```bash
chmod +x scripts/run.sh
./scripts/run.sh
```

---

## 🖥️ Como Usar

### Como Aplicação Independente:
1. Abra o menu de aplicações do GNOME e procure por **Chronos Arkhe** (ou execute `chronos-arkhe` / `./scripts/run.sh`).
2. No navegador à esquerda, abra a pasta com as fotografias e selecione as fotos pretendidas (ou clique em **Selecionar Tudo**).
3. Escolha a **Pasta de Destino** clicando em **Procurar...**.
4. Configure as opções:
   - **Pedir Evento e Local para cada data (coleção)** (ativo por defeito).
   - **Copiar (padrão)** ou **Mover ficheiros**.
5. Clique em **Iniciar Organização** e identifique o Evento e Local de cada data apresentada.

### Via Menu de Contexto do Nautilus:
1. No gestor de ficheiros **Nautilus**, selecione as fotos ou a pasta a organizar.
2. Clique com o botão direito → **Scripts** → **Chronos Arkhe**.
3. Confirme a pasta de destino e clique em **Iniciar Organização**.

### Via Linha de Comando:
```bash
# Organizar fotos específicas ou pastas
chronos-arkhe ~/Fotos/*.jpg

# Modo de diagnóstico EXIF detalhado
chronos-arkhe --debug ~/Fotos/*.jpg
```

---

## 🖼️ Formatos Suportados

### Fotografias e RAWs (31 formatos):
- **Raster:** `.jpg`, `.jpeg`, `.png`, `.tiff`, `.tif`, `.webp`, `.bmp`, `.gif`
- **RAW:** `.cr2`, `.cr3`, `.nef`, `.arw`, `.dng`, `.orf`, `.rw2`, `.pef`, `.srw`, `.raf`, `.3fr`, `.iiq`, `.kdc`, `.mos`, `.mef`, `.nrw`, `.ptx`, `.r3d`, `.rwl`, `.sr2`, `.srf`, `.gpr`, `.erf`

### Sidecars (Metadados Não-Destrutivos):
- **Darktable / Lightroom / Adobe Camera Raw:** `.xmp` (`foto.xmp` e `foto.ext.xmp`)
- **RawTherapee:** `.pp3`
- **DxO PhotoLab:** `.dop`

---

## 🔍 Sanitização Inteligente

Os nomes de Evento e Local são guardados em texto cru no histórico JSON (para preservar a escrita original no auto-completar) e sanitizados apenas na criação do nome da pasta:
- Converte espaços e underscores internos em hífens (`Fim de semana` → `Fim-de-semana`).
- **Preserva acentos e caracteres alfanuméricos Unicode** (`Trás-os-Montes` → `Trás-os-Montes`, `São João!!` → `São-João`).
- Colapsa hífens duplicados e remove pontuação inválida.

---

## 🤝 Contribuir

Consulte o guia [CONTRIBUTING.md](./CONTRIBUTING.md) para instruções de desenvolvimento, estilo de código e testes.
Issues e sugestões: [PauloJSPinhal/Chronos-Arkhe](https://github.com/PauloJSPinhal/Chronos-Arkhe).

---

## 📄 Licença

Distribuído sob a licença **MIT**. Consulte o ficheiro [LICENSE](./LICENSE) para mais detalhes.
