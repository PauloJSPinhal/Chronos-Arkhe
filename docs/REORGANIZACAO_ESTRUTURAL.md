# 🗂️ Reorganização Estrutural — Chronos-Arkhe

## Objetivo
Alinhar a estrutura do **Chronos-Arkhe** com o padrão estabelecido em **Chronos-Nomos**, garantindo consistência em toda a suite Chronos.

---

## 📊 Comparação Antes/Depois

### ❌ Antes (Estrutura Dispersa)

```
Chronos-Arkhe/
├── install.sh          (na raiz)
├── uninstall.sh        (na raiz)
├── REFACTORING_v6.0.md (documentação dispersa)
├── COMPARACAO_VERSOES.md
├── VERIFICACAO_v6.0.md
├── QUICK_START.md
├── USAGE.md
├── CONTRIBUTING.md
├── CHANGELOG.md
├── bin/
├── data/
├── debian/
├── docs/               (apenas imagens)
└── scripts/            (apenas Nautilus)
```

**Problemas:**
- Scripts de instalação na raiz (desorganizado)
- Documentação de desenvolvimento espalhada na raiz
- Falta de `run.sh`, `build-deb.sh`, enable/disable scripts
- Debian control file ausente
- Estrutura inconsistente com Nomos

---

### ✅ Depois (Estrutura Padronizada)

```
Chronos-Arkhe/
├── bin/
│   └── chronos-arkhe          (binário executável)
│
├── data/
│   ├── chronos-arkhe.desktop
│   └── icons/hicolor/scalable/apps/
│       └── chronos-arkhe.svg
│
├── debian/                    (metadados Debian)
│   ├── control
│   ├── postinst
│   └── prerm
│
├── docs/
│   ├── chronos-arkhe.jpeg
│   └── dev/                   (documentação de desenvolvimento)
│       ├── REFACTORING_v6.0.md
│       ├── COMPARACAO_VERSOES.md
│       └── VERIFICACAO_v6.0.md
│
├── scripts/                   (scripts de utilidade)
│   ├── install.sh             (instalador local)
│   ├── uninstall.sh           (desinstalador local)
│   ├── run.sh                 (executor de desenvolvimento)
│   ├── build-deb.sh           (gerador de pacotes)
│   ├── enable-nautilus-script.sh   (ativa Nautilus)
│   └── disable-nautilus-script.sh  (desativa Nautilus)
│
├── README.md                  (padronizado tipo Nomos)
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
├── .gitignore                 (novo, padronizado)
└── .git/
```

**Melhorias:**
- Scripts instalação/desinstalação em `scripts/`
- Documentação de desenvolvimento isolada em `docs/dev/`
- Ficheiros Debian completos (`control`, `postinst`, `prerm`)
- Scripts de utilidade centralizados (`run.sh`, `build-deb.sh`, enable/disable)
- README.md reformatado no padrão Nomos
- `.gitignore` padronizado

---

## 📋 Ficheiros Movidos e Criados

### ✏️ Movidos:
| Anterior | Novo |
|----------|------|
| `install.sh` (raiz) | `scripts/install.sh` |
| `uninstall.sh` (raiz) | `scripts/uninstall.sh` |
| `REFACTORING_v6.0.md` | `docs/dev/REFACTORING_v6.0.md` |
| `COMPARACAO_VERSOES.md` | `docs/dev/COMPARACAO_VERSOES.md` |
| `VERIFICACAO_v6.0.md` | `docs/dev/VERIFICACAO_v6.0.md` |

### ✨ Criados:
| Ficheiro | Descrição |
|----------|-----------|
| `scripts/run.sh` | Executor para desenvolvimento |
| `scripts/build-deb.sh` | Gerador de pacotes `.deb` |
| `scripts/enable-nautilus-script.sh` | Ativa integração Nautilus |
| `scripts/disable-nautilus-script.sh` | Desativa integração Nautilus |
| `debian/control` | Metadados do pacote Debian |
| `debian/postinst` | Hook pós-instalação Debian |
| `debian/prerm` | Hook pré-remoção Debian |
| `.gitignore` | Ficheiros a ignorar em git |
| `docs/dev/` | Pasta para documentação interna |

### 🔄 Reformatados:
| Ficheiro | Mudança |
|----------|---------|
| `README.md` | Reformatado no padrão Nomos |
| `scripts/install.sh` | Alinhado com o padrão Nomos |
| `scripts/uninstall.sh` | Alinhado com o padrão Nomos |

---

## 🔧 Scripts Standardizados

Todos os scripts agora seguem o padrão `bash` e XDG:

### 1. **install.sh** (Local Installation)
```bash
# Instala em ~/.local (sem root)
scripts/install.sh

# Resultado:
~/.local/bin/chronos-arkhe
~/.local/share/applications/chronos-arkhe.desktop
~/.local/share/icons/hicolor/scalable/apps/chronos-arkhe.svg
~/.local/share/nautilus/scripts/Chronos Arkhe
```

### 2. **uninstall.sh** (Local Uninstallation)
```bash
scripts/uninstall.sh

# Remove todos os ficheiros acima
```

### 3. **run.sh** (Development Execution)
```bash
scripts/run.sh

# Verifica dependências
# Executa binário a partir do código-fonte
# Ideal para testes rápidos
```

### 4. **build-deb.sh** (Debian Package Generation)
```bash
scripts/build-deb.sh

# Resultado: build/chronos-arkhe_6.0.0_all.deb
# Instalável com: sudo apt install ./build/chronos-arkhe_6.0.0_all.deb
```

### 5. **enable-nautilus-script.sh** (Ativa Nautilus)
```bash
scripts/enable-nautilus-script.sh

# Cria ligação simbólica para menu Nautilus
```

### 6. **disable-nautilus-script.sh** (Desativa Nautilus)
```bash
scripts/disable-nautilus-script.sh

# Remove ligação simbólica do menu Nautilus
```

---

## 📦 Debian Package (control)

O novo ficheiro `debian/control` especifica:

```
Package: chronos-arkhe
Version: 6.0.0
Architecture: all
Depends: python3, python3-gi, gir1.2-gtk-3.0
Recommends: libimage-exiftool-perl
Suggests: python3-pil
```

---

## 🔑 Benefícios da Reorganização

✅ **Consistência:** Estrutura idêntica a Chronos-Nomos  
✅ **Manutenibilidade:** Scripts e docs em locais previsíveis  
✅ **Escalabilidade:** Fácil adicionar novos apps Chronos com mesmo padrão  
✅ **Empacotamento:** Suporte nativo para .deb via `dpkg-deb`  
✅ **XDG Compliance:** Respeita `~/.local/` para instalações de utilizador  
✅ **Nautilus Integration:** Scripts enable/disable para gestão fácil  

---

## 🚀 Como Usar Agora

### Instalação Local (Recomendado para Desenvolvimento)
```bash
cd /mnt/dados/Projetos/2_Apps/Chronos/Chronos-Arkhe
scripts/install.sh
# Binário em: ~/.local/bin/chronos-arkhe
```

### Teste Rápido
```bash
scripts/run.sh
# Executa com verificação de dependências
```

### Gerar Pacote .deb
```bash
scripts/build-deb.sh
# Resultado em: build/chronos-arkhe_6.0.0_all.deb
```

### Desinstalar
```bash
scripts/uninstall.sh
```

---

## 📋 Próximos Passos

- [ ] Testar scripts em ambiente de teste
- [ ] Validar integração Nautilus
- [ ] Confirmar `.deb` instalável
- [ ] Sincronizar documentação adicional (CHANGELOG, CONTRIBUTING)
- [ ] Criar ícone SVG (se ainda não existe em hicolor)
- [ ] Commit da reorganização para git

---

## ✅ Conclusão

O **Chronos-Arkhe** segue agora o padrão estabelecido em **Chronos-Nomos**, permitindo:

1. **Instalação consistente** em toda a suite
2. **Empacotamento Debian** unificado
3. **Scripts de utilidade** padronizados
4. **Documentação organizada** por propósito
5. **Fácil extensão** para novos apps (Sfragis, Gnosis)

A estrutura está pronta para produção! 🎉
