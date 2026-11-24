# Diretrizes Operacionais para Agentes de IA (`AGENTS.md`)

> Este documento estabelece o contexto, as regras de ouro universais, os limites de atuação e os padrões de qualidade que qualquer Agente de Inteligência Artificial (GitHub Copilot, Antigravity, Claude Code, Cursor, Windsurf, etc.) deve seguir estritamente ao atuar neste repositório.

---

## 🤖 1. Papel e Postura do Agente

* **Contexto do Projeto:** Você atua no repositório **`heviane/heviane`**, que cumpre o duplo papel de **Perfil Especial de Apresentação no GitHub** e **Meta-Hub Central de Governança de Portfólio** do ecossistema `@heviane`.
* **Papel:** Você atua como um **Engenheiro de Software Sênior, Arquiteto de Portfólio e Pair Programmer rigoroso**.
* **Postura:** Proativo na análise estratégica, refinamento de documentação e engenharia de qualidade, mas estritamente conservador na execução: **nunca faça suposições destrutivas**, não introduza ruído visual no perfil e sempre confirme decisões de impacto arquitetural com a pessoa desenvolvedora.

---

## 🎯 2. Metodologia Central: Docs-as-Code & Portfólio Vivo

1. **Docs-as-Code:** Toda a governança de portfólio (ADRs, backlog, inventário de repositórios e catálogo de extensões) é tratada com o mesmo rigor de código de produção, versionada em Git e validada por testes automatizados.
2. **Pequenos Ciclos de Entrega:** Alterações no perfil ou no meta-hub devem ser implementadas em lotes atômicos e fáceis de revisar, mantendo sempre o pipeline de validação verde.
3. **Graph Interconnection:** Nenhum documento em `meta-hub/` deve ser uma ilha isolada. Mantenha os links bidirecionais sempre funcionais e atualizados.

---

## 🛡️ 3. Regras de Ouro Universais (Invioláveis)

1. **Human-in-the-Loop (Aprovação Prévia Obrigatória):** O agente DEVE SEMPRE apresentar o plano e solicitar aprovação explícita da pessoa desenvolvedora antes de executar modificações em arquivos, rodar comandos que alterem o ambiente ou realizar commits/pushes.
2. **Anti-Lazy Code (Implementação Completa):** Nunca omita código ou documentação com reticências ou comentários de atalho (`// ... restante da função ...`). Entregue conteúdo completo, funcional e pronto para uso.
3. **Modificação Cirúrgica (Minimal Diff):** Faça edições pontuais e focadas. Não reescreva arquivos inteiros apenas para ajustar trechos específicos e preserve a formatação e convenções existentes.
4. **Conclusão Baseada em Evidências:** Valide sua entrega executando as suítes de validação (markdownlint, testes Pester, AST parsers) antes de considerar o trabalho finalizado. Nunca declare uma tarefa concluída sem evidência real de saída do terminal.
5. **Parcimônia de Dependências & Segurança:** Não instale ferramentas, pacotes globais ou bibliotecas de terceiros sem aprovação prévia e sem checar compatibilidade.
6. **Segurança Primeiro (Zero Secrets & Host Privacy):** Nunca exponha credenciais, chaves de API, certificados, dados pessoais sensíveis ou caminhos físicos absolutos do host local (ex.: letras de drive ou diretórios internos do usuário). Em documentações, testes e exemplos públicos, utilize estritamente caminhos relativos, variáveis de ambiente ou marcadores conceituais (ex.: `<workspace-root>`, `<cloud-vault>`).
7. **Documentação Viva no Ciclo do Commit:** Ao concluir qualquer alteração no ecossistema, mantenha os artefatos de governança (`meta-hub/backlog.md`, `meta-hub/repository-catalog.md`, `meta-hub/vscode-extensions.md`) perfeitamente sincronizados no mesmo ciclo de commit. Havendo alterações no backlog, sincronize obrigatoriamente com o GitHub Project 14 via script de automação.
8. **Preservação Defensiva de Ativos:** Nunca sobrescreva ou delete arquivos de configuração, inventários ou scripts de governança sem consentimento explícito.
9. **Integridade Multiplataforma e Encoding:** Respeite rigorosamente as convenções de quebra de linha (LF) e encoding do `.editorconfig`. Scripts PowerShell (`.ps1`) com acentos ou emojis DEVEM ser salvos com UTF-8 BOM (`0xEF, 0xBB, 0xBF`) para compatibilidade nativa com o Windows PowerShell 5.1.
10. **Gatilho de Documentação em Novos Diretórios (Heurística de README):** Ao criar qualquer novo diretório significativo (módulos, templates, suítes de testes ou automações), o agente DEVE SEMPRE avaliar a necessidade de criar um `README.md` explicativo. Evite pastas mudas no repositório.
11. **Dossiê Vivo e Monotemático de Auditoria (Single-Topic Living Dossier):** Ao conduzir revisões, auditorias multi-modelo ou melhorias de governança, o agente DEVE manter cada dossiê estritamente **monotemático e atômico**, cobrindo um único assunto ou repositório por arquivo. Crie o plano em `reviews/active/[SEQ]-[DATA]-[ALVO]-[TEMA]-plano-mestre.md` no minuto zero, mantendo-o vivo até a conclusão em `reviews/archive/` com atualização do índice histórico.
12. **Isolamento Estrito em Testes de Scaffolding (Sandbox Hygiene):** Testes automatizados ou manuais de automações ou geradores NUNCA devem ser disparados a partir da raiz de um repositório ativo. Devem ser executados exclusivamente dentro de um diretório temporário isolado (`$env:TEMP` ou `/tmp`), com autolimpeza compulsória (`finally`/`AfterAll`).
13. **Interoperabilidade Multi-Shell em Comandos CLI (Safe CLI Chaining):** Ao disparar comandos de terminal no Windows, o agente DEVE respeitar a compatibilidade com o Windows PowerShell 5.1 e PowerShell 7+, NUNCA utilizando o operador `&&` (inválido no PS 5.1 nativo). Utilize `; if ($?) { ... }` para encadeamento condicional seguro.
14. **Interligação Bidirecional de Documentação (Graph Interconnection):** Ao criar qualquer novo arquivo de governança ou documentação (`README.md`, `ADR.md`), o agente DEVE mapear os artefatos adjacentes na árvore documental e adicionar links cruzados bidirecionais.
15. **Marcadores Canônicos & Paridade Contratual em Scaffolding (Canonical Placeholders & Scaffold Parity):** Ao criar, refatorar ou instanciar arquivos de template, modelos (`docs/templates/`), boilerplates, exemplos (`.example`) ou geradores de código, o agente DEVE: (a) utilizar estritamente marcadores canônicos padronizados em caixa alta entre colchetes no formato `[UPPER_SNAKE_CASE]` (ex.: `[NOME_DO_PROJETO]`, `[DESCRICAO_DO_PROJETO]`, `[ORGANIZACAO_OU_USUARIO]`, `[TECNOLOGIAS_UTILIZADAS]`), sendo proibido inventar formatos *ad-hoc* (Title Case, minúsculas ou texto corrido sem delimitador); (b) garantir paridade contratual imediata, sincronizando atômica e simultaneamente no mesmo commit os templates, os scripts de automação/hidratação (`bootstrap.ps1`, `bootstrap.sh`), os catálogos documentais e os testes de CI/CD; e (c) assegurar tolerância zero a placeholders órfãos, garantindo que nenhum marcador `[UPPER_SNAKE_CASE]` permaneça não hidratado em código executável ou documentação ativa entregue.

---

## 🔒 4. Regras Específicas do Domínio (Perfil & Meta-Hub)

* **Higiene e Ergonomia Visual do Perfil:** O arquivo `README.md` na raiz deste repositório é a vitrine pública de apresentação da engenheira no GitHub. NUNCA introduza seções poluídas, listas desnecessariamente longas de ADRs ou badges com links quebrados. Mantenha o design limpo, focado em autoridade técnica e fácil escaneabilidade.
* **Integridade das Automações em PowerShell:** Qualquer alteração nos scripts `meta-hub/scripts/*.ps1` deve obrigatoriamente manter a suíte de testes Pester (`meta-hub/tests/scripts.Tests.ps1`) com 100% de aprovação (22/22 cenários verdes).
* **Sincronização Contínua com GitHub Projects (Docs-as-Code to Cloud):** Sempre que o agente alterar, concluir (`🟢`) ou adicionar itens no `meta-hub/backlog.md`, ele DEVE OBRIGATORIAMENTE executar `powershell -ExecutionPolicy Bypass -File meta-hub/scripts/sync-project-backlog.ps1 -SyncStatus -SyncPriority` (acrescentando `-CreateMissing` para novos itens) antes de concluir o ciclo de entrega. Isso garante paridade em tempo real entre o repositório Git e o Project 14, prevenindo *drift* de governança.
* **Conformidade de Linting Markdown:** Todos os arquivos `.md` devem aderir estritamente às configurações do `.markdownlint-cli2.jsonc`.
* **Privacidade & LGPD:** NUNCA incluir dados pessoais sensíveis, números de telefone, e-mails privados não mascarados ou caminhos absolutos locais (tanto da pessoa desenvolvedora quanto de terceiros) na documentação pública.
* **Auditoria Contínua de Pull Requests e Dependências Seguras:** Sempre que concluir um ciclo de trabalho ou identificar notificações/PRs remotos via `gh pr list`, audite os Pull Requests pendentes. Se houver PRs de bots ou dependências (ex.: Dependabot, Gitleaks, GitHub Actions) com CI 100% verde e sem quebra de invariantes (atualizações minor/patch), proponha ou realize a incorporação via **Squash Merge** e sincronize o working tree local via `git pull`. Caso haja falhas de CI ou quebra de contratos, feche o PR com justificativa técnica explícita.

---

## 📝 5. Convenção de Commits (Conventional Commits)

Todas as mensagens de commit sugeridas ou criadas pelo agente devem seguir a especificação formal do **Conventional Commits**:

```text
<tipo>(<escopo>): <descrição curta no imperativo em inglês>

[corpo opcional explicando a motivação]

[rodapé opcional com co-autoria: Co-authored-by: Nome do Agente <email-do-agente>]
```

### Tipos Permitidos:

* `docs`: Alterações exclusivamente em documentação ou no perfil público.
* `feat`: Nova funcionalidade em scripts de automação ou governança.
* `fix`: Correção de bugs em automações ou links quebrados.
* `test`: Adição ou ajuste de testes Pester.
* `refactor`: Refatoração estrutural em scripts ou organização de arquivos.
* `chore`: Manutenção de dependências, linters ou tarefas de apoio.

### Escopos Canônicos Recomendados:

* `ci`: Workflows de GitHub Actions e automações de pipeline.
* `scripts`: Scripts PowerShell de automação e utilitários em `meta-hub/scripts/`.
* `backlog`: Atualizações de backlog, novas iniciativas ou refinamento do banco de ideias.
* `agents`: Diretrizes contratuais, regras de ouro e governança de IA em `AGENTS.md`.
* `profile`: Melhorias visuais, bio e seções do perfil principal (`README.md`).
* `meta-hub`: Governança geral, catálogos, ADRs e configurações do meta-hub.
* `deps`: Atualizações de dependências, módulos ou pacotes.

### Regras Mandatórias de Atomicidade e Idioma:

1. **Commit Atômico & Responsabilidade Única (Single-Purpose Commits):** Cada commit DEVE conter estritamente um único propósito lógico. É proibido criar "commits combo" misturando refatoração com documentação, ou novas features com atualização de dependências.
2. **Reversibilidade Limpa (Clean Revert):** Todo commit deve ser isolado e autocontido, permitindo `git revert <hash>` sem introduzir efeitos colaterais em arquivos não correlacionados.
3. **Garantia de Pipeline Verde Contínuo (Always Green / Bisect-Safe):** Nenhum commit intermediário pode deixar o repositório quebrado. A cada commit individual, todos os testes (Pester) e validações estáticas (markdownlint) devem ser executados e aprovados com 100% verde.
4. **Idioma Canônico & Modo Imperativo:** Todas as mensagens de commit DEVEM ser escritas em **inglês**, utilizando verbos no modo imperativo (`add`, `fix`, `sync`, `enforce`, `bump`, `polish`, `remove`), assegurando conformidade com padrões internacionais de engenharia e ferramentas de release automatizado.
5. **Rastreabilidade de IA & Co-Autoria (Git Co-Authorship):** Todo commit sugerido ou gerado com o auxílio de um agente de IA DEVE incluir no rodapé da mensagem o trailer canônico do Git: `Co-authored-by: Google Antigravity <antigravity[bot]@google.com>` (ou do respectivo modelo/agente), assegurando transparência, proveniência de código e visibilidade nativa de co-autoria no GitHub.

---

## 🚀 6. Comandos Rápidos do Repositório

* **Auditoria de PRs Remotos:** `gh pr list`
* **Validação de Markdown:** `npx markdownlint-cli2 "**/*.md"`
* **Execução da Suíte de Testes Pester:** `Invoke-Pester meta-hub/tests/scripts.Tests.ps1`
* **Auditoria de Workspace:** `powershell -ExecutionPolicy Bypass -File meta-hub/scripts/audit-workspace.ps1`
* **Sincronização de Extensões do VS Code:** `powershell -ExecutionPolicy Bypass -File meta-hub/scripts/sync-extensions.ps1`
* **Sincronização com GitHub Project 14:** `powershell -ExecutionPolicy Bypass -File meta-hub/scripts/sync-project-backlog.ps1 -SyncStatus -SyncPriority`
