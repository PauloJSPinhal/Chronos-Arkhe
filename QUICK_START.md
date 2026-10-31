# 🚀 Quick Start — Chronos v6.0

## Instalação Rápida

```bash
cd Chronos-Arkhe
./install.sh
```

**O que é instalado:**
- ✅ Binário: `/usr/local/bin/chronos-arkhe`
- ✅ Aplicação: Menu de aplicações (procura "Chronos")
- ✅ Nautilus: Script de contexto (clica direito)
- ✅ Config: `~/.config/organizar_fotos/` (histórico JSON)

## 🎯 Como Usar

### 1️⃣ Abrir a Aplicação

```bash
chronos-arkhe
# OU
# Procura "Chronos" no menu de aplicações
# OU
# Nautilus: Clica direito → Scripts → Organizar Fotos
```

### 2️⃣ Selecionar Fotos

- **Navegador esquerdo**: Navega até à pasta com fotos
- **Filtro**: Mostra apenas imagens e RAWs
- **Preview direito**: Vê miniatura da primeira foto

### 3️⃣ Configurar Opções

| Opção | Padrão | O que faz |
|-------|--------|----------|
| ☑️ Pedir Evento e Local | ✓ ON | Pergunta para cada data |
| 🔄 Copiar/Mover | Copiar | Toggle entre cópia (segura) e movimento |

### 4️⃣ Escolher Pasta Destino

- Clica "Procurar..."
- Seleciona onde organizar as fotos

### 5️⃣ Iniciar

- Clica "Iniciar Organização"
- Para cada data, preenche Evento e Local
- ✅ Concluído!

## 📁 Resultado

Fotos organizadas por data:

```
/Destino/20240615_Casamento-Igreja/
  ├── foto1.jpg
  ├── foto1.xmp
  ├── foto2.jpg
  └── ...
```

## 🔄 Copiar vs Mover

### Copiar (Padrão ☑️)
```
Original: ~/Fotos/IMG_001.jpg  (fica intacto)
Cópia:    ~/Fotos/2024/20240615_Casamento-Igreja/IMG_001.jpg
```
✅ Seguro — ficheiro original mantém-se

### Mover (☑️ Toggle ativado)
```
Original: ~/Fotos/IMG_001.jpg  (removido)
Movido:   ~/Fotos/2024/20240615_Casamento-Igreja/IMG_001.jpg
```
⚡ Economiza espaço — ficheiro é removido da origem

## 💡 Dicas

### Auto-completar Evento e Local
- Escreve "Casa" → Mostra histórico de eventos similares
- Seleciona da lista ou escreve novo

### Modo Debug (Diagnóstico)

```bash
chronos-arkhe --debug ~/Fotos/*.jpg
```

Mostra:
- Informação EXIF detalhada por ficheiro
- Qual fonte foi usada (Pillow, exifread, exiftool, mtime)
- Estatísticas de agrupamento

### Limpeza Manual do Histórico

```bash
nano ~/.config/organizar_fotos/historico.json
```

Formato:
```json
{
  "eventos": ["Casamento", "Férias"],
  "locais": ["Igreja", "Praia"],
  "ultima_pasta": "/home/user/Fotos/2024"
}
```

## ⚠️ Troubleshooting

| Problema | Solução |
|----------|---------|
| "Nenhuma foto selecionada" | Seleciona pelo menos 1 ficheiro na navegação esquerda |
| "Todas as fotos mesma data" | EXIF pode estar vazio. Tenta: `pip install exifread` |
| Nautilus script não aparece | Reinstala: `./install.sh` e reinicia Nautilus |
| "Permissão negada" | Verifica permissões: `chmod 755 ~/.local/share/nautilus/scripts/*` |

## 📞 Suporte

- 📖 Documentação: [USAGE.md](./USAGE.md)
- 🐛 Debug: `chronos-arkhe --debug`
- 📝 Config: `~/.config/organizar_fotos/historico.json`

---

**Pronto! Goza de organização automática de fotos. 📸**
