# 🧪 Suíte de Testes Automatizados — Meta-Hub

> **Engenharia de Qualidade, Validação de AST e Testes de Integridade**  
> Repositório: [`heviane/heviane`](https://github.com/heviane/heviane) &bull; Diretório: `meta-hub/tests`  
> Framework: [Pester](https://pester.dev/) &bull; Status: `22/22 Aprovados` 🟢

---

## 📌 1. Visão Geral

Este diretório contém a suíte de testes automatizados das automações PowerShell do **Meta-Hub** ([`meta-hub/scripts`](../scripts/README.md)).

O objetivo primário da suíte é assegurar a integridade contínua do ecossistema de **Docs-as-Code**, garantindo que modificações nos scripts de auditoria de workspace, sincronização de inventário de extensões e sincronização de backlog com o GitHub Project 14 não introduzam regressões sintáticas, quebras de assinatura de CLI ou desvios documentais.

---

## 🧭 2. Matriz de Cobertura de Testes

A suíte principal está implementada em [`scripts.Tests.ps1`](./scripts.Tests.ps1) e cobre **22 cenários de verificação** divididos em 7 contextos arquiteturais:

| Contexto de Teste | Cenários | Alvo de Validação | Mecanismo de Verificação |
| :--- | :---: | :--- | :--- |
| **Integridade dos Arquivos** | 3 | `audit-workspace.ps1`<br>`sync-extensions.ps1`<br>`sync-project-backlog.ps1` | `Test-Path` físico na árvore de código do repositório. |
| **Validação de Sintaxe (AST)** | 3 | Parser de Linguagem PowerShell | `[System.Management.Automation.Language.Parser]::ParseFile` garantindo zero erros de tokenização e parse. |
| **Documentação Nativa** | 6 | Comment-Based Help (`Get-Help`) | Extração da AST de `.Synopsis`, `.Description` e `.Notes` citando pré-requisitos de runtime. |
| **Assinatura de Parâmetros** | 3 | Assinatura de Comandos / CLI | Inspeção de `ParamBlock.Parameters` para flags críticas de controle e escopo. |
| **Tratamento de Exceções** | 3 | Robustez de Entrada | Validação de captura de erros com `-ErrorAction Stop` para caminhos ou arquivos inexistentes. |
| **Detecção Funcional em Sandbox** | 2 | Execução Controlada | Criação de sandbox temporário isolado em `$env:TEMP` com repositórios simulados para testar execução normal e estrita. |
| **Execução em Modo CheckOnly** | 1 | `sync-project-backlog.ps1` | Execução controlada de auditoria com saída limpa e sem efeitos colaterais. |
| **Conformidade Documental** | 1 | `meta-hub/vscode-extensions.md` | Verificação regex da presença da tabela padronizada de extensões. |

---

## 🏛️ 3. Padrões de Arquitetura da Suíte

### 3.1. Compatibilidade Retroativa Universal (Pester 3.4+ / 5.x)

Para permitir que os testes rodem tanto no **Windows PowerShell 5.1 nativo** (que utiliza Pester v3.4 por padrão no Windows) quanto no **PowerShell 7 Core (`pwsh`)** no Ubuntu/macOS do GitHub Actions (que utiliza Pester v5.x), a suíte adota funções auxiliares padronizadas de asserção:

- `Assert-True`: Validação booleana com lançamento de mensagem explicativa.
- `Assert-Equal`: Confronto de igualdade estrita entre valores esperados e obtidos.
- `Assert-Zero`: Verificação semântica de contagem (ex: contagem de erros do AST Parser).
- `Assert-NotEmpty`: Garantia de não vacuidade para metadados de documentação.

Esse padrão evita incompatibilidades de sintaxe entre `Should -Be` (v5) e `Should Be` (v3).

### 3.2. Isolamento Estrito em Sandbox Temporário

Nenhum teste de unidade ou integração executa alterações na raiz real de repositórios:

- Um diretório temporário randômico é instanciado em `BeforeAll` via `[System.IO.Path]::GetTempPath()`.
- Repositórios simulados (estruturas `.git`, arquivos `.gitignore`, `README.md` e `AGENTS.md`) são gerados dinamicamente para validar as regras do `audit-workspace.ps1`.
- A limpeza obrigatória (`Remove-Item -Recurse -Force`) é executada no bloco `AfterAll`.

---

## 🚀 4. Como Executar os Testes Localmente

### 4.1. No Windows PowerShell ou PowerShell 7 (`pwsh`)

A partir da raiz do repositório (`heviane/heviane`):

```powershell
# Execução direta com Pester
Invoke-Pester -Path "meta-hub/tests"

# Execução com saída detalhada
Invoke-Pester -Path "meta-hub/tests" -Output Detailed
```

### 4.2. Via Linha de Comando Isolada

```powershell
pwsh -NoProfile -Command "Invoke-Pester -Path 'meta-hub/tests'"
```

---

## 🔄 5. Integração Contínua (CI/CD)

Os testes são disparados automaticamente pelo workflow do GitHub Actions [`.github/workflows/docs-validation.yml`](../../.github/workflows/docs-validation.yml) em:

- **Gatilhos:** Pushes ou Pull Requests que alterem arquivos em `meta-hub/scripts/**`, `meta-hub/tests/**`, `**.md` ou no próprio workflow.
- **Auditoria Recorrente:** Toda segunda-feira às 08:00 UTC via cron agendado.
- **Job:** `powershell-tests`, que executa a validação sintática estrita de AST e em seguida dispara `Invoke-Pester -Path "meta-hub/tests"`.

---

## 📝 6. Diretrizes para Novos Testes

Ao desenvolver ou expandir funcionalidades nos scripts:

1. **Nomenclatura:** Novos arquivos de teste devem seguir o padrão `<componente>.Tests.ps1`.
2. **Design Compatível:** Utilize as funções `Assert-*` declaradas no bloco `BeforeAll` para manter suporte híbrido Pester 3/5.
3. **Sem Efeitos Colaterais:** Nunca execute ações de escrita fora de diretórios temporários criados dinamicamente no sandbox.
4. **Docs-as-Code:** Para instruções operacionais e detalhes sobre cada script, consulte [`meta-hub/scripts/README.md`](../scripts/README.md).
