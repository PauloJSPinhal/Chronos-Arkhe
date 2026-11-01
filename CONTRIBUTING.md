# Contribuir para o Chronos Arkhe

Obrigado pelo interesse em contribuir! 🎉

Este documento descreve como configurar o ambiente, as convenções de código e o processo para submeter alterações ao **Chronos Arkhe**.

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
- GTK 3.24+ (`python3-gi`, `gir1.2-gtk-3.0`)
- Pillow (`python3-pil`)

### Passo a passo

1. **Fork e clone** do repositório:

   ```bash
   git clone https://github.com/PauloJSPinhal/Chronos-Arkhe.git
   cd Chronos-Arkhe
   ```

2. **Instalar dependências de sistema e desenvolvimento**:

   ```bash
   sudo apt install python3-gi python3-gi-cairo gir1.2-gtk-3.0 python3-pil python3-exifread libimage-exiftool-perl
   pip install pytest pytest-cov flake8 black
   ```

3. **Ativar como Nautilus Script (opcional, para testes reais)**:

   ```bash
   ./scripts/enable-nautilus-script.sh
   ```

4. **Executar a partir do código-fonte**:

   ```bash
   ./scripts/run.sh
   ```

5. **Verificar instalação**:

   ```bash
   python3 -c "import gi; gi.require_version('Gtk', '3.0'); from gi.repository import Gtk; print('GTK OK')"
   python3 -c "from PIL import Image; print('Pillow OK')"
   ```

---

## 📁 Estrutura do projeto

```text
Chronos-Arkhe/
├── bin/
│   └── chronos-arkhe            # Aplicação principal (GTK3 + lógica)
├── data/
│   ├── chronos-arkhe.desktop    # Entrada XDG Desktop
│   └── icons/                   # Ícone vetorial hicolor
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
- **Linhas até 100 caracteres**
- **Indentação**: 4 espaços, sem tabs
- **Encoding**: UTF-8 com header `# -*- coding: utf-8 -*-`

### Convenções específicas do projeto

| Item | Convenção | Exemplo |
|---|---|---|
| Nomes de funções/métodos | `snake_case` em PT | `obter_data_exif()` |
| Nomes de variáveis | `snake_case` em PT | `historico_eventos` |
| Constantes | `UPPER_SNAKE` em PT ou EN | `IMAGE_EXTS`, `CONFIG_FILE` |
| Métodos internos | Prefixo `_` | `_worker()`, `_log()`, `_dialogo_por_data()` |
| Docstrings | Triple-quote duplo | `"""..."""` |
| Mensagens de UI | PT-PT natural | `"Pedir Evento e Local para cada data (coleção)"` |

### Verificar antes de commitar

```bash
# Validar sintaxe
python3 -m py_compile bin/chronos-arkhe

# Formatar
black bin/chronos-arkhe

# Lint
flake8 bin/chronos-arkhe --max-line-length=100
```

### Arquitetura

A v6.0 segue o padrão da suite Chronos:

- **Classe principal**: `ChronosArkheApp(Gtk.Window)` encapsula toda a UI e estado
- **Thread worker**: `_worker()` executa a leitura EXIF e a cópia/movimentação em background
- **Diálogos e UI**: sempre executados na main thread via `GLib.idle_add()` ou `_run_on_main_thread()`
- **Configuração**: `~/.config/chronos/arkhe.json` (padrão XDG da suite)

---

## 🧪 Testes

### Prioridades de teste

| Módulo | Função | Prioridade |
|---|---|---|
| Sanitização | `sanitize()` | Alta — lógica central, fácil de testar |
| EXIF | `obter_data_exif()` | Alta — lógica central |
| Regras de Origem e Destino | `is_origem_permitida()` / `is_destino_permitido()` / `is_pasta_excluida()` | Alta — segurança de navegação |
| Expansão de caminhos | `_expandir_caminhos()` | Média |
| Sidecars | `get_sidecars()` | Média |
| Configuração/Histórico | `load_config()` / `save_config()` | Média |

### Exemplo de estrutura de teste

Como o executável `bin/chronos-arkhe` não tem extensão `.py`, importa-se com `SourceFileLoader`:

```python
# tests/test_sanitize.py
import importlib.machinery
import importlib.util
import pytest

loader = importlib.machinery.SourceFileLoader("chronos_arkhe", "bin/chronos-arkhe")
spec = importlib.util.spec_from_loader("chronos_arkhe", loader)
chronos_arkhe = importlib.util.module_from_spec(spec)
spec.loader.exec_module(chronos_arkhe)

sanitize = chronos_arkhe.sanitize

@pytest.mark.parametrize("entrada,esperado", [
    ("Fim de semana", "Fim-de-semana"),
    ("Trás-os-Montes", "Trás-os-Montes"),
    ("São João!!", "São-João"),
    ("A -- B", "A-B"),
    ("-Natal-", "Natal"),
    ("", "Indefinido"),
])
def test_sanitize(entrada, esperado):
    assert sanitize(entrada) == esperado
```

---

## 📝 Commits

Seguir [Conventional Commits](https://www.conventionalcommits.org/):

```text
<tipo>(<scope>): <descrição>
```

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

---

## 🔄 Pull Requests

### Antes de submeter

- [ ] `python3 -m py_compile bin/chronos-arkhe` sem erros
- [ ] Testes funcionais verificados
- [ ] `CHANGELOG.md` atualizado
- [ ] Commits seguem Conventional Commits

---

## 🐛 Reportar bugs

Ao abrir uma issue, inclui:

- Versão do Chronos Arkhe (ver `CHANGELOG.md` ou cabeçalho de `bin/chronos-arkhe`)
- Distribuição Linux e versão do GNOME
- Versão do Python, Pillow e PyGObject
- Formato dos ficheiros envolvidos (JPEG, CR3, NEF, ...)
- Output em modo debug:

```bash
./scripts/run.sh --debug foto.jpg 2>&1 | tee debug.log
```

---

## 💡 Propor funcionalidades

Antes de abrir uma issue de funcionalidade, verificar:

- [ ] A funcionalidade está alinhada com o objetivo do projeto (organização de fotos por coleção/data)
- [ ] Não existe já uma issue aberta para o mesmo tema

---

## ❓ Dúvidas

- Abrir uma [issue](https://github.com/PauloJSPinhal/Chronos-Arkhe/issues) no GitHub.

Obrigado por contribuir! 🚀
