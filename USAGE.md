# Chronos Arkhe v6.0 — Organizador de Fotos por Data

Aplicação GTK3 para organizar automaticamente fotos por data de captura (EXIF). Suporta múltiplos formatos de imagem e RAWs, com integração nativa no Nautilus File Manager. Integra a suite fotográfica **Chronos** (*Arkhe*, *Nomos*, *Sfragis*, *Gnosis*).

## 🚀 Novidades v6.0

- **Aplicação GTK3 completa** — Interface com navegador de ficheiros integrado
- **Arquitetura de classes** — `ChronosArkheApp(Gtk.Window)`, padrão unificado da suite Chronos
- **Processamento assíncrono** — Worker em thread separada; a UI nunca bloqueia
- **Logging em tempo real** — Painel de log mostra cada passo da operação
- **Progress bar** — Acompanhamento visual do progresso
- **Cancelamento seguro** — Interrompe a operação a meio sem corromper ficheiros
- **Botão Mover/Copiar** — Toggle entre copiar ficheiros (padrão) ou movê-los
- **Preview de imagens** — Visualiza miniaturas das fotos selecionadas
- **Configuração centralizada** — `~/.config/chronos/arkhe.json` (padrão XDG da suite)
- **Integração Nautilus** — Script disponível no menu de contexto (clica direito)

## 📦 Instalação

### Pré-requisitos

```bash
# Python 3.7+
sudo apt install python3 python3-pip python3-gi python3-gi-cairo gir1.2-gtk-3.0

# Dependências Python
pip install Pillow exifread

# Opcional: melhor suporte EXIF
sudo apt install libimage-exiftool-perl
```

### Instalar Chronos

```bash
cd Chronos-Arkhe
scripts/install.sh
```

O instalador (sem necessidade de root):
- Copia o binário para `~/.local/bin/chronos-arkhe`
- Regista a aplicação no menu de aplicações (`~/.local/share/applications/`)
- Instala o ícone em `~/.local/share/icons/hicolor/`
- Cria ligação para o Nautilus em `~/.local/share/nautilus/scripts/Chronos Arkhe`

> 💡 **Alternativa rápida**: `scripts/run.sh` executa diretamente do código-fonte, com verificação de dependências.
>
> 📦 **Pacote Debian**: `scripts/build-deb.sh` gera `build/chronos-arkhe_6.0.0_all.deb` para instalação ao nível do sistema.

### Desinstalar

```bash
scripts/uninstall.sh
```

## 🎯 Como Usar

### Modo Aplicação (Interface Gráfica)

Procura "Chronos" no menu de aplicações ou execute:

```bash
chronos-arkhe
```

A interface permite:
1. **Navegar e selecionar fotos** — Navegador de ficheiros integrado com preview
2. **Escolher pasta de destino** — Botão "Procurar..." para selecionar onde organizar
3. **Configurar opções**:
   - ☑️ Pedir Evento e Local para cada data
   - 🔄 Toggle entre Copiar (padrão) ou Mover ficheiros
4. **Iniciar organização** — Botão "Iniciar Organização"

### Modo Nautilus (Clica Direito)

1. Seleciona fotos no Nautilus
2. Clica direito → **Scripts** → **Chronos Arkhe**
3. Configura opções no diálogo (igual ao modo aplicação)

> 💡 Se o script não aparecer, ativa-o com `scripts/enable-nautilus-script.sh` e reinicia o Nautilus (`killall nautilus`).

### Modo Linha de Comando

```bash
# Uma ou mais fotos
chronos-arkhe /caminho/para/foto1.jpg /caminho/para/foto2.jpg

# Com glob
chronos-arkhe ~/Fotos/*.jpg

# Modo debug (mostra diagnóstico EXIF detalhado)
chronos-arkhe --debug ~/Fotos/*.jpg
```

## 📋 Formato de Organização

As fotos são organizadas em pastas com o formato:

```
AAAAMMDD_Evento-Local/
├── foto1.jpg
├── foto1.xmp (sidecar, se existir)
├── foto2.jpg
└── ...
```

**Exemplo:**
```
20240615_Casamento-Igreja/
├── IMG_0001.jpg
├── IMG_0001.xmp
├── IMG_0002.jpg
├── ...
```

Os componentes são:
- `AAAAMMDD` — Data de captura (EXIF DateTimeOriginal)
- `Evento` — Texto livre (histórico reutilizável)
- `Local` — Texto livre (histórico reutilizável)
- Hífens como separador consistente
- Underscores e espaços convertidos automaticamente

## 🔍 Extração EXIF

Chronos tenta extrair a data de captura por ordem de prioridade:

1. **Pillow** — Rápido, suporta JPEG, PNG, TIFF, WebP
2. **exifread** — Robusto para RAWs (Canon CR2, Nikon NEF, Sony ARW, etc.)
3. **exiftool** — Fallback para EXIF exótico (comando externo, se instalado)
4. **mtime** — Última opção (data de modificação do ficheiro)

### Compatibilidade de RAWs

Suportados:
- Canon: CR2, CR3, CRW
- Nikon: NEF, NRW
- Sony: ARW, SR2, SRF
- Fujifilm: RAF, RW2
- Pentax: PEF, DNG
- Olympus: ORF
- E muitos mais (ver variável `IMAGE_EXTS` no código)

## 📊 Sidecars

Ficheiros de edição associados são movidos/copiados automaticamente:

- `*.xmp` — Metadados Darktable, Lightroom, Adobe
- `*.pp3` — Presets RawTherapee
- `*.dop` — Presets DxO PhotoLab

Exemplo: `foto.jpg` + `foto.jpg.xmp` são movidos juntos.

## 🔧 Configuração

Histórico de eventos e locais é armazenado em:

```
~/.config/chronos/arkhe.json
```

Formato:
```json
{
  "eventos": ["Casamento", "Férias", "Família"],
  "locais": ["Igreja", "Praia", "Casa"],
  "ultima_pasta": "/home/user/Fotos/2024"
}
```

Edita diretamente para adicionar ou remover entradas.

## ⚙️ Flags de Debug

```bash
chronos-arkhe --debug foto1.jpg foto2.jpg
```

Mostra:
- Diagnóstico EXIF detalhado por ficheiro
- Fontes usadas (Pillow, exifread, exiftool, mtime)
- Datas agrupadas
- Estatísticas de extração

Útil para diagnosticar problemas com EXIF.

## 🐛 Resolução de Problemas

### "Nenhuma foto válida selecionada"

- ✅ Seleciona ficheiros `.jpg`, `.png`, `.tiff`, `.cr2`, etc.
- ✅ Verifica permissões de leitura
- ✅ Se usar Nautilus, garante que a pasta tem fotos visíveis

### "Todas as fotos foram agrupadas na mesma data"

Pode indicar problema com EXIF. Verifica com:

```bash
exiftool -DateTimeOriginal foto.jpg
```

Se vazio, tenta:
- Instalar `exifread`: `pip install exifread`
- Usar câmara ou software de edição para adicionar EXIF
- Aceitar fallback para data de modificação do ficheiro

### "EXIF não foi lido corretamente"

Um aviso é mostrado se múltiplas fotos caem num único dia. Soluções:

1. Instala `exifread` para melhor suporte RAW
2. Instala `exiftool`: `sudo apt install libimage-exiftool-perl`
3. Usa `chronos-arkhe --debug` para diagnóstico

### Script Nautilus não aparece

Garantir que a ligação foi criada corretamente:

```bash
ls -la ~/.local/share/nautilus/scripts/
```

Se não existir:
- Ativa: `scripts/enable-nautilus-script.sh` (ou reinstala: `scripts/install.sh`)
- Reinicia Nautilus: `killall nautilus ; nautilus &`

## 📝 Exemplos

### Organizar fotos de um evento

```bash
# Via aplicação
chronos-arkhe
# Seleciona pasta com fotos, choose "Copiar", define Evento="Casamento", Local="Igreja"

# Via Nautilus
# 1. Abre pasta com fotos
# 2. Seleciona ficheiros
# 3. Clica direito → Scripts → Chronos Arkhe
```

### Mover (em vez de copiar)

```bash
# Via aplicação
# Abre Chronos → toggle para "Mover ficheiros" → iniciar

# Via Nautilus
# Toggle para "Mover ficheiros" antes de clicar OK
```

### Organizar com histórico reutilizável

```bash
# Primeira vez
chronos-arkhe ~/Férias2024/*.jpg
# Define Evento="Férias 2024" e Local="Algarve"
# Fica armazenado em ~/.config/chronos/arkhe.json

# Próxima vez
chronos-arkhe ~/Férias2024/dia2/*.jpg
# Evento e Local aparecem sugeridos (histórico)
```

## 🎨 Personalização

Tema: a aplicação herda o tema GTK3 do sistema (light/dark).

Para forçar tema dark:

```bash
GTK_THEME=Adwaita:dark chronos-arkhe
```

## 📄 Licença

[Ver LICENSE](./LICENSE)

## 🤝 Contribuições

[Ver CONTRIBUTING.md](./CONTRIBUTING.md)

---

**Desenvolvido com ❤️ para organizar fotos sem esforço.**
