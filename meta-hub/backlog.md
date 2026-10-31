# Backlog Mestre de Governança e Portfólio

> **Docs-as-Code — AI Engineering Hub**  
> Repositório Central: [`heviane/heviane/meta-hub`](file:///E:/Projects/GitHub/heviane/heviane/meta-hub)  
> Quadro Executivo: [AI Engineering Hub — Portfolio & Roadmap (Project 14)](https://github.com/users/heviane/projects/14)  
> Última Atualização: 31/10/2026

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

### Épico 1: Padronização do Ambiente de Desenvolvimento (VS Code)

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| 🟢 | `ENV-01` | `P0` | **Auditoria de Extensões** | Mapear e revisar as 88 extensões do VS Code. |
| 🟢 | `ENV-02` | `P1` | **Inventário Documentado** | Gerar documento [`vscode-extensions.md`](./vscode-extensions.md) com tabela das extensões, descrições individuais e script PowerShell de backup. |
| ⚪ | `ENV-04` | `P2` | **Workspace Multi-Root (`.code-workspace`)** | Criar arquivo `github.code-workspace` na raiz `E:\Projects\GitHub` para unificar navegação sem conflito de repositórios Git aninhados. |

---

### Épico 2: Governança Ágil & Estrutura de Portfólio (Flight Levels)

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| 🟢 | `GOV-01` | `P0` | **Definição de Arquitetura de Governança** | Definir `heviane/heviane/meta-hub` como diretório oficial para Docs-as-Code e artefatos centrais. |
| 🟢 | `GOV-02` | `P1` | **Criação do Meta-Hub README** | Criar [README.md](file:///E:/Projects/GitHub/heviane/heviane/meta-hub/README.md) executivo com diagramas de Flight Levels e governança. |
| 🟡 | `GOV-03` | `P0` | **Migração de Docs para o Meta-Hub** | Sincronizar `backlog.md` e `vscode-extensions.md` dentro de `heviane/heviane/meta-hub/`. |
| ⚪ | `GOV-04` | `P1` | **Integração com Project 14** | Conectar e cadastrar as tarefas priorizadas no [AI Engineering Hub (Project 14)](https://github.com/users/heviane/projects/14). |
| ⚪ | `GOV-05` | `P2` | **ADR-001: Adoção de SDD e IA no SDLC** | Criar registro formal de decisão arquitetural (ADR) sobre a metodologia de IA e governança Docs-as-Code. |

---

### Épico 3: Starter Kit & Padrões para Desenvolvimento Assistido por IA

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| 🟡 | `IA-01` | `P0` | **Modernização do `project-starter-kit`** | Atualizar repositório `heviane/project-starter-kit` transformando-o em base para IA e SDD. |
| ⚪ | `IA-02` | `P0` | **Template `AGENTS.md`** | Criar diretrizes operacionais para IAs (regras de stack, restrições, convenções de código e commits). |
| ⚪ | `IA-03` | `P1` | **Template `SPEC.md` (SDD)** | Criar modelo de especificação funcional e técnica para desenvolvimento guiado por requisitos. |
| ⚪ | `IA-04` | `P1` | **Template `ADR.md`** | Criar modelo padrão de Architecture Decision Record para decisões de design nos projetos. |
| ⚪ | `IA-05` | `P2` | **Instruções Copilot (`.github/copilot-instructions.md`)** | Configurar instruções automáticas nativas para VS Code e GitHub Copilot. |
| ⚪ | `IA-06` | `P2` | **Configurar GitHub Template Repository** | Habilitar a flag "Template repository" no GitHub para permitir *"Use this template"* com 1 clique. |

---

### Épico 4: Organizações e Repositórios no GitHub

| Status | ID | Prioridade | Item | Descrição / Critérios de Aceite |
| :---: | :---: | :---: | :--- | :--- |
| ⚪ | `ORG-01` | `P1` | **Padronização da Organização `@heviane-labs`** | Configurar bio, avatar, README de organização e vincular projetos ao Project 14. |
| ⚪ | `ORG-02` | `P1` | **Padronização da Organização `@heviane-learning`** | Alinhar laboratórios de cursos (DIO, Alura) com tags claras de trilhas de aprendizado. |
| ⚪ | `ORG-03` | `P2` | **README Playbook / Templates de README** | Criar repositório público `readme-playbook` com templates estruturados por perfil (API, SaaS, CLI, Open-Source). |

---

## 💡 Banco de Ideias & Sugestões de Melhorias

Propostas técnicas para avaliação nas próximas iterações:

1. **`ai-dev-journey` (Repositório / Série de Artigos):**  
   Repositório documentando a jornada de transição de *Desenvolvedor Tradicional (10+ anos)* para *AI-Assisted Software Engineer*. Altamente recomendado como conteúdo de autoridade técnica para o LinkedIn e portfólio.
2. **Automação GitHub Actions com GitHub CLI (`gh`):**  
   Criar um workflow simples que lê seções deste `backlog.md` e gera/atualiza Issues automaticamente no repositório de destino e no Project 14.
3. **Biblioteca de Prompts Reutilizáveis (`prompts/` no Starter Kit):**  
   Conjunto de prompts estruturados para:
   * Geração de testes unitários a partir de uma `SPEC.md`.
   * Code Review estrito de segurança e performance.
   * Criação de documentação Swagger/OpenAPI.
