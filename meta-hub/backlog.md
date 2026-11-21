# Backlog Mestre de Governança e Portfólio

> **Docs-as-Code — AI Engineering Hub**  
> Repositório Central: [`heviane/heviane/meta-hub`](https://github.com/heviane/heviane/tree/main/meta-hub)  
> Quadro Executivo: [AI Engineering Hub — Portfolio & Roadmap (Project 14)](https://github.com/users/heviane/projects/14)  
> Última Atualização: 20/11/2026

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
| 🟢 | `ENV-02` | `P1` | **Inventário Documentado & Backup** | Gerar documento [`vscode-extensions.md`](./vscode-extensions.md) com as 75 extensões ativas, propósitos individuais e script PowerShell de restauração. |
| 🟢 | `ENV-03` | `P2` | **Workspace Multi-Root (`.code-workspace`)** | Criar arquivo `github.code-workspace` na raiz do workspace para unificar navegação dos repositórios sem conflito de Git. |

---

### Épico 2: Governança Ágil & Estrutura de Portfólio (Flight Levels) — 🟢 100% Concluído

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| 🟢 | `GOV-01` | `P0` | **Definição de Arquitetura de Governança** | Definir `heviane/heviane/meta-hub` como diretório oficial para Docs-as-Code e artefatos centrais. |
| 🟢 | `GOV-02` | `P1` | **Criação do Meta-Hub README** | Criar [`README.md`](./README.md) executivo com diagramas de Flight Levels e governança. |
| 🟢 | `GOV-03` | `P0` | **Criação de Docs no Meta-Hub** | Centralizar `backlog.md` e `vscode-extensions.md` exclusivamente no repositório de governança. |
| 🟢 | `GOV-04` | `P1` | **Integração com Project 14** | Conectar e cadastrar as tarefas priorizadas no [AI Engineering Hub (Project 14)](https://github.com/users/heviane/projects/14). |
| 🟢 | `GOV-05` | `P2` | **ADR-001: Adoção de SDD e IA no SDLC** | Criar registro formal de decisão arquitetural (ADR) sobre a metodologia de IA e governança Docs-as-Code ([`ADR-001`](./adrs/001-adocao-sdd-ia-sdlc.md)). |
| 🟢 | `GOV-06` | `P1` | **AGENTS.md Global do Workspace** | Criar diretrizes operacionais de IA na raiz do workspace para governança multi-repositório. |

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

---

### Épico 4: Organizações e Repositórios no GitHub — ⚪ Em Andamento

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| ⚪ | `ORG-01` | `P1` | **Padronização da Organização `@heviane-labs`** | Configurar bio, avatar, README de organização e vincular projetos ao Project 14. |
| ⚪ | `ORG-02` | `P1` | **Padronização da Organização `@heviane-learning`** | Alinhar laboratórios de cursos (DIO, Alura) com tags claras de trilhas de aprendizado. |
| ⚪ | `ORG-03` | `P2` | **README Playbook / Templates de README** | Criar repositório público `readme-playbook` com templates estruturados por perfil (API, SaaS, CLI, Open-Source). |

---

### Épico 5: Consolidação do Workspace Mestre & Governança em Nuvem (Google Drive) — 🟢 100% Concluído

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| 🟢 | `WS-01` | `P0` | **Segregação de Governança Local em Nuvem** | Migrar `E:\Projects\GitHub\docs` para `H:\My Drive\Workspace Root Local`, garantindo backup em tempo real e proteção contra perda de dados locais. |
| 🟢 | `WS-02` | `P1` | **Unificação do Multi-Root Workspace (`github.code-workspace`)** | Consolidar a navegação em um único arquivo de workspace mestre, eliminando redundâncias (`github-all` e `github-local`) e duplicidades no Explorer. |
| 🟢 | `WS-03` | `P1` | **Promoção do `meta-hub` a Raiz de Primeiro Nível** | Integrar `heviane/heviane/meta-hub` diretamente no topo do workspace para acesso instantâneo a backlogs, ADRs e scripts de auditoria. |
| 🟢 | `WS-04` | `P1` | **Pipeline de CI/CD para Governança Docs-as-Code** | GitHub Actions com `markdownlint-cli2`, Lychee link checker e validação de sintaxe de scripts PowerShell. |

---

### Épico 6: Soluções Core em Produção & Portfólio Ativo — 🟢 100% Concluído

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| 🟢 | `SOL-01` | `P0` | **Middleware NFS-e Nacional API (`nfse-nacional-api`)** | Desenvolvimento completo de middleware em Java 17 com core fiscal (validação XSD v1.00, RSA-SHA256, mTLS) e Camada Anticorrupção (ACL SOAP GeneXus 18). |
| 🟢 | `SOL-02` | `P1` | **Template Institucional Web (`institutional-website-template`)** | Criação de template corporativo moderno, reutilizável para clientes e alinhado a práticas de desenvolvimento assistido por IA. |

---

### Épico 7: Workspace de Carreira, Empregabilidade & Marca Pessoal — 🟡 Em Planejamento

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| 🟡 | `CAR-01` | `P0` | **Especificação do Workspace Profissional** | Planejar arquitetura de workspace dedicado à carreira, portfólio, blog técnico e autoridade no mercado. |
| ⚪ | `CAR-02` | `P1` | **Repositório Privado de Bastidores no Google Drive** | Estruturar pasta segura em `I:\My Drive\Heviane\...` para rascunhos, estudos, estratégias comerciais e dados sensíveis. |
| ⚪ | `CAR-03` | `P1` | **Ativos Públicos de Autoridade Técnica** | Criar os repositórios públicos `blog`, `portfolio` e `news-letter` a partir de templates de produtos. |

---

## 💡 Banco de Ideias & Sugestões de Melhorias

Propostas técnicas e oportunidades mapeadas para avaliação nas próximas iterações:

1. **`ai-dev-journey` (Repositório / Série de Artigos Técnicos):**  
   Repositório e série de publicações documentando a jornada de transição de *Desenvolvedor Tradicional (10+ anos)* para *AI-Assisted Software Engineer*. Conteúdo de alta autoridade técnica para LinkedIn e portfólio.
2. **Catálogo Unificado de Repositórios (`meta-hub/repository-catalog.md`):**  
   Mapear e categorizar os 51 repositórios do ecossistema por Categoria (Core / Labs / Learning), Linguagens, Status e Nível de Governança (SDD, CI/CD, AGENTS).
3. **Automação do Inventário de Extensões (`sync-extensions.ps1`):**  
   Criar script para atualizar automaticamente o documento `vscode-extensions.md` via `code --list-extensions --show-versions`, eliminando divergências de contagem manual.
4. **Formalização da Arquitetura AI-SEP (*AI-Assisted Software Engineering Platform*):**  
   Documentar no Meta-Hub a plataforma proprietária integrando Meta-Hub (Governança), Starter Kit (Templates), SDD e Contratos de IA.
5. **Automação Docs-as-Code com GitHub CLI (`gh`):**  
   Criar workflow ou script para refletir automaticamente itens marcados no backlog no GitHub Project 14.
6. **Extração de `CHANGELOG.md` no Meta-Hub:**  
   Migrar épicos antigos totalmente concluídos (1 a 3) para um histórico formal de mudanças, mantendo o `backlog.md` enxuto.
7. **Diferenciação de Stacks Consolidadas vs. Tecnologias em Estudo no `README.md`:**  
   Segmentar a seção de tecnologias e ferramentas no perfil principal entre *Competências Consolidadas em Produção* (GeneXus, JS/TS, React, Node.js, C#, SQL Server, MySQL, PostgreSQL) e *Em Especialização / Aprofundamento* (Next.js, Arquitetura Assistida por IA, DDD, TDD), aumentando a credibilidade técnica e precisão curricular.
8. **Enriquecimento Estratégico da Bio e Headline Profissional:**  
   Refinar a apresentação do perfil com uma headline de alto impacto (*Software Developer | Backend & Web Architecture | AI-Assisted Engineering*), proposta de valor explícita e objetivos profissionais claros, destacando a senioridade e a metodologia de engenharia assistida por IA.
