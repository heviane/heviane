# Backlog Mestre de Governança e Portfólio

> **Docs-as-Code — AI Engineering Hub**  
> Repositório Central: [`heviane/heviane/meta-hub`](https://github.com/heviane/heviane/tree/main/meta-hub)  
> Quadro Executivo: [AI Engineering Hub — Portfolio & Roadmap (Project 14)](https://github.com/users/heviane/projects/14)  
> Versão Atual: `v1.3.0` &bull; **Última Atualização:** 24/11/2026

---

## 📌 Sumário Executivo

Este backlog centraliza as iniciativas de modernização dos repositórios, governança ágil e práticas de **Engenharia de Software Assistida por IA** do ecossistema `@heviane`.  
Ele segue os princípios de **Docs-as-Code**, **Flight Levels (Coordenação de Portfólio)** e **Spec-Driven Development (SDD)**.

---

## 🚦 Legenda de Status e Prioridades

* Status: 🟢 `[Concluído]` &bull; 🟡 `[Em Andamento]` &bull; ⚪ `[A Fazer]` &bull; 💡 `[Ideação / Em Análise]`
* Prioridade: `P0` (Crítica / Bloqueante) &bull; `P1` (Alta) &bull; `P2` (Média) &bull; `P3` (Baixa)

---

## 🎯 Épicos e Iniciativas

### Épico 1: Padronização do Ambiente de Desenvolvimento (VS Code) — 🟢 100% Concluído

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| 🟢 | `ENV-01` | `P0` | **Auditoria e Otimização de Extensões** | Mapear extensões ativas e desinstalar ferramentas não utilizadas (ecossistemas Jupyter/Data Science e Azure). |
| 🟢 | `ENV-02` | `P1` | **Inventário Documentado & Backup** | Gerar documento [`vscode-extensions.md`](./vscode-extensions.md) com as 76 extensões ativas, propósitos individuais e script PowerShell de restauração. |
| 🟢 | `ENV-03` | `P2` | **Workspace Multi-Root (`.code-workspace`)** | Criar arquivo `github.code-workspace` na raiz do workspace para unificar navegação dos repositórios sem conflito de Git. |
| 🟢 | `ENV-04` | `P1` | **Automação do Inventário de Extensões (`sync-extensions.ps1`)** | Script implementado em [`scripts/sync-extensions.ps1`](./scripts/sync-extensions.ps1) para sincronizar e auditar automaticamente o inventário `vscode-extensions.md` via VS Code CLI, com suporte à flag `-CheckOnly` para CI. |

---

### Épico 2: Governança Ágil & Estrutura de Portfólio (Flight Levels) — 🟢 100% Concluído

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| 🟢 | `GOV-01` | `P0` | **Definição de Arquitetura de Governança** | Definir `heviane/heviane/meta-hub` como diretório oficial para Docs-as-Code e artefatos centrais. |
| 🟢 | `GOV-02` | `P1` | **Criação do Meta-Hub README** | Criar [`README.md`](./README.md) executivo com diagramas de Flight Levels e governança. |
| 🟢 | `GOV-03` | `P0` | **Criação de Docs no Meta-Hub** | Centralizar `backlog.md` e `vscode-extensions.md` exclusivamente no repositório de governança. |
| 🟢 | `GOV-04` | `P1` | **Integração com Project 14** | Conectar e cadastrar as tarefas priorizadas no [AI Engineering Hub (Project 14)](https://github.com/users/heviane/projects/14). |
| 🟢 | `GOV-05` | `P2` | **ADR-0001: Adoção de SDD e IA no SDLC** | Criar registro formal de decisão arquitetural (ADR) sobre a metodologia de IA e governança Docs-as-Code ([`ADR-0001`](./adrs/0001-adocao-sdd-ia-sdlc.md)). |
| 🟢 | `GOV-06` | `P1` | **AGENTS.md Global do Workspace** | Criar diretrizes operacionais de IA na raiz do workspace para governança multi-repositório. |
| 🟢 | `GOV-07` | `P1` | **Multi-Agent Review Framework (MARF)** | Padronizar processo operacional de auditoria multi-modelo (SOP), taxonomia em inglês (`active/`, `archive/`), lotes dinâmicos (`Lote 1..N`) e modelos canônicos no starter kit ([#10](https://github.com/heviane/heviane/issues/10)). |
| 🟢 | `GOV-08` | `P1` | **Catálogo Unificado de Repositórios (`repository-catalog.md`)** | Inventário consolidado dos 24 repositórios públicos em [`repository-catalog.md`](./repository-catalog.md), com inventário completo (51 repositórios) mantido no cofre em nuvem conforme ADR-0002. |
| 🟢 | `GOV-09` | `P0` | **Formalização da Arquitetura AI-SEP (ADR-0003)** | Formalização arquitetural da plataforma integrando Governança (Meta-Hub), Templates (Starter Kit), Metodologia (SDD) e Contratos de IA ([`ADR-0003`](./adrs/0003-formalizacao-arquitetura-ai-sep.md)). |
| 🟢 | `GOV-10` | `P1` | **Engenharia de Testes Pester & Validação AST (`meta-hub/tests`)** | Formalização da arquitetura da suíte com 15 testes em 6 contextos, padrão de compatibilidade universal Pester 3/5 e isolamento em sandbox temporário ([`meta-hub/tests/README.md`](./tests/README.md)). |
| 🟢 | `GOV-11` | `P1` | **Catálogo Canônico de Contratos de IA (`agents-catalog.md`)** | Criação do inventário centralizado de todos os `AGENTS.md` do ecossistema, com taxonomia em 4 níveis, descrição de escopos, especificidades de domínio e matriz de paridade das 15 Regras de Ouro. |

---

### Épico 3: Starter Kit & Padrões para Desenvolvimento Assistido por IA — 🟢 100% Concluído

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| 🟢 | `IA-01` | `P0` | **Modernização do `project-starter-kit`** | Atualizar repositório `heviane/project-starter-kit` transformando-o em base para IA e SDD. |
| 🟢 | `IA-02` | `P0` | **Template `AGENTS.md`** | Criar diretrizes operacionais para IAs (regras de stack, restrições, convenções de código e commits). |
| 🟢 | `IA-03` | `P1` | **Template `SPEC.md` (SDD)** | Criar modelo de especificação funcional e técnica para desenvolvimento guiado por requisitos. |
| 🟢 | `IA-04` | `P1` | **Template `ADR.md`** | Criar modelo padrão de Architecture Decision Record para decisões de design nos projetos. |
| 🟢 | `IA-05` | `P2` | **Instruções Copilot (`.github/copilot-instructions.md`)** | Configurar instruções automáticas nativas para VS Code e GitHub Copilot. |
| 🟢 | `IA-06` | `P2` | **Configurar GitHub Template Repository** | Habilitar a flag "Template repository" no GitHub para permitir *"Use this template"* com 1 clique. |
| 🟢 | `IA-07` | `P1` | **Catálogo Canônico de Templates SDD/AI-SEP** | Criação do guia oficial dos 7 templates em [`docs/templates/README.md`](https://github.com/heviane/project-starter-kit/tree/main/docs/templates), com ciclo de vida em 4 fases e paridade com scripts de bootstrap. |
| 🟢 | `IA-08` | `P0` | **Institucionalização das Regras de Ouro nos AGENTS.md** | Formalização das Regras 10 a 15 (Heurística de README, Dossiê Vivo Monotemático, Sandbox Hygiene, Safe CLI, Doc Linking e Marcadores Canônicos) em todos os contratos de IA. |
| 🟢 | `IA-09` | `P1` | **Guia de Segurança & Guardrails para Agentes de IA (`guia-seguranca-agentes-ia.md`)** | Elaboração do guia canônico em `docs/guia-seguranca-agentes-ia.md` no `project-starter-kit`, cobrindo as 4 camadas de proteção (Zero Secrets com Gitleaks, Branch Protection, Allowlist de Comandos e Segregação/Dev Containers) com checklist de 5 minutos e links bidirecionais. |

---

### Épico 4: Organizações e Repositórios no GitHub — ⚪ A Fazer

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| ⚪ | `ORG-01` | `P1` | **Padronização da Organização `@heviane-labs`** | Configurar bio, avatar, README de organização e vincular projetos ao Project 14. |
| ⚪ | `ORG-02` | `P1` | **Padronização da Organização `@heviane-learning`** | Alinhar laboratórios de cursos (DIO, Alura) com tags claras de trilhas de aprendizado. |
| ⚪ | `ORG-03` | `P2` | **README Playbook / Templates de README** | Criar repositório público `readme-playbook` com templates estruturados por perfil (API, SaaS, CLI, Open-Source). |

---

### Épico 5: Consolidação do Workspace Mestre & Governança em Nuvem (Google Drive) — 🟢 100% Concluído

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| 🟢 | `WS-01` | `P0` | **Segregação de Governança Local em Nuvem** | Migrar governança local privada para unidade em nuvem dedicada (`<governance-cloud>/workspace-local`), garantindo backup em tempo real e proteção contra perda de dados locais. |
| 🟢 | `WS-02` | `P1` | **Unificação do Multi-Root Workspace (`github.code-workspace`)** | Consolidar a navegação em um único arquivo de workspace mestre, eliminando redundâncias (`github-all` e `github-local`) e duplicidades no Explorer. |
| 🟢 | `WS-03` | `P1` | **Promoção do `meta-hub` a Raiz de Primeiro Nível** | Integrar `heviane/heviane/meta-hub` diretamente no topo do workspace para acesso instantâneo a backlogs, ADRs e scripts de auditoria. |
| 🟢 | `WS-04` | `P1` | **Pipeline de CI/CD para Governança Docs-as-Code** | GitHub Actions com `markdownlint-cli2`, Lychee link checker e validação de sintaxe de scripts PowerShell. |
| 🟢 | `WS-05` | `P1` | **Automação Docs-as-Code com GitHub CLI (`sync-project-backlog.ps1`)** | Criar script PowerShell para auditar e reconciliar automaticamente os itens do `backlog.md` no GitHub Project 14 via `gh` CLI. |

---

### Épico 6: Soluções Core em Produção & Portfólio Ativo — 🟢 Concluído / 💡 Em Expansão

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| 🟢 | `SOL-01` | `P0` | **Middleware NFS-e Nacional API (`nfse-nacional-api`)** | Desenvolvimento completo de middleware em Java 17 com core fiscal (validação XSD v1.00, RSA-SHA256, mTLS) e Camada Anticorrupção (ACL SOAP GeneXus 18). |
| 🟢 | `SOL-02` | `P1` | **Template Institucional Web (`institutional-website-template`)** | Criação de template corporativo moderno, reutilizável para clientes e alinhado a práticas de desenvolvimento assistido por IA. |
| 💡 | `SOL-03` | `P1` | **Branch Protection & Rulesets para Clientes em Produção** | Definição de regras estritas de proteção de branch (`main`) e GitHub Repository Rulesets exclusivamente para projetos de clientes reais em produção: exigência de branch isolada (`feat/`), Pull Request obrigatório, bloqueio de force-push e Quality Gate com CI/Gitleaks verde antes do merge. |
| 💡 | `SOL-04` | `P2` | **Identidade de Agente & Machine User via GitHub App (Produção)** | Arquitetura de autenticação segregada e geração de tokens efêmeros via GitHub App dedicada exclusivamente para ambientes de clientes reais em produção, exibindo selo oficial de bot (`[bot]`) e isolando credenciais pessoais. |

---

### Épico 7: Workspace de Carreira, Empregabilidade & Marca Pessoal — 🟡 Em Planejamento

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| 🟡 | `CAR-01` | `P0` | **Especificação do Workspace Profissional** | Planejar arquitetura de workspace dedicado à carreira, portfólio, blog técnico e autoridade no mercado. |
| ⚪ | `CAR-02` | `P1` | **Repositório Privado de Bastidores no Google Drive** | Estruturar pasta segura em `<personal-vault>/career/` para rascunhos, estudos, estratégias comerciais e dados sensíveis. |
| ⚪ | `CAR-03` | `P1` | **Ativos Públicos de Autoridade Técnica** | Criar os repositórios públicos `blog`, `portfolio` e `news-letter` a partir de templates de produtos. |

---

### Épico 8: Perfil Principal & Apresentação no GitHub (`heviane/heviane`) — 🟢 100% Concluído

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| 🟢 | `PRF-01` | `P1` | **Diferenciação de Stacks Consolidadas vs. Tecnologias em Estudo** | Segmentar a seção de competências no perfil principal entre *Competências Consolidadas em Produção* e *Em Especialização / Aprofundamento*, aumentando a credibilidade técnica e precisão curricular. |
| 🟢 | `PRF-02` | `P1` | **Enriquecimento Estratégico da Bio e Headline Profissional** | Refinar a apresentação do perfil com headline de alto impacto (*Software Developer \| Backend & Web Architecture \| AI-Assisted Engineering*), proposta de valor explícita e objetivos profissionais claros. |

---

## 💡 Banco de Ideias & Sugestões de Melhorias

Propostas técnicas e oportunidades mapeadas para avaliação nas próximas iterações:

1. **`ai-dev-journey` (Blog Técnico de Engenharia & Plataforma Editorial):**  
   Criação de blog técnico Docs-as-Code (baseado em Astro ou Next.js) e série editorial documentando a jornada de transição de *Desenvolvedor Tradicional (10+ anos)* para *AI-Assisted Software Engineer*. Canal de autoridade técnica proprietário integrado com publicações no LinkedIn e vitrine de portfólio.
2. **Extração de `CHANGELOG.md` no Meta-Hub:**  
   Migrar épicos antigos totalmente concluídos para um histórico formal de mudanças seguindo o padrão internacional *[Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/)* (com versionamento SemVer). A extração será realizada no momento oportuno de consolidação de uma versão/release formal do repositório (ex.: transição para a `v2.0.0` ou quando o backlog ultrapassar 300+ linhas), mantendo até lá o `backlog.md` com autoridade técnica completa, evidência de entrega e sem gerar fragmentação prematura.
3. **Linter de Commits e Validação Semântica no CI (`commitlint`):**  
   Implementar verificação automatizada de mensagens de commits e títulos de Pull Requests no GitHub Actions utilizando `commitlint` (ou workflow com script de verificação regex), garantindo a aplicação estrita do padrão *Conventional Commits*, catálogo canônico de escopos e prevenção de desvios semânticos.
4. **Automação de Geração de Changelog e Releases Semânticas (`Release Please`):**  
   Integrar automação de release via GitHub Actions (ex.: Google `release-please-action` ou `standard-version`) acoplada ao padrão *Keep a Changelog*, permitindo que cada ciclo de entrega atômico calcule automaticamente incrementos SemVer (`patch`, `minor`, `major`), crie/atualize o `CHANGELOG.md` e publique GitHub Releases formais sem esforço manual.
5. **Governança de Branch Protection & Repository Rulesets para Clientes em Produção (`SOL-03`):**  
   Estabelecer playbook e modelo de configuração de *GitHub Repository Rulesets* estritos (`Settings -> Rules -> Rulesets`) exclusivamente para repositórios de clientes reais em ambiente produtivo, impondo bloqueio de commits diretos na `main`, fluxo obrigatório via branch de feature (`feat/*`), abertura de PR, bloqueio de force-push e aprovação vinculada a status checks de CI verdes (testes, lint e varredura de segredos via Gitleaks).
6. **Segregação de Credenciais & Identidade de Bot via GitHub App (`SOL-04`):**  
   Estruturação de GitHub App corporativa para projetos de clientes em produção, eliminando o uso de Personal Access Tokens (PATs) pessoais nas esteiras automatizadas, garantindo geração automática de tokens efêmeros com permissões mínimas e rastreabilidade visual nativa no GitHub sob identidade oficial de máquina (ex.: `heviane-agent[bot]`).
7. **Portfólio Internacional & Repositórios Estratégicos 100% em Inglês:**  
   Avaliar e estruturar a internacionalização completa (código, documentação interna, especificações e READMEs 100% em inglês) de repositórios públicos estratégicos com potencial de atração global (ex.: `project-starter-kit`, utilitários CLI e labs técnicos de IA), posicionando o ecossistema para contratações remotas internacionais e tração na comunidade global de código aberto.

### 📦 Propostas Técnicas Pós-MVP do Starter Kit (`project-starter-kit`)

Propostas técnicas para avaliação após teste de uso real do kit de aceleração:

1. **Catálogo de Guias e Configurações por Stack:**  
   Avaliar a externalização de configurações de stacks em arquivos JSON (`config/stacks/`) e guias detalhados de arquitetura para Java, .NET, Python e Node.
2. **Mecanismo de Atualização:**  
   Estudar estratégia para permitir que projetos derivados recebam melhorias futuras de templates e regras de IA sem sobrescrever decisões locais.
