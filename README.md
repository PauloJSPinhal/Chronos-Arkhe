# Chronos Arkhe

Aplicação nativa GTK3/GNOME e script de contexto para o **Nautilus** concebida para a organização segura de acervos fotográficos por data de captura (EXIF), com suporte a modo cópia/movimento, pré-visualização de miniaturas, histórico de eventos e locais, e logging em tempo real.

Integra a suite fotográfica **Chronos** (*Arkhe*, *Nomos*, *Sfragis*, *Gnosis*).

---

## 📋 Padrão de Organização

O **Chronos Arkhe** estrutura as pastas segundo o padrão:

```text
{AAAAMMDD}_Evento_Local/
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

20261030_Passeio_Praia/
├── DSCF001.JPG
├── DSCF002.JPG
└── DSCF002.JPG.xmp  (sidecar preservado)
```

### Componentes:
* **`{AAAAMMDD}`**: Carimbo temporal obtido a partir dos metadados EXIF da imagem (`DateTimeOriginal`). Se o EXIF estiver ausente, recorre à data de modificação do ficheiro.
* **`{Evento}`**: Classificação do tipo de evento (ex.: Reunião, Passeio, Trabalho). Guardado em histórico para auto-completar.
* **`{Local}`**: Localização geográfica (ex.: SCP, Praia, Escritório). Guardado em histórico para auto-completar.

---

## ✨ Funcionalidades

* **Agrupamento por Data EXIF:** Organiza fotos pela data real de captura, não pela data de modificação do ficheiro.
* **Pré-visualização Integrada:** Mostra thumbnails das imagens antes de processar.
* **Navegador de Ficheiros:** Seletor integrado para escolher pasta de origem.
* **Toggle Copiar/Mover:** Botão para alternar entre cópia (padrão, seguro) e movimento de ficheiros.
* **Suporte a Sidecars:** Localiza e move automaticamente ficheiros `.xmp`, `.pp3`, `.dop` (metadados de edição não-destrutiva).
* **Histórico Persistente:** Guarda eventos e locais em `~/.config/chronos/arkhe.json` para auto-completar em utilizações futuras.
* **Logging em Tempo Real:** Painel de log mostra cada passo da operação em direto.
* **Progress Bar:** Barra de progresso atualiza-se durante o processamento.
* **Processamento Assíncrono:** Worker em thread separada — a UI nunca bloqueia, mesmo com milhares de fotos.
* **Cancelamento Seguro:** Botão de cancelamento interrompe a operação a meio sem corromper ficheiros.
* **Arquitetura v6.0:** Classe `ChronosArkheApp(Gtk.Window)` com encapsulamento de estado e threading seguro via `GLib.idle_add`.
* **Memória de Estado (XDG):** Preserva a última pasta e preferências em `~/.config/chronos/arkhe.json`.
* **Duplo Modo de Utilização:** Funciona como aplicação autónoma através do lançador do sistema ou diretamente no menu de clique direito do Nautilus.

---

## 📦 Estrutura do Projeto

```text
Chronos-Arkhe/
├── bin/
│   └── chronos-arkhe              # Executável Python (sem extensão .py)
├── data/
│   ├── chronos-arkhe.desktop      # Ficheiro de entrada XDG Desktop
│   └── icons/
│       └── hicolor/
│           └── scalable/
│               └── apps/
│                   └── chronos-arkhe.svg  # Ícone vetorial oficial
├── debian/                        # Metadados de empacotamento Debian
│   ├── control
│   ├── postinst
│   └── prerm
├── docs/                          # Documentação
│   ├── REORGANIZACAO_ESTRUTURAL.md    # Registo da migração para o padrão Chronos
│   ├── RELATORIO_REORGANIZACAO.md     # Relatório executivo da reorganização
│   ├── chronos-arkhe.jpeg             # Captura de ecrã
│   └── dev/                       # Documentação técnica de desenvolvimento
│       ├── REFACTORING_v6.0.md        # Refactorização para arquitetura de classes
│       ├── COMPARACAO_VERSOES.md      # v5.5 vs v6.0
│       └── VERIFICACAO_v6.0.md        # Checklist de validação
├── scripts/                       # Scripts de instalação e utilitários
│   ├── install.sh                 # Instalador local (~/.local)
│   ├── uninstall.sh               # Desinstalador local
│   ├── build-deb.sh               # Gerador de pacotes .deb
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
sudo apt install python3 python3-gi gir1.2-gtk-3.0
```

### Dependências Opcionais:

```bash
# Para pré-visualização de miniaturas (recomendado)
pip install Pillow

# Para leitura melhorada de EXIF em RAWs
pip install exifread

# Para gestão avançada de metadados
sudo apt install libimage-exiftool-perl
```

---

## 🚀 Instalação e Distribuição

### Opção 1: Instalação Local (utilizador atual, sem privilégios root)

Instala em `~/.local/bin`, cria o lançador em `~/.local/share/applications`, configura o ícone e faz a ligação ao Nautilus:

```bash
chmod +x scripts/install.sh scripts/uninstall.sh
scripts/install.sh
```

Para remover a instalação local:
```bash
scripts/uninstall.sh
```

---

### Opção 2: Empacotamento Nativo Debian (`.deb`)

Para gerar o pacote instalável no sistema:

```bash
chmod +x scripts/build-deb.sh
scripts/build-deb.sh
```

O ficheiro gerado fica disponível em `build/chronos-arkhe_6.0.0_all.deb`. Para instalar a nível do sistema:

```bash
sudo apt install ./build/chronos-arkhe_6.0.0_all.deb
```

Para desinstalar o pacote:
```bash
sudo apt remove chronos-arkhe
```

---

### Opção 3: Execução Direta do Código-Fonte

Para testes e desenvolvimento:

```bash
chmod +x scripts/run.sh
scripts/run.sh
```

---

## 🖥️ Como Usar

### Como Aplicação Independente:
1. Abra o menu de aplicações do GNOME e procure por **Chronos Arkhe**.
2. Ou execute no terminal:
   ```bash
   chronos-arkhe
   ```
3. Selecione a pasta que contém as fotografias a processar.
4. Escolha as fotos a organizar (ou selecione todas).
5. (Opcional) Alterne entre **Copiar** (padrão) e **Mover** usando o toggle.
6. Clique em **Processar** e veja o log em tempo real.

### Via Menu de Contexto do Nautilus:
1. No explorador de ficheiros, navegue até à pasta com as fotos.
2. Clique com o botão direito → **Scripts** → **Chronos Arkhe**.
3. Siga os mesmos passos que acima.

---

## 📋 Convenção de Nomes

As pastas geradas seguem a convenção:

```
AAAAMMDD_Evento_Local/
```

Onde:
- **AAAAMMDD** = Data da primeira fotografia (formato ISO 8601 compacto)
- **Evento** = Classificação do tipo de evento (ex.: Reunião, Passeio, Conferência)
- **Local** = Localização geográfica (ex.: SCP, Praia, Lisboa)

### Exemplos:
```
20261031_Reunião_SCP/
20261030_Passeio_Praia/
20261025_Conferência_Lisboa/
```

---

## 🖼️ Formatos Suportados

### Fotografias:
- **JPEG** (`.jpg`, `.jpeg`)
- **TIFF** (`.tif`, `.tiff`)
- **PNG** (`.png`)
- **RAW** (`.cr2`, `.nef`, `.arw`, `.dng`, `.raf`, etc.)

### Sidecars (Metadados Não-Destrutivos):
- **Adobe** (`.xmp`)
- **DxO PhotoLab** (`.dop`)
- **RawTherapee** (`.pp3`)

---

## 📝 Histórico de Eventos e Locais

O aplicativo mantém um histórico JSON em `~/.config/chronos/arkhe.json`:

```json
{
  "eventos": ["Reunião", "Passeio", "Conferência"],
  "locais": ["SCP", "Praia", "Lisboa"],
  "ultima_pasta": "/home/usuario/Fotos"
}
```

Ao executar novamente, os campos de Evento e Local apresentam auto-completar com os valores anteriores.

---

## 🔍 Sanitização Inteligente

O nome da pasta é sanitizado automaticamente:
- Remove caracteres especiais e espaços duplos
- Converte acentos (ex.: `Praia` em vez de `Pràia`)
- Limita comprimento máximo de caminho para compatibilidade

---

## ⚠️ Limitações Conhecidas

- Requer GNOME/Nautilus (não foi testado com Dolphin, Thunar, etc.)
- Leitura de EXIF depende de `exifread` Python ou `exiftool` externo
- Não oferece UI para ajuste de data EXIF antes de organizar (usar `exiftool` separadamente se necessário)
- Sem suporte a Wayland testado (desenvolvido para X11/GNOME)

---

## 🛣️ Roadmap

Melhorias planeadas:
- [ ] Suporte a "Cancelar" operação em curso
- [ ] Diálogo de pré-visualização antes de confirmar organização
- [ ] Histórico de operações (para possível desfazer)
- [ ] Integração com Geotagging (lat/lon → local automático)
- [ ] Geração de relatórios em PDF

---

## 🤝 Contribuir

Encontrou um bug ou tem uma sugestão? Abra uma issue em:
[PauloJSPinhal/Chronos-Photo-Organizer](https://github.com/PauloJSPinhal/Chronos-Photo-Organizer)

---

## 📄 Licença
