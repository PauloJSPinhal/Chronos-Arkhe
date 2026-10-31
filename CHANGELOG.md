# Changelog

Todos os lançamentos notáveis do **Chronos-Photo-Organizer** são documentados neste ficheiro.

O formato segue [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e o projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

---

## [Unreleased]

### Planeado
- Integração com `exifread` para extração fiável de datas em ficheiros RAW ✓
- Corrigir filtro `file://` em URIs do Nautilus ✓
- Escrita atómica do `historico.json` via `os.replace` ✓
- Diálogo de gestão de histórico (apagar entradas obsoletas)
- Thumbnail assíncrono para não bloquear a UI

---

## [6.0] — 2026-10-31

### Adicionado
- **Aplicação GTK3 completa** — Interface melhorada com navegador de ficheiros integrado
- **Botão Toggle Mover/Copiar** — Escolhe se pretende copiar (padrão) ou mover ficheiros
- **Preview de imagens** — Visualiza miniaturas das fotos selecionadas
- **Integração Nautilus melhorada** — Script de contexto instalado via `install.sh`
- **Ficheiro .desktop** — Aplicação registrada no menu de aplicações GNOME/KDE
- **Scripts de instalação/desinstalação** — Verificação de dependências Python
- **Documentação completa** — `USAGE.md` com exemplos e troubleshooting
- **Modo debug melhorado** — Flag `--debug` com diagnóstico EXIF detalhado

### Alterado
- `main()` refatorizada para aceitar lista de ficheiros pré-fornecida
- Nova função `janela_principal_simples()` com suporte a toggle Mover/Copiar
- Função auxiliar `processar_ficheiro()` para abstração copy/move
- Mensagem final dinâmica que reflete modo (copiado vs movido)
- Compatibilidade mantida com modo Nautilus (argumentos CLI)

### Corrigido
- Nenhum bug de v5.5 reportado

### Nota de Compatibilidade
- ✅ Modo Nautilus mantido (clica direito em ficheiros)
- ✅ Modo CLI mantido (`chronos-arkhe *.jpg`)
- ✅ Flag --debug mantida para diagnóstico
- ✅ Histórico JSON mantido (compatível com v5.x)

---

## [5.5] — 2024

### Adicionado
- Seletor de pasta de destino via Gtk.FileChooserDialog
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
- Extração EXIF fiável para RAWs via exifread (fallback)

### Corrigido
- Corrigido filtro de URIs `file://` do Nautilus
- Removida tag EXIF 306 (DateTime = data de modificação, não de captura)
- Sanitização substitui underscores por hífens (separador consistente)
- Escrita atómica do histórico JSON (`os.replace`)
- Refactor: `getexif()` directo (Pillow 10+), `_getexif` removido

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
- Detecção automática de ficheiros sidecar (XMP, PP3, DOP)
- Resolução de conflitos de nomes com sufixo `_1`, `_2`, ...
- Controlo `processed` (set) para evitar mover o mesmo sidecar duas vezes
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
- Mensagem de final expandida com contadores de sidecars movidos e erros

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

- [Comparar versões](https://github.com/Chronos-Photo-Organizer/compare)
- [Releases](https://github.com/Chronos-Photo-Organizer/releases)
