# 🚀 Quick Start — Chronos Arkhe v6.0

## Instalação Rápida

```bash
cd Chronos-Arkhe
./scripts/install.sh
```

**O que é instalado:**
- ✅ Binário: `~/.local/bin/chronos-arkhe` (sem necessidade de root)
- ✅ Aplicação: Menu de aplicações (procura por **"Chronos Arkhe"**)
- ✅ Nautilus: Script de contexto (* Botão direito → Scripts → Chronos Arkhe *)
- ✅ Ícone: `~/.local/share/icons/hicolor/scalable/apps/chronos-arkhe.svg`
- ✅ Config: `~/.config/chronos/arkhe.json` (histórico JSON com migração automática de v5.x)

> 💡 **Alternativa sem instalar**: executa diretamente com `./scripts/run.sh`

## 🎯 Como Usar em 5 Passos

### 1️⃣ Abrir a Aplicação

```bash
chronos-arkhe
# OU pelo menu de aplicações: "Chronos Arkhe"
# OU no Nautilus: Botão direito nas fotos → Scripts → Chronos Arkhe
```

### 2️⃣ Selecionar Fotos (Origens Permitidas)

- **Barra lateral de origens**: Escolhe entre **`Imagens (~/Imagens)`**, **`Transferências (~/Transferências)`**, **Pendrives / Cartões SD** (`/media/$USER`) ou **Câmara USB** (`/run/user/$UID/gvfs`).
- **Tabela de pastas e fotos**: Podes selecionar fotos individuais, clicar numa subpasta (para carregar todas as fotos dessa subpasta), fazer duplo clique para abrir subpastas ou clicar em **Selecionar Tudo**.
- **Lista e Preview direito**: Mostra o total de fotos selecionadas e a miniatura da foto clicada.

### 3️⃣ Configurar Opções

| Opção | Padrão | O que faz |
|-------|--------|----------|
| ☑️ Pedir Evento e Local | Ativo | Abre um diálogo por cada data/coleção com preview das fotos |
| 🔄 Copiar / Mover | Copiar | Alterna entre cópia segura (`Copiar`) e movimentação (`Mover`) |
| 🛡️ Origens e Excepções... | Ativo | Gere as origens permitidas e a lista de pastas indesejadas (`pastas_excluidas`) |

### 4️⃣ Escolher Pasta de Destino (em `~/Imagens`)

- Clica em **Procurar...** para definir onde serão criadas as pastas das coleções (restrito a **`~/Imagens`** ou subpastas dentro de `~/Imagens`, com botão **➕ Nova Subpasta**).

### 5️⃣ Iniciar Organização

- Clica em **Iniciar Organização**.
- Para cada data encontrada, indica o **Evento** e **Local** (com auto-completar do histórico e navegação `◀`/`▶` entre as fotos dessa data).
- ✅ Concluído!

## 📁 Resultado

As fotos e os seus sidecars são organizados por coleção/data:

```text
/Destino/20261005_Casamento_Igreja-Matriz/
  ├── IMG_0001.jpg
  ├── IMG_0001.xmp
  ├── IMG_0002.jpg
  └── ...
```

## 🔄 Copiar vs Mover

### Copiar (Padrão)
```text
Original: ~/Fotos/IMG_001.jpg  (mantém-se intacto)
Cópia:    ~/Imagens/20261005_Casamento_Igreja-Matriz/IMG_001.jpg
```
✅ Seguro — os ficheiros originais não são apagados.

### Mover (Toggle ativado)
```text
Original: ~/Fotos/IMG_001.jpg  (movido)
Destino:  ~/Imagens/20261005_Casamento_Igreja-Matriz/IMG_001.jpg
```
⚡ Poupa espaço — transfere os ficheiros para a pasta da coleção.

## 💡 Dicas

### Auto-completar Evento e Local
- Começa a escrever ou abre a lista pendente para reutilizar eventos e locais anteriores.
- O nome da pasta é pré-visualizado em tempo real no diálogo antes de confirmares.

### Modo Debug (Diagnóstico EXIF)

```bash
chronos-arkhe --debug ~/Fotos/*.jpg
```

Mostra no terminal:
- Tags EXIF lidas por ficheiro (`DateTimeOriginal`, `DateTimeDigitized`)
- Fonte utilizada (`pillow`, `exifread`, `exiftool` ou `mtime`)
- Resumo de agrupamento por data

### Edição Manual da Configuração

```bash
nano ~/.config/chronos/arkhe.json
```

Formato:
```json
{
  "ultima_pasta": "/home/utilizador/Imagens",
  "ultima_pasta_origem": "/home/utilizador/Imagens",
  "eventos": ["Casamento", "Férias"],
  "locais": ["Igreja Matriz", "Praia"],
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
    "LOST.DIR"
  ],
  "ask_mode": true,
  "usar_move": false
}
```

## ⚠️ Resolução Rápida de Problemas

| Problema | Solução |
|----------|---------|
| "Seleciona pelo menos uma foto" | Seleciona as fotos no navegador esquerdo ou clica em **Selecionar Tudo** |
| "Todas as fotos na mesma data" | Instala suporte adicional: `sudo apt install python3-exifread libimage-exiftool-perl` |
| Script do Nautilus não aparece | Executa `./scripts/enable-nautilus-script.sh` e reinicia o Nautilus (`nautilus -q`) |
| Desinstalar | Executa `./scripts/uninstall.sh` |

## 📞 Mais Informação

- 📖 Manual completo: [USAGE.md](./USAGE.md)
- 🤝 Contribuir: [CONTRIBUTING.md](./CONTRIBUTING.md)
