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
* **Pré-visualização Integrada:** Mostra thumbnails das imagens antes de processar, com zoom e navegação.
* **Navegador de Ficheiros:** Seletor integrado para escolher pasta de origem.
* **Toggle Copiar/Mover:** Botão para alternar entre cópia (padrão) e movimento de ficheiros.
* **Suporte a Sidecars:** Localiza e move automaticamente ficheiros `.xmp`, `.pp3`, `.dop` (metadados de edição não-destrutiva).
* **Histórico Persistente:** Guarda eventos e locais em `~/.config/chronos/arkhe.json` para auto-completar em utilizações futuras.
* **Logging em Tempo Real:** Painel de log mostra cada passo da operação em direto.
* **Progress Bar:** Barra de progresso atualiza-se segundo a segundo durante o processamento.
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
├── docs/                          # Recursos e documentação adicional
│   └── dev/                       # Documentação de desenvolvimento
├── scripts/                       # Scripts de instalação e utilitários
│   ├── install.sh                 # Instalador local (~/.local)
│   ├── uninstall.sh               # Desinstalador local
│   ├── build-deb.sh               # Gerador de pacotes .deb
│   ├── run.sh                     # Executor de desenvolvimento
│   ├── enable-nautilus-script.sh  # Ativa integração Nautilus
│   └── disable-nautilus-script.sh # Desativa integração Nautilus
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
- Sem suporte a Wayand (apenas X11/GNOME)

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

Distribuído sob os termos da licença MIT. Consulte [LICENSE](LICENSE) para detalhes adicionais.
- 🧹 **Sanitização inteligente** de nomes: preserva acentos e hífens existentes (ex.: "Trás-os-Montes"), substitui espaços por hífens, normaliza separadores duplicados.
- 🌙 **Tema dark herdado** do GNOME — sem ofuscar os olhos em sessões de edição noturnas.
- 🎯 **Modo Nautilus** — Integração com Nautilus File Manager via script de contexto.
- ⚙️ **Aplicação independente** — Executa como app GTK com interface melhorada.
- 🐛 **Modo debug** — Diagnóstico detalhado com `--debug` flag.
- 📁 **Opção "um nível acima"** para criar as pastas fora da pasta atual (útil ao organizar fotos dentro de uma pasta "raw" e querer as estruturadas na pasta pai).
- 🔁 **Resolução de conflitos** automática com sufixo `_1`, `_2`, ... quando já existe ficheiro com o mesmo nome.
- 🎞️ **29 extensões RAW suportadas**: CR2, CR3, NEF, ARW, DNG, ORF, RW2, PEF, SRW, RAF, etc.

---

## 📸 Screenshots

> Substituir os placeholders abaixo pelas capturas de ecrã reais depois de carregar para a pasta `docs/`.

<!-- ![Diálogo principal](docs/dialogo-principal.png) -->
<!-- ![Diálogo por data com thumbnail](docs/dialogo-por-data.png) -->
<!-- ![Resultado final — pastas criadas](docs/resultado-final.png) -->

**Para gerar as capturas**, executar:

```bash
gnome-screenshot -w -d 2 -f docs/dialogo-principal.png
```

---

## 🔧 Requisitos

| Dependência | Versão mínima | Notas |
|---|---|---|
| Python | 3.8+ | Testado até 3.12 |
| PyGObject (`gir1.2-gtk-3.0`) | 3.36+ | Binding GTK3 para Python |
| Pillow | 10.0+ | Leitura EXIF e geração de thumbnails |
| GTK 3 | 3.36+ | Incluído em qualquer GNOME recente |
| Nautilus | 40+ | Para integração como script (opcional) |

### Instalar dependências (Debian/Ubuntu)

```bash
sudo apt install python3-gi python3-pil gir1.2-gtk-3.0 nautilus
```

### Instalar dependências (Arch/Manjaro)

```bash
sudo pacman -S python-gobject python-pillow gtk3 nautilus
```

### Instalar dependências (Fedora)

```bash
sudo dnf install python3-gobject python3-pillow gtk3 nautilus
```

---

## 📥 Instalação

### Opção A — Instalação como Nautilus Script (recomendado)

1. Criar a pasta de scripts do Nautilus (se não existir):

   ```bash
   mkdir -p ~/.local/share/nautilus/scripts
   ```

2. Copiar o script para essa pasta com nome curto:

   ```bash
   cp chronos.py ~/.local/share/nautilus/scripts/Chronos.py
   chmod +x ~/.local/share/nautilus/scripts/Chronos.py
   ```

3. Reiniciar o Nautilus:

   ```bash
   nautilus -q
   ```

4. Agora, ao selecionar fotos no Nautilus → botão direito → **Scripts → Chronos.py**.

### Opção B — Uso standalone (linha de comandos)

```bash
chmod +x chronos.py
./chronos.py foto1.jpg foto2.cr3 foto3.nef
```

Os argumentos podem ser paths absolutos ou URIs `file://` (formato recebido do Nautilus).

---

## 🚀 Utilização

1. Selecionar um conjunto de fotografias no Nautilus (JPEG + RAW misturados, sem problema).
2. Botão direito → **Scripts → Chronos.py**.
3. No diálogo inicial, escolher:
   - ✅ **Pedir Evento e Local para cada data** (recomendado) — abre um diálogo por data distinta.
   - ⬆️ **Criar pasta(s) um nível acima** — útil para organizar fotos dentro de `raw/` e receber pastas estruturadas em `../estruturadas/`.
4. Para cada data distinta, o diálogo mostra um thumbnail da primeira foto dessa data. Preencher **Evento** e **Local** (com auto-completar do histórico). Ambos os campos têm de estar preenchidos para o botão **OK** ficar ativo.
5. Confirmar com **OK** ou cancelar (a data fica com nome padrão `Evento_Local`).
6. No fim, aparece um resumo com:
   - Nº de imagens movidas
   - Nº de sidecars movidos
   - Datas que ficaram com nome padrão (fallback)
   - Erros ocorridos (se algum)

---

## 📂 Convenção de nomes

As pastas criadas seguem o formato:

```
AAAAMMDD_Evento_Local
```

### Exemplos

| Data de captura | Evento | Local | Pasta resultante |
|---|---|---|---|
| 2024-01-15 | Casamento | Porto | `20240115_Casamento_Porto` |
| 2024-03-08 | Fim de semana | Trás-os-Montes | `20240308_Fim-de-semana_Trás-os-Montes` |
| 2024-07-22 | Viagem | Aveiro | `20240722_Viagem_Aveiro` |
| 2024-12-25 | Natal | Lisboa | `20241225_Natal_Lisboa` |

### Regras de sanitização

1. **Espaços → hífens** (`Fim de semana` → `Fim-de-semana`)
2. **Hífens existentes são preservados** (`Trás-os-Montes` → mantém-se)
3. **Acentos são mantidos** (UTF-8 native)
4. **Caracteres inválidos removidos** (símbolos, pontuação)
5. **Hífens duplos colapsados** (`A--B` → `A-B`)
6. **Hífens nas pontas removidos** (`-Natal-` → `Natal`)

> ⚠️ O histórico JSON guarda o texto **cru** tal como foi escrito. A sanitização só é aplicada ao nome da pasta, mantendo o histórico legível.

---

## 🎞️ Formatos suportados

### Imagens raster

`.jpg` `.jpeg` `.png` `.tiff` `.tif` `.webp` `.bmp` `.gif`

### RAW (29 formatos)

| Fabricante | Extensões |
|---|---|
| Canon | `.cr2` `.cr3` |
| Nikon | `.nef` `.nrw` |
| Sony | `.arw` `.sr2` `.srf` |
| Adobe (universal) | `.dng` |
| Olympus | `.orf` |
| Panasonic/Leica | `.rw2` `.raw` |
| Pentax | `.pef` |
| Samsung | `.srw` |
| Fujifilm | `.raf` |
| Phase One | `.iiq` |
| Kodak | `.kdc` `.dcr` |
| Leaf | `.mos` |
| Mamiya | `.mef` |
| Red | `.r3d` |
| Sigma | `.x3f` |
| GoPro | `.gpr` |
| Epson | `.erf` |

### Sidecars

| Extensão | Software que gera |
|---|---|
| `.xmp` | Adobe Camera Raw, Darktable, Lightroom |
| `.pp3` | RawTherapee |
| `.dop` | DxO PhotoLab |

O script detecta automaticamente sidecars nos padrões `ficheiro.xmp` e `ficheiro.jpg.xmp`.

---

## 💾 Histórico de eventos e locais

O Chronos mantém um histórico JSON em:

```
~/.config/organizar_fotos/historico.json
```

### Estrutura

```json
{
  "eventos": [
    "Casamento",
    "Fim de semana",
    "Viagem"
  ],
  "locais": [
    "Aveiro",
    "Lisboa",
    "Porto",
    "Trás-os-Montes"
  ]
}
```

- Os valores são guardados **exatamente como escritos** (texto cru, com acentos e espaços).
- A ordenação é alfabética, automática ao gravar.
- Os duplicates são eliminados via `set()`.
- Em diálogos futuros, estes valores aparecem como sugestões no ComboBox.

### Backup do histórico

Para mover entre máquinas:

```bash
cp ~/.config/organizar_fotos/historico.json ~/dotfiles/chronos/
```

---

## 🧹 Sanitização inteligente

A função `sanitize()` (em `chronos.py`, linha ~110) é o coração da coerência dos nomes de pasta. Aplica as seguintes transformações:

| Input | Output | Notas |
|---|---|---|
| `Fim de semana` | `Fim-de-semana` | Espaços → hífens |
| `Trás-os-Montes` | `Trás-os-Montes` | Hífens existentes preservados |
| `São João!!` | `São-João` | Pontuação removida, acentos mantidos |
| `A -- B` | `A-B` | Hífens duplos colapsados |
| `-Natal-` | `Natal` | Hífens nas pontas removidos |
| `(vazio)` | `Indefinido` | Fallback quando input vazio |

### Expressão regular principal

```python
re.sub(r'[^\w-]', '', t, flags=re.UNICODE)  # \w em Python 3 já inclui acentos
```

---

## ⚠️ Limitações conhecidas

1. **Datas em RAW podem usar mtime como fallback** — em versões atuais, se o Pillow não conseguir extrair EXIF (caso de RAWs exóticos), a data de modificação é usada. Planeado: integração com `exifread` ou `exiftool` (ver [Roadmap](#-roadmap)).

2. **Thumbnail síncrono** — a geração de thumbnails em RAWs grandes pode bloquear a UI por 1-3 segundos por foto. Solução planeada: carregar thumbnails em thread.

3. **Sem undo** — uma vez movidos os ficheiros, não há opção de reverter dentro do script. Recomenda-se fazer um teste com 2-3 fotos antes de processar grandes lotes.

4. **Histórico não tem UI de gestão** — não é possível apagar entradas obsoletas do histórico a partir da interface. Funcionalidade planeada para v5.4.

5. **Apenas Linux/BSD** — por depender de GTK3 via PyGObject, não funciona em Windows ou macOS sem porting significativo.

---

## 🗺️ Roadmap

- [ ] **v5.4** — Integração com `exifread` para extração fiável de datas em RAWs
- [ ] **v5.4** — Corrigir filtro `file://` em URIs do Nautilus
- [ ] **v5.4** — Escrita atómica do `historico.json` (via `os.replace`)
- [ ] **v5.5** — Diálogo de gestão de histórico (apagar entradas obsoletas)
- [ ] **v5.5** — Thumbnail assíncrono (não bloquear UI)
- [ ] **v5.6** — Modo batch: processar múltiplas pastas em fila
- [ ] **v5.6** — Suporte a vídeos (extração de data via `ffmpeg`)
- [ ] **v6.0** — Versão standalone (fora do Nautilus) com drag-and-drop

---

## 🤝 Contribuir

Consulte [`CONTRIBUTING.md`](./CONTRIBUTING.md) para:

- Configuração do ambiente de desenvolvimento
- Estilo de código (PEP 8 + convenções do projeto)
- Como reportar bugs e propor funcionalidades
- Formato dos commits e PRs

Contribuições são bem-vindas, especialmente:

- Testes com formatos RAW menos comuns
- Traduções da UI para outros idiomas
- Otimização da geração de thumbnails

---

## 📝 Changelog

Histórico completo de versões em [`CHANGELOG.md`](./CHANGELOG.md).

Versão atual: **v5.3** (2024)

---

## 📄 Licença

Distribuído sob licença **MIT**. Consulte [`LICENSE`](./LICENSE) para o texto completo.

```
MIT License

Copyright (c) 2024 Chronos-Photo-Organizer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
...
```

---

## 🙋 Autor

Desenvolvido para uso pessoal, partilhado na esperança de ser útil.

Para questões, abrir uma [issue](https://github.com/Chronos-Photo-Organizer/issues/new) no GitHub.

---

<p align="center">
  Feito com ☕ e GTK3 em Portugal
</p>
