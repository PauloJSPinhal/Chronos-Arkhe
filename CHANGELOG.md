# Changelog

Todos os lançamentos notáveis do **Chronos Arkhe** (suite **Chronos**) são documentados neste ficheiro.

O formato segue [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e o projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

---

## [Unreleased]

### Planeado
- Diálogo de gestão de histórico (remover entradas antigas pela interface)
- Carregamento assíncrono de miniaturas em pastas com milhares de ficheiros
- Suite de testes automatizados (`pytest`)

---

## [6.0.0] — 2026-10-31

### Adicionado
- **Aplicação GTK3 completa** — Interface com navegador de ficheiros integrado, botão **Selecionar Tudo**, lista lateral interativa e pré-visualização de miniaturas
- **Diálogo de Coleção por Data (`_dialogo_por_data`)** — Executado de forma thread-safe na main thread (`_run_on_main_thread`), com navegação `◀`/`▶` pelas fotos daquela data, autocompletar de Evento e Local e pré-visualização em tempo real do nome da pasta (`AAAAMMDD_Evento_Local`)
- **Arquitetura de classes** — `ChronosArkheApp(Gtk.Window)`, alinhada com o padrão da suite Chronos
- **Thread worker** — Processamento em background (`_worker()`), mantendo a UI fluida
- **Logging e Progress Bar em tempo real** — Painel de log e barra de progresso atualizados via `GLib.idle_add`
- **Cancelamento seguro** — Interrupção limpa no botão `Cancelar` ou `Cancelar Tudo` no diálogo por data
- **Botão Toggle Mover/Copiar** — Copiar (`shutil.copy2`, padrão) ou mover (`shutil.move`) ficheiros e sidecars
- **Configuração centralizada XDG** — `~/.config/chronos/arkhe.json` com migração automática do histórico legado (`~/.config/organizar_fotos/historico.json`)
- **Navegador filtrado de origens e fotos (`OrigensFileBrowser`)** — Substitui o `Gtk.FileChooserWidget` para ocultar pastas proibidas e apresentar diretamente `~/Imagens`, `~/Transferências` (e subpastas), Pendrives/Cartões SD (`/media/$USER`, `/run/media/$USER`) e Câmaras USB (`/run/user/$UID/gvfs`), com deteção automática de montagem via `Gio.VolumeMonitor`
- **Restrição de origens e excepções (`🛡️ Origens e Excepções...`)** — Gestão visual e em `~/.config/chronos/arkhe.json` de `restringir_origens`, `origens_permitidas` e `pastas_excluidas` (incluindo pastas de sistema de cartões SD/pendrives como `System Volume Information`, `$RECYCLE.BIN`, `LOST.DIR`, `.Trash-*`)
- **Pasta de Destino restrita a `~/Imagens`** — Seletor filtrado (`_escolher_pasta_filtrada` + `is_destino_permitido`) que permite escolher apenas `~/Imagens` ou subpastas dentro de `~/Imagens`, com botão `➕ Nova Subpasta`
- **Suporte a pastas e ficheiros iniciais** — Aceita ficheiros e pastas tanto no navegador gráfico como via CLI e script do Nautilus
- **Estrutura de projeto padronizada**:
  - `scripts/install.sh` / `scripts/uninstall.sh` — instalação local em `~/.local` (sem root)
  - `scripts/run.sh` — execução a partir do código-fonte com verificação de dependências
  - `scripts/build-deb.sh` — geração de pacote `.deb`
  - `scripts/enable-nautilus-script.sh` / `scripts/disable-nautilus-script.sh` — gestão da integração Nautilus
  - `debian/control`, `debian/postinst`, `debian/prerm` — empacotamento Debian
  - `data/chronos-arkhe.desktop` e ícone vetorial `chronos-arkhe.svg`

### Corrigido
- Leitura da sub-IFD EXIF (`0x8769`) via Pillow 10/11+ para extração fiável de `DateTimeOriginal` (36867) e `DateTimeDigitized` (36868), além dos fallbacks `exifread`, `exiftool` e `mtime`
- Assinatura de `Gtk.TextView.scroll_to_mark` no painel de log em tempo real
- Prevenção de duplicação de ficheiros e sidecars com conjunto de controlo (`processed_set`) e verificação de mesmo caminho origem/destino

---

## [5.5] — 2024

### Adicionado
- Seletor de pasta de destino via `Gtk.FileChooserDialog`
- Pasta inicial do filechooser: `/home/$USER/Imagens` (criada se não existir)
- Persistência da última pasta escolhida no histórico JSON
- Pré-seleção automática da última pasta na próxima execução

### Alterado
- Substituído "Criar pasta(s) um nível acima" por seletor explícito
- Navegação real de ficheiros em vez de diálogo simples

### Corrigido
- Manutenção do estado da pasta entre execuções

---

## [5.4] — 2024

### Adicionado
- Extração EXIF fiável para RAWs via `exifread` (fallback)

### Corrigido
- Corrigido filtro de URIs `file://` do Nautilus
- Removida tag EXIF 306 (`DateTime` = data de modificação, não de captura)
- Sanitização substitui underscores por hífens (separador consistente)
- Escrita atómica do histórico JSON (`os.replace`)
- Refactor: `getexif()` direto (Pillow 10+), `_getexif` removido

---

## [5.3] — 2024

### Adicionado
- Sanitização inteligente que preserva acentos e hífens existentes
  (ex.: "Trás-os-Montes" mantém-se correto)
- Histórico ComboBox com texto cru — guarda o que o utilizador escreveu
  exatamente, sem normalização, para garantir legibilidade futura
- Opção "Criar pasta(s) um nível acima" no diálogo principal
- Suporte a sidecars nos padrões `ficheiro.xmp` e `ficheiro.ext.xmp`
  (cobertura completa para Adobe, RawTherapee e DxO)

### Alterado
- `sanitize()` agora usa regex `[^\w-]` com flag `re.UNICODE` para preservar
  todos os caracteres alfanuméricos Unicode, incluindo acentos
- Histórico JSON passa a usar `ensure_ascii=False` para guardar acentos
  legivelmente em vez de sequências `\uXXXX`

### Corrigido
- Hífens duplos resultantes de digitação errada ("A--B") são agora colapsados
  para um único hífen
- Hífens no início ou fim do nome da pasta são removidos
- Fallback para "Indefinido" quando input sanitizado fica vazio

---

## [5.2] — 2024

### Adicionado
- Suporte a 29 extensões RAW (CR2, CR3, NEF, ARW, DNG, ORF, RW2, PEF, SRW,
  RAF, IIQ, KDC, MOS, MEF, NRW, R3D, GPR, ERF, etc.)
- Deteção automática de ficheiros sidecar (XMP, PP3, DOP)
- Resolução de conflitos de nomes com sufixo `_1`, `_2`, ...
- Controlo `processed` (`set`) para evitar mover o mesmo sidecar duas vezes
  quando existe par RAW + JPEG com XMP partilhado

### Alterado
- Refatorização do módulo de extração EXIF para usar `getexif()` (Pillow 10+)
  em vez de `_getexif()` (removido em versões modernas)
- Lista de tags EXIF expandida para incluir `DateTimeOriginal` (36867),
  `DateTimeDigitized` (36868) e `DateTime` (306) como fallback

---

## [5.1] — 2024

### Adicionado
- Pré-visualização de thumbnail da primeira foto de cada data no diálogo
  "Por data" (max 280px, redimensionamento LANCZOS)
- Tema dark herdado do GNOME via `GTK_THEME=Adwaita:dark`
- Validação de campos no diálogo "Por data" — botão OK só fica ativo quando
  Evento e Local estão ambos preenchidos

### Alterado
- Diálogo principal redesenhado com checkboxes em vez de botões radio
- Mensagem final expandida com contadores de sidecars movidos e erros

---

## [5.0] — 2024

### Adicionado
- Primeira versão pública do Chronos
- Arquitetura modular: configuração, EXIF, sanitização, diálogos GTK,
  lógica principal — em secções claramente separadas
- Histórico JSON persistente em `~/.config/organizar_fotos/historico.json`
- Integração como Nautilus Script em `~/.local/share/nautilus/scripts/`
- Formato de nome de pasta `AAAAMMDD_Evento_Local`
- Suporte inicial a JPEG, PNG, TIFF, WebP, BMP, GIF
- Suporte a URIs `file://` (formato recebido do Nautilus)

---

## Convenções de versão

- **Major** (X.0): quebras de compatibilidade ou refactor profundo
- **Minor** (X.Y): novas funcionalidades, compatibilidade mantida
- **Patch** (X.Y.Z): correções de bugs apenas

---

## Links

- [Repositório no GitHub](https://github.com/PauloJSPinhal/Chronos-Arkhe)
- [Releases](https://github.com/PauloJSPinhal/Chronos-Arkhe/releases)
