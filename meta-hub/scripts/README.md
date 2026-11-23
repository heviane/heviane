# 🛠️ Automações PowerShell do Meta-Hub (Docs-as-Code)

> **Scripts de Governança, Auditoria Contínua e Sincronização do Ecossistema**  
> Repositório: [`heviane/heviane`](https://github.com/heviane/heviane) &bull; Diretório: `meta-hub/scripts`  
> Responsável: [Heviane Bastos](https://github.com/heviane)

---

## 📌 1. Visão Geral

Este diretório contém os utilitários de automação desenvolvidos em **PowerShell** para operacionalizar os processos de **Docs-as-Code**, auditoria de repositórios locais e sincronização do inventário de extensões do VS Code.

Os scripts seguem as boas práticas de engenharia de automação:

- Compatibilidade mista com **Windows PowerShell 5.1** e **PowerShell 7 Core (`pwsh`)**.
- Bloqueio e documentação via **Comment-Based Help** padronizado (`Get-Help`).
- Suporte a modo somente leitura / dry-run (`-CheckOnly`, comportamento read-only por padrão).
- Códigos de saída semânticos (`Exit 0` para conformidade e `Exit 1` para desvios/erros), viabilizando pipelines de CI/CD.
- Testes automatizados via **Pester 3.4+ / 5+** documentados em [`meta-hub/tests`](../tests/README.md) e implementados em [`scripts.Tests.ps1`](../tests/scripts.Tests.ps1).

---

## 🗂️ 2. Catálogo de Scripts

| Script | Finalidade Principal | Modo Padrão | Suporte Dry-Run | Ferramentas no `PATH` |
| :--- | :--- | :--- | :---: | :--- |
| **[`audit-workspace.ps1`](./audit-workspace.ps1)** | Varredura de integridade Git (dirty, unpushed), conformidade documental (`AGENTS.md`, `README.md`) e detecção de arquivos sensíveis. | Somente Leitura | ✅ Nativo (read-only) | `git` |
| **[`sync-extensions.ps1`](./sync-extensions.ps1)** | Sincronização do inventário de extensões do VS Code com o documento de governança [`vscode-extensions.md`](../vscode-extensions.md). | Escrita (atualização) | ✅ Flag `-CheckOnly` | `code` (VS Code CLI) |
| **[`sync-project-backlog.ps1`](./sync-project-backlog.ps1)** | Reconciliação e sincronização automatizada dos itens do `backlog.md` com o GitHub Project 14 via `gh` CLI. | Escrita / Sync | ✅ Flag `-CheckOnly` | `gh` (GitHub CLI) |

---

## 💻 3. Pré-Requisitos de Runtime & Compatibilidade

| Requisito | Especificação Mínima | Observações |
| :--- | :--- | :--- |
| **Runtime PowerShell** | PowerShell 5.1 (Windows) ou PowerShell 7.0+ (`pwsh`) | Suporta execução nativa em Windows, macOS e Linux (Ubuntu). |
| **Git CLI** | Git 2.30+ | Obrigatório para o `audit-workspace.ps1` (necessário estar no `PATH`). |
| **VS Code CLI** | Visual Studio Code 1.80+ | Obrigatório para o `sync-extensions.ps1` (`code` no `PATH`). |
| **GitHub CLI** | GitHub CLI 2.20+ (`gh`) | Obrigatório para o `sync-project-backlog.ps1` com escopo `project` habilitado (`gh` no `PATH`). |
| **Execution Policy** | `RemoteSigned` ou `Bypass` no escopo do processo | `Set-ExecutionPolicy -Scope Process RemoteSigned` para executar scripts locais sem alterar o sistema. |
| **Codificação de Arquivo** | UTF-8 com BOM (Byte Order Mark) | Garante compatibilidade estrita com o parser AST do Windows PowerShell 5.1 e com o Linux `pwsh`. |

---

## 🚀 4. Guia de Execução & Exemplos

### 4.1. Auditoria de Repositórios (`audit-workspace.ps1`)

Varre todos os repositórios Git presentes sob a raiz de projetos:

```powershell
# Execução básica (exibe apenas repositórios com pendências ou desvios)
.\audit-workspace.ps1

# Exibe a tabela completa de todos os repositórios (incluindo limpos)
.\audit-workspace.ps1 -Detailed

# Executa 'git fetch' silencioso antes da análise para atualizar ahead/behind reais
.\audit-workspace.ps1 -Detailed -Fetch

# Auditoria estrita (considera ausência de AGENTS.md ou README.md como alerta)
.\audit-workspace.ps1 -StrictGovernance -Detailed

# Exporta o relatório consolidado em Markdown com timestamp para o Google Drive
.\audit-workspace.ps1 -Detailed -ExportReport
```

#### Parâmetros de `audit-workspace.ps1`

- `-BasePath <String>`: Caminho da raiz dos repositórios (Padrão: `<workspace-root>/GitHub` ou diretório local configurado).
- `-Detailed`: Exibe a tabela completa no console, mesmo de repositórios sem alterações.
- `-Fetch`: Sincroniza as referências remotas do Git antes de calcular `ahead`/`behind`.
- `-StrictGovernance`: Sinaliza repositórios que não contêm `AGENTS.md`, `README.md` ou `.gitignore`.
- `-ExportReport`: Salva relatório executivo `.md` com carimbo de data/hora no diretório corporativo de auditorias.
- `-ReportPath <String>`: Caminho de destino para exportação do relatório.

---

### 4.2. Sincronização de Extensões (`sync-extensions.ps1`)

Audita as extensões instaladas no VS Code contra a documentação oficial:

```powershell
# Modo Dry-Run / CI: Apenas verifica conformidade sem alterar nenhum arquivo
# Retorna Exit 0 se o documento estiver sincronizado, ou Exit 1 se houver divergências
.\sync-extensions.ps1 -CheckOnly

# Modo de Atualização: Regenera tabelas, contagens e snippets em vscode-extensions.md
.\sync-extensions.ps1

# Especificando um caminho customizado para o documento
.\sync-extensions.ps1 -DocPath "<caminho-customizado>\vscode-extensions.md"
```

#### Parâmetros de `sync-extensions.ps1`

- `-DocPath <String>`: Caminho para o arquivo Markdown do inventário (Padrão: `..\vscode-extensions.md`).
- `-CheckOnly`: Modo de auditoria sem modificação em disco. Ideal para verificação em pipelines de CI.

### 4.3. Sincronização com o GitHub Project 14 (`sync-project-backlog.ps1`)

Audita e reconcilia as tarefas documentadas no `backlog.md` com o quadro Kanban do GitHub Projects:

```powershell
# Modo auditoria / dry-run (apenas diagnostica divergências sem alterar o Project 14)
.\sync-project-backlog.ps1 -CheckOnly

# Sincroniza status de cards existentes que divergiram do Markdown
.\sync-project-backlog.ps1 -SyncStatus

# Sincroniza status e prioridades (P0, P1, P2) de cards existentes
.\sync-project-backlog.ps1 -SyncStatus -SyncPriority

# Reconciliação total: cria itens ausentes como Draft Issues e sincroniza status/prioridades
.\sync-project-backlog.ps1 -CreateMissing -SyncStatus -SyncPriority
```

#### Parâmetros de `sync-project-backlog.ps1`

- `-BacklogPath <String>`: Caminho para o arquivo Markdown do backlog (Padrão: `meta-hub/backlog.md`).
- `-ProjectNumber <Int>`: Número do projeto GitHub Projects v2 (Padrão: `14`).
- `-Owner <String>`: Usuário ou organização dona do projeto (Padrão: `heviane`).
- `-CheckOnly`: Executa em modo somente leitura comparando o Markdown com o GitHub Projects.
- `-CreateMissing`: Cria itens ausentes do Markdown no GitHub Projects como Draft Issues.
- `-SyncStatus`: Atualiza o campo Status dos cards existentes para refletir o Markdown.
- `-SyncPriority`: Atualiza o campo Priority dos cards existentes para refletir o Markdown.
- `-NonInteractive`: Suprime confirmações para execução em pipelines automatizados.

---

## 🚦 5. Códigos de Saída (*Exit Codes*) para CI/CD

Ambos os scripts utilizam códigos de saída semânticos para facilitar a orquestração em esteiras de integração contínua (GitHub Actions, Azure DevOps, pipelines locais):

| Código | Significado | Comportamento no Pipeline |
| :---: | :--- | :--- |
| `0` | **Sucesso / Em Conformidade** | O pipeline prossegue normalmente. Em `-CheckOnly`, indica que a documentação está 100% atualizada com o ambiente. |
| `1` | **Erro / Divergência Detectada** | Interrompe o pipeline. Indica erro fatal (ex: dependência ausente, caminho inexistente) ou divergência documental no modo `-CheckOnly`. |

---

## 🧪 6. Testes Automatizados (Pester)

A integridade dos scripts, a validação de sintaxe via AST Parser e as assinaturas de parâmetros são validadas pela suíte de testes Pester (consulte a documentação completa da suíte em [`meta-hub/tests/README.md`](../tests/README.md)):

```powershell
# Execução da suíte de testes Pester localmente
Invoke-Pester -Path "meta-hub/tests"
```

A suíte cobre:

- Existência física dos scripts.
- Validação estrita de sintaxe via `[System.Management.Automation.Language.Parser]::ParseFile`.
- Validação de declaração de parâmetros obrigatórios (`DocPath`, `CheckOnly`, `BasePath`, `StrictGovernance`, `ExportReport`).
- Conformidade estrutural da tabela no inventário de extensões.
