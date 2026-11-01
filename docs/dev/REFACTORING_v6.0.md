# 🔄 Refactoring v6.0 — Alinhamento com Padrão Chronos

## O que Mudou

A versão 6.0 do Chronos Arkhe foi refactorizada para seguir o **padrão consistente** dos outros projetos Chronos (como Chronos Nomos), melhorando a manutenibilidade e consistência do ecossistema.

### Antes (v5.5)
```python
def main():
    # Lógica direta sem classe
    janela_principal_simples()
    # Diálogos soltos
    janela_por_data()
```

### Depois (v6.0)
```python
class ChronosArkheApp(Gtk.Window):
    def __init__(self):
        # Aplicação estruturada como classe
    
    def _worker(self):
        # Thread worker para operações longas
    
    def _log(self, text):
        # Sistema centralizado de logging

def main():
    app = ChronosArkheApp()
    app.show_all()
    Gtk.main()
```

## Principais Alterações

### 1. Classe Principal `ChronosArkheApp(Gtk.Window)`
✅ **Antes**: Funções dispersas (`janela_principal()`, `janela_por_data()`, `main()`)  
✅ **Depois**: Tudo centralizado em classe para melhor estado e controlo

### 2. Configuração Centralizada
✅ **Antes**: `~/.config/organizar_fotos/historico.json`  
✅ **Depois**: `~/.config/chronos/arkhe.json` (consistente com projeto)

**Benefícios:**
- Todas as apps Chronos usam `~/.config/chronos/`
- Fácil migração entre apps
- Configuração unificada

### 3. Sistema de Logging
✅ **Antes**: Apenas mensagens de sucesso/erro final  
✅ **Depois**: Painel de log em tempo real com função `_log()`

```python
self._log("🚀 Iniciando processamento...")
self._log("✅ 150 fotos agrupadas em 12 datas")
self._log("❌ 2 erro(s) encontrados")
```

### 4. Progress Bar
✅ **Antes**: Sem feedback visual  
✅ **Depois**: Barra de progresso atualizada em tempo real

### 5. Thread Worker
✅ **Antes**: Operações bloqueavam UI  
✅ **Depois**: `_worker()` em thread separada (não bloqueia UI)

```python
def _worker(self):
    for f in self.ficheiros:
        if self.abort:
            break
        # Processar...
```

### 6. Controlo de Cancelamento
✅ **Antes**: Sem forma de cancelar  
✅ **Depois**: Flag `self.abort` permite interrupção segura

## Estrutura Nova

```
bin/chronos-arkhe
├── Imports centralizados
├── CONFIG_DIR & CONFIG_FILE (centralizado)
├── Funções auxiliares
│   ├── load_config()
│   ├── save_config()
│   ├── sanitize()
│   ├── image_to_pixbuf()
│   └── ...
├── Classe ChronosArkheApp(Gtk.Window)
│   ├── __init__()       → Construtor com UI
│   ├── _on_*()          → Handlers de eventos
│   ├── _worker()        → Thread de processamento
│   ├── _log()           → Sistema de logging
│   └── ...
└── main()               → Instancia a app
```

## Compatibilidade

| Feature | v5.5 | v6.0 | Nota |
|---------|------|------|------|
| Modo Nautilus | ✅ | ✅ | Aceita ficheiros e pastas |
| Modo CLI | ✅ | ✅ | Argumentos processados |
| Flag --debug | ✅ | ✅ | Diagnóstico EXIF completo |
| Histórico | ⚠️ | ✅ | Migrado automaticamente para `~/.config/chronos/arkhe.json` |
| UI Interface | ✅ | ✅ | Navegador integrado + diálogo por data com preview |
| Toggle Copiar/Mover | ✅ | ✅ | Mantido |

## Migração de Configuração

Quando o utilizador abrir a app pela primeira vez:
1. App procura `~/.config/chronos/arkhe.json`
2. Se existir `~/.config/organizar_fotos/historico.json` (versões 5.x), importa automaticamente os `eventos`, `locais` e `ultima_pasta`
3. Grava de forma atómica em `~/.config/chronos/arkhe.json`

## Vantagens do Novo Padrão

### 1. **Consistência com Projeto**
- Todas as apps (Arkhe, Nomos, Stragis, Gnosis) seguem o mesmo padrão
- Estrutura previsível e familiar

### 2. **Melhor Manutenção**
- Código mais organizado em classe única
- Menos funções globais
- Estado centralizado

### 3. **Experiência do Utilizador**
- Logging detalhado em tempo real
- Progress bar visual
- Possibilidade de cancelamento
- Não bloqueia UI durante processamento

### 4. **Configuração Unificada**
- `~/.config/chronos/` para todas as apps
- Fácil fazer scripts para setup múltiplo

## Exemplos de Uso

### Programático
```python
import importlib.machinery
import importlib.util

loader = importlib.machinery.SourceFileLoader("chronos_arkhe", "bin/chronos-arkhe")
spec = importlib.util.spec_from_loader("chronos_arkhe", loader)
chronos_arkhe = importlib.util.module_from_spec(spec)
spec.loader.exec_module(chronos_arkhe)

app = chronos_arkhe.ChronosArkheApp(initial_files=["~/Fotos/img1.jpg", "~/Fotos/img2.jpg"])
app.show_all()
chronos_arkhe.Gtk.main()
```

### Modo Nautilus (automático)
```bash
# Nautilus passa ficheiros como argumentos
chronos-arkhe file:///home/user/Fotos/img1.jpg file:///home/user/Fotos/img2.jpg
```

### Modo CLI
```bash
chronos-arkhe ~/Fotos/*.jpg
```

## Melhorias Implementadas e Futuras

- [x] Diálogo por data sincronizado com a main thread (`_run_on_main_thread` + `_dialogo_por_data`)
- [x] Navegador filtrado `OrigensFileBrowser` (`~/Imagens`, `~/Transferências`, Pendrives, Cartões SD e Câmara USB) sem exibir pastas proibidas
- [x] Restrição da Pasta de Destino exclusivamente a `~/Imagens` e respetivas subpastas (`is_destino_permitido`)
- [x] Gestão gráfica de `origens_permitidas` e `pastas_excluidas` em `~/.config/chronos/arkhe.json`
- [x] Botão Abort/Cancelar funcional
- [x] Preview em tempo real do nome da pasta e navegação pelas fotos da coleção
- [ ] Gestão de histórico pela interface (remover entradas antigas)
- [ ] Undo/Redo de operações

## Testes Recomendados

```bash
# 1. Teste sintaxe
python3 -m py_compile bin/chronos-arkhe

# 2. Teste modo aplicação
chronos-arkhe

# 3. Teste modo Nautilus
chronos-arkhe ~/Fotos/img1.jpg ~/Fotos/img2.jpg

# 4. Verifica configuração
cat ~/.config/chronos/arkhe.json
```

## Dúvidas Frequentes

**P: Perdi o meu histórico?**  
R: O histórico antigo em `~/.config/organizar_fotos/` continua lá. Copia manualmente se precisar.

**P: Como volto à versão anterior?**  
R: `cp /tmp/chronos-arkhe.backup bin/chronos-arkhe`

**P: Porque centralizar em ~/.config/chronos/?**  
R: Consistência com todas as apps Chronos, melhor organização.

---

**Status**: ✅ Refactoring completo e testado  
**Compatibilidade**: 100% com v5.5 (exceto local de config)  
**Benefício**: Padrão consistente com projeto
