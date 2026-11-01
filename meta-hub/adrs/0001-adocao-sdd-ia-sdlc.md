# ADR-001: Adoção de Spec-Driven Development (SDD) e Governança de IA no SDLC

> **Status:** `Aprovado`  
> **Data:** 2026-10-31  
> **Decisores:** Heviane Bastos  
> **Contexto Técnico:** Adoção de Agentes de IA, Spec-Driven Development (SDD) e Governança Docs-as-Code no Ciclo de Vida de Desenvolvimento (SDLC) em Ecossistema Multi-Repositório.

---

## 1. 📌 Contexto e Forças do Problema

O avanço de ferramentas de Inteligência Artificial Generativa e agentes de pair programming (Google Antigravity, GitHub Copilot, Claude Code) transformou a dinâmica de engenharia de software, aumentando drasticamente a velocidade de prototipação e escrita de código.

No entanto, em um ecossistema multi-repositório distribuído em três organizações (`@heviane`, `@heviane-labs` e `@heviane-learning`), a utilização não estruturada de assistentes de IA introduz desafios críticos:
* **Entropia e Falta de Padronização:** Modelos de IA tendem a gerar arquiteturas concorrentes ou padrões incompatíveis quando não recebem contexto arquitetural unificado.
* **Mutações Destrutivas ou Não Autorizadas:** Agentes autônomos podem apagar dados, alterar dependências ou aplicar refatorações sem consentimento humano prévio.
* **Código Órfão / Sem Rastreabilidade:** A geração direta de código sem especificação prévia impede a validação de regras de negócio e dificulta a manutenção futura.
* **Degradação de Documentação:** Sistemas desenvolvidos sem rastreamento de decisões acumulam débito técnico invisível.

### Forças Determinantes:
* **Força 1 (Escala do Ecossistema):** Dezenas de repositórios independentes precisam compartilhar regras de governança e interoperabilidade sem silos.
* **Força 2 (Human-in-the-Loop Obrigatório):** A desenvolvedora deve manter o controle estratégico e a palavra final sobre qualquer alteração no ambiente ou no código.
* **Força 3 (Docs-as-Code):** Decisões e especificações devem viver no repositório Git, integradas às ferramentas de desenvolvimento, e não em sistemas proprietários desconectados.

---

## 2. 🎯 Decisão Tomada

Decidimos adotar formalmente a metodologia de **Spec-Driven Development (SDD)** combinada com **Governança de IA Human-in-the-Loop** e **Docs-as-Code** como padrão arquitetural e operacional para todo o ciclo de vida de desenvolvimento (SDLC) do ecossistema.

### Pilares da Implementação:

1. **Metadiretório de Governança (`meta-hub`):**
   * Centralização de toda a estratégia em `heviane/heviane/meta-hub/`, incluindo o backlog unificado ([`backlog.md`](../backlog.md)), inventários técnicos ([`vscode-extensions.md`](../vscode-extensions.md)) e registros de decisão arquitetural (`adrs/`).
2. **Contratos Operacionais de IA (`AGENTS.md`):**
   * Definição de diretrizes operacionais obrigatórias para agentes na raiz do workspace (`E:\Projects\GitHub\AGENTS.md`) e em cada repositório individual.
   * **Regra Fundamental 0 (Human-in-the-Loop):** O agente **DEVE SEMPRE** apresentar o plano de ação e obter a aprovação explícita da desenvolvedora antes de criar, editar, excluir arquivos ou executar commits.
3. **Spec-Driven Development (SDD):**
   * Todo desenvolvimento de escopo relevante deve ser precedido por um documento de especificação (`docs/templates/SPEC.md`), detalhando requisitos funcionais, não-funcionais, regras de negócio e critérios de aceite antes da codificação.
4. **Padrão Base de Repositórios (`project-starter-kit`):**
   * Centralização de templates (`SPEC.md`, `ADR.md`, `AGENTS.md`, workflows e configs de VS Code) no repositório [`heviane/project-starter-kit`](https://github.com/heviane/project-starter-kit) para replicação com 1 clique.
5. **Rastreabilidade e Versionamento Semântico:**
   * Adoção estrita de **Conventional Commits** (`feat:`, `fix:`, `docs:`, `refactor:`, etc.) e rastreamento de tarefas no [GitHub Project #14 (AI Engineering Hub)](https://github.com/users/heviane/projects/14).

---

## 3. ⚖️ Consequências

### Consequências Positivas (Ganhos):
* **Previsibilidade e Qualidade:** Código gerado por IA alinhado a especificações claras e validado por humanos.
* **Eliminação de Ações Silenciosas:** Zero risco de deleções inadvertidas ou alterações no ambiente sem consentimento prévio.
* **Onboarding Instantâneo de Agentes:** Qualquer assistente de IA ganha consciência imediata do contexto do projeto ao ler `AGENTS.md` e a especificação.
* **Rastreabilidade Histórica:** O porquê e o como de cada decisão ficam permanentemente documentados no Git.

### Consequências Negativas (Custos / Desafios):
* **Atrito Inicial de Especificação:** Exige a disciplina de redigir o `SPEC.md` antes de iniciar a implementação do código.
* **Manutenção Contínua:** Demanda atualização rigorosa dos documentos de governança à medida que decisões e requisitos evoluem.

### Riscos Mitigados:
* **Alucinação Operacional de IA:** Mitigado pelo contrato `AGENTS.md` e aprovação humana obrigatória.
* **Débito Técnico Oculto:** Mitigado pela exigência de critérios de aceite e especificações técnicas prévias.

---

## 4. 🔍 Alternativas Consideradas

| Alternativa | Prós | Contras | Motivo da Rejeição |
| :--- | :--- | :--- | :--- |
| **Prompting Ad-hoc (Sem SDD)** | Velocidade imediata no início; zero atrito de documentação. | Código desorganizado, alucinações frequentes, retrabalho alto e ausência de rastreabilidade. | Não escala para múltiplos repositórios e compromete a qualidade arquitetural. |
| **Governança Ágil Tradicional (Jira / Confluence externo)** | Ferramental maduro corporativo. | Desconectado do repositório Git; excesso de burocracia e custos de manutenção. | Viola o princípio de Docs-as-Code e dificulta o consumo de contexto por agentes de IA locais. |
| **SDD + Human-in-the-Loop + Docs-as-Code (Escolhida)** | Alta velocidade da IA com controle humano absoluto, rastreabilidade no Git e baixo atrito. | Exige disciplina documental antes do início da implementação de código. | **Opção selecionada** por equilibrar velocidade, segurança e robustez técnica. |

