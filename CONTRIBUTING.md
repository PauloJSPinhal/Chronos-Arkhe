# Contribuir para o Chronos-Photo-Organizer

Obrigado pelo interesse em contribuir! 🎉

Este documento descreve como configurar o ambiente, as convenções de código e o processo para submeter alterações.

---

## 📋 Índice

- [Código de conduta](#-código-de-conduta)
- [Configuração do ambiente](#-configuração-do-ambiente)
- [Estrutura do projeto](#-estrutura-do-projeto)
- [Convenções de código](#-convenções-de-código)
- [Testes](#-testes)
- [Commits](#-commits)
- [Pull Requests](#-pull-requests)
- [Reportar bugs](#-reportar-bugs)
- [Propor funcionalidades](#-propor-funcionalidades)

---

## 🤝 Código de conduta

Participa de forma respeitosa e construtiva. Comentários pessoais, ataques ou discurso de ódio não serão tolerados. Diferenças de opinião técnica são bem-vindas desde que fundamentadas.

---

## 🔧 Configuração do ambiente

### Pré-requisitos

- Python 3.8+
- GTK 3.36+
- `pip` e `venv`

### Passo a passo

1. **Fork e clone** do repositório:

   ```bash
   git clone https://github.com/SEU-USUARIO/Chronos-Photo-Organizer.git
   cd Chronos-Photo-Organizer
   ```

2. **Criar ambiente virtual**:

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```

3. **Instalar dependências de desenvolvimento**:

   ```bash
   pip install Pillow exifread pytest pytest-cov flake8 black
   ```

   > ⚠️ O `pygobject` é instalado via sistema, não via pip. Em Debian/Ubuntu:
   > `sudo apt install python3-gi gir1.2-gtk-3.0`

4. **Instalar como Nautilus Script (opcional, para testes reais)**:

   ```bash
   scripts/enable-nautilus-script.sh
   ```

5. **Executar a partir do código-fonte**:

   ```bash
   scripts/run.sh
   ```

6. **Verificar instalação**:

   ```bash
   python3 -c "import gi; gi.require_version('Gtk', '3.0'); from gi.repository import Gtk; print('GTK OK')"
   python3 -c "from PIL import Image; print('Pillow OK')"
   ```

---

## 📁 Estrutura do projeto

```
Chronos-Arkhe/
├── bin/
│   └── chronos-arkhe            # Aplicação principal (GTK3 + lógica)
├── data/
│   ├── chronos-arkhe.desktop    # Entrada XDG Desktop
│   └── icons/                   # Ícones hicolor
├── debian/                      # Empacotamento Debian
│   ├── control
│   ├── postinst
│   └── prerm
├── docs/                        # Documentação e capturas de ecrã
│   └── dev/                     # Documentação técnica de desenvolvimento
├── scripts/                     # Instalação e utilitários
│   ├── install.sh
│   ├── uninstall.sh
│   ├── run.sh                   # Executor de desenvolvimento
│   ├── build-deb.sh
│   ├── enable-nautilus-script.sh
│   ├── disable-nautilus-script.sh
│   └── organizar-fotos-nautilus
├── CHANGELOG.md
├── CONTRIBUTING.md
├── QUICK_START.md
├── USAGE.md
├── LICENSE
└── README.md
```

---

## 📏 Convenções de código

### Estilo geral

- **PEP 8** com `black` para formatação automática
- **Linhas até 100 caracteres** (não 79 — o script tem strings longas)
- **Indentação**: 4 espaços, sem tabs
- **Encoding**: UTF-8 com header `# -*- coding: utf-8 -*-`

### Convenções específicas do projeto

| Item | Convenção | Exemplo |
|---|---|---|
| Nomes de funções/métodos | `snake_case` em PT | `_obter_data_exif()` |
| Nomes de variáveis | `snake_case` em PT | `historico_eventos` |
| Constantes | `UPPER_SNAKE` em PT ou EN | `IMAGE_EXTS`, `CONFIG_FILE` |
| Métodos internos | Prefixo `_` | `_worker()`, `_log()` |
| Docstrings | Triple-quote duplo | `"""..."""` |
| Mensagens de UI | PT-PT natural | "Pedir Evento e Local para cada data" |

### Verificar antes de commitar

```bash
# Formatar
black bin/chronos-arkhe

# Lint
flake8 bin/chronos-arkhe --max-line-length=100

# Tipo (se adicionares typing)
mypy bin/chronos-arkhe --ignore-missing-imports
```

### Arquitetura

A v6.0 segue o padrão da suite Chronos (ver Chronos-Nomos):

- **Classe principal**: `ChronosArkheApp(Gtk.Window)` encapsula toda a UI e estado
- **Thread worker**: `_worker()` executa o processamento em background
- **Atualizações de UI**: sempre via `GLib.idle_add()` a partir da thread
- **Configuração**: `~/.config/chronos/arkhe.json` (padrão XDG da suite)

---

## 🧪 Testes

### Estado atual

O projeto ainda **não tem suite de testes**. Esta é uma área prioritária para contribuição.

### Prioridades de teste

| Módulo | Função | Prioridade |
|---|---|---|
| Sanitização | `sanitize()` | Alta — lógica central, fácil de testar |
| EXIF | `obter_data_exif()` | Alta — lógica central |
| Sidecars | `get_sidecars()` | Média |
| Histórico | `load_history()` / `save_history()` | Média |
| UI | Diálogos GTK | Baixa — difícil de automatizar |

### Exemplo de estrutura de teste

```python
# tests/test_sanitize.py
import importlib.util
import pytest

spec = importlib.util.spec_from_file_location("chronos_arkhe", "bin/chronos-arkhe")
chronos_arkhe = importlib.util.module_from_spec(spec)
spec.loader.exec_module(chronos_arkhe)

sanitize = chronos_arkhe.sanitize

@pytest.mark.parametrize("input,expected", [
    ("Fim de semana", "Fim-de-semana"),
    ("Trás-os-Montes", "Trás-os-Montes"),
    ("São João!!", "São-João"),
    ("A -- B", "A-B"),
    ("-Natal-", "Natal"),
    ("", "Indefinido"),
])
def test_sanitize(input, expected):
    assert sanitize(input) == expected
```

> Nota: o binário não tem extensão `.py`, por isso os testes importam-no via `importlib.util.spec_from_file_location`.

### Executar testes

```bash
pytest tests/ -v
```

---

## 📝 Commits

### Formato

Seguir [Conventional Commits](https://www.conventionalcommits.org/):

```
<tipo>(<scope>): <descrição>

<corpo opcional>

<footer opcional>
```

### Tipos

| Tipo | Quando usar |
|---|---|
| `feat` | Nova funcionalidade |
| `fix` | Correção de bug |
| `docs` | Apenas documentação |
| `style` | Formatação, sem mudança de código |
| `refactor` | Refactor sem mudança de comportamento |
| `perf` | Melhoria de performance |
| `test` | Adicionar/corrigir testes |
| `chore` | Tarefas de manutenção |

### Exemplos

```bash
git commit -m "feat(exif): adicionar fallback para exifread em RAWs"
git commit -m "fix(sanitize): preservar underscores em nomes de eventos"
git commit -m "docs(readme): adicionar secção de formatos RAW suportados"
git commit -m "refactor(history): usar escrita atómica via os.replace"
```

---

## 🔄 Pull Requests

### Antes de submeter

- [ ] Código formatado com `black`
- [ ] `flake8` sem warnings
- [ ] Testes adicionados para nova funcionalidade
- [ ] Todos os testes a passar
- [ ] `CHANGELOG.md` atualizado em [Unreleased]
- [ ] Commits seguem Conventional Commits

### Processo

1. **Criar branch** a partir de `main`:

   ```bash
   git checkout -b feat/minha-funcionalidade
   ```

2. **Fazer commits pequenos e atómicos** — cada commit deve deixar o código funcional.

3. **Push e abrir PR**:

   ```bash
   git push origin feat/minha-funcionalidade
   ```

4. **No PR, descrever**:
   - O que muda e porquê
   - Como testar manualmente
   - Screenshots (se alterar UI)
   - Issues fechadas (`Closes #123`)

### Critérios de aceitação

- ✅ Mantém o espírito do projeto: **simples, sem dependências pesadas**
- ✅ Não quebra compatibilidade com versões anteriores (a menos que seja major)
- ✅ Código em PT-PT coerente com o resto do script
- ✅ Não introduz dependências desnecessárias (cada nova dep precisa de justificação)

---

## 🐛 Reportar bugs

Usar o template [bug-report.md](./.github/ISSUE_TEMPLATE/bug-report.md).

Informações essenciais:

- Versão do Chronos Arkhe (ver `CHANGELOG.md` ou o cabeçalho de `bin/chronos-arkhe`)
- Distribuição Linux e versão do GNOME
- Versão do Python e do PyGObject
- Formato dos ficheiros envolvidos (JPEG, CR3, NEF, ...)
- Passos para reproduzir
- Output de erro (se houver)

Executar em modo debug para recolher informação útil:

```bash
GTK_DEBUG=all scripts/run.sh foto.jpg 2>&1 | tee debug.log
```

---

## 💡 Propor funcionalidades

Usar o template [feature-request.md](./.github/ISSUE_TEMPLATE/feature-request.md).

Antes de abrir uma issue de funcionalidade, verificar:

- [ ] A funcionalidade está alinhada com o objetivo do projeto (organização de fotos por data)
- [ ] Não existe já uma issue aberta para o mesmo tema
- [ ] A funcionalidade não pode ser resolvida com ferramentas externas (ex.: `exiftool`)

### Áreas onde contribuições são especialmente bem-vindas

- 🧪 **Testes automatizados** — qualquer cobertura é valiosa
- 🌍 **Internacionalização** — extrair strings para `.po`/`.mo`
- ⚡ **Performance** — thumbnails assíncronos, leitura EXIF paralela
- 📦 **Empacotamento** — pacotes `.deb`, `.rpm`, AUR
- 🪟 **Porting Windows** — usando PyGObject + MSYS2 (experimental)

---

## ❓ Dúvidas

- Abrir uma [issue](https://github.com/Chronos-Photo-Organizer/issues) com a label `question`
- Ou contactar via discussões do GitHub (se ativadas)

Obrigado por contribuir! 🚀
