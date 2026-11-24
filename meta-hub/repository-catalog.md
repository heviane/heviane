# 📚 Catálogo Unificado de Repositórios Públicos

> **Inventário Oficial de Repositórios Públicos do Ecossistema (Docs-as-Code)**  
> **Data de Atualização:** 22/11/2026 | **Total de Repositórios Públicos:** 24 *(mais 2 repositórios administrativos de perfil `.github`)*  
> **Central de Governança:** [Meta-Hub (`meta-hub`)](./README.md) | **Segregação:** [ADR-0002](./adrs/0002-sensitive-data-segregation-multi-root-workspaces.md)  
> *Nota: Este catálogo documenta exclusivamente os repositórios públicos e de código aberto mantidos no GitHub. Repositórios privados corporativos e laboratoriais seguem diretrizes de segregação física e são auditados internamente.*

---

## 📑 Sumário

- [Visão Geral & Matriz de Maturidade](#-visão-geral--matriz-de-maturidade)
- [🏛️ Repositórios Core (`@heviane`)](#️-repositórios-core-heviane)
- [🧪 Labs & Engenharia (`@heviane-labs`)](#-labs--engenharia-heviane-labs)
- [🎓 Estudos & Aprendizado (`@heviane-learning`)](#-estudos--aprendizado-heviane-learning)
- [📈 Plano de Evolução de Governança](#-plano-de-evolução-de-governança)

---

## 📊 Visão Geral & Matriz de Maturidade

Os repositórios públicos estão distribuídos entre as três organizações oficiais do GitHub:

| Organização | Escopo & Proposta de Valor | Repositórios Públicos |
| :--- | :--- | :---: |
| **[`@heviane`](https://github.com/heviane)** | **Soluções Core:** Produtos corporativos, integrações fiscais, templates reutilizáveis e governança. | 5 |
| **[`@heviane-labs`](https://github.com/heviane-labs)** | **Laboratórios Técnicos:** Engenharia reversa, protótipos de IA, testes arquiteturais e PoCs. | 9 |
| **[`@heviane-learning`](https://github.com/heviane-learning)** | **Estudos & Certificações:** Bootcamps, trilhas acadêmicas (DIO, Alura), tutoriais e desafios práticos. | 10 |
| **Total Público** | **Portfólio de Código Aberto & Vitrine Técnica** | **24** |

> 💡 **Auditoria de Integridade (GitHub CLI):** 100% dos 24 repositórios públicos estão **ativos** (`isArchived: false`). Não existem repositórios arquivados ou obsoletos não documentados.

### Critérios Objetivos de Maturidade (Rubrica de Governança)

| Requisito de Governança | ⚪ Nível 1 (Base) | 🟡 Nível 2 (Intermediário) | 🟢 Nível 3 (Alta Maturidade) |
| :--- | :---: | :---: | :---: |
| **README estruturado & Licença Aberta (MIT)** | Sim ✅ | Sim ✅ | Sim ✅ |
| **Controle de versão & `.gitignore` padronizado** | Sim ✅ | Sim ✅ | Sim ✅ |
| **Esteira de CI/CD (GitHub Actions)** | Opcional | Sim ✅ | Sim ✅ |
| **Testes Automatizados (Pester / Unitários)** | Opcional | Sim ✅ | Sim ✅ |
| **Contrato de IA (`AGENTS.md`)** | Opcional | Opcional | Sim ✅ |
| **Docs-as-Code & Arquitetura (`docs/specs/`, `ADRs`)** | Opcional | Opcional | Sim ✅ |

> 💡 **Contratos de IA:** O inventário descritivo e a matriz de paridade das diretrizes de inteligência artificial de cada repositório são mantidos centralizadamente em [`agents-catalog.md`](./agents-catalog.md).

---

## 🏛️ Repositórios Core (`@heviane`)

Soluções de produção, produtos corporativos, templates oficiais e central de governança:

| Repositório | Escopo & Descrição Arquitetural | Diferenciais & Métricas de Engenharia | Stack Tecnológica | Status & Licença | Governança |
| :--- | :--- | :--- | :--- | :---: | :---: |
| **[`nfse-nacional-api`](https://github.com/heviane/nfse-nacional-api)** | Middleware corporativo para emissão e consulta da NFS-e Nacional. Ponte intermediária desacoplada para ERPs legados. | • Conformidade 100% com Schemas XSD v1.00 SEFIN<br/>• Criptografia XML RSA-SHA256 & mTLS nativo (RFC 5246)<br/>• ACL SOAP para emissão via GeneXus 18 sem certificados locais | `Java 17` `Spring Boot` `mTLS` `RSA-SHA256` `GeneXus` | `Produção`<br/>`MIT` | `🟢 Nível 3` |
| **[`institutional-website-template`](https://github.com/heviane/institutional-website-template)** | Boilerplate corporativo moderno para acelerar entregas web institucionais de alta conversão para clientes. | • Metas de Web Vitals (LCP < 2.5s, CLS < 0.1)<br/>• Setup de novo cliente planejado em < 2 horas<br/>• Conformidade WCAG 2.1 AA & LGPD by design | `Next.js 16` `React 19` `TypeScript` `Tailwind v4` | `Ativo`<br/>`MIT` | `🟢 Nível 3` |
| **[`project-starter-kit`](https://github.com/heviane/project-starter-kit)** | Template base oficial do ecossistema para bootstrap de novos repositórios com governança SDD e contratos de IA. | • Setup de governança SDD completa em < 5 min<br/>• Pipeline CI com 4 quality gates automatizados<br/>• Contratos de agentes padronizados (`AGENTS.md`) | `Shell` `GitHub Actions` `Docs-as-Code` | `Ativo`<br/>`MIT` | `🟢 Nível 3` |
| **[`heviane`](https://github.com/heviane/heviane)** | Repositório central do perfil e sede do Meta-Hub: Central de Governança, Backlog Mestre, ADRs e automações. | • 15 testes funcionais Pester em sandbox no CI<br/>• Auditoria semanal recorrente de links e segredos<br/>• Inventário de 24 repositórios em 3 organizações | `PowerShell` `GitHub Actions` `Docs-as-Code` | `Ativo`<br/>`MIT` | `🟢 Nível 3` |
| **[`keynotes`](https://github.com/heviane/keynotes)** | Apresentações executivas, palestras técnicas e materiais de arquitetura de software formatados em slides web interativos. | • Apresentações em formato web leve e responsivo<br/>• Zero dependência de softwares proprietários | `HTML5` `CSS3` `JavaScript` | `Ativo`<br/>`MIT` | `⚪ Nível 1` |

---

## 🧪 Labs & Engenharia (`@heviane-labs`)

Provas de conceito públicas, laboratórios de experimentação de linguagens e testes de automação:

| Repositório | Escopo & Descrição Técnica | Stack Tecnológica | Status | Governança |
| :--- | :--- | :--- | :---: | :---: |
| **[`shell-script-lab`](https://github.com/heviane-labs/shell-script-lab)** | Laboratório de automação CLI e scripts em Shell/Bash com pipeline de testes de sintaxe e especificações técnicas de infraestrutura. | `Bash` `Shell Script` `Linux` | `Ativo` | `🟢 Nível 3` |
| **[`dotnet-lab`](https://github.com/heviane-labs/dotnet-lab)** | Laboratório de experimentação com C#, Entity Framework Core, LINQ avançado e padrões de design arquiteturais em .NET. | `.NET 8/9` `C#` `EF Core` | `Ativo` | `🟡 Nível 2` |
| **[`python-lab`](https://github.com/heviane-labs/python-lab)** | Laboratório de scripts de processamento de dados, automações de tarefas operacionais e utilitários em Python 3. | `Python` | `Ativo` | `⚪ Nível 1` |
| **[`javascript-lab`](https://github.com/heviane-labs/javascript-lab)** | Experimentos com JavaScript moderno (ES6+), programação assíncrona (Promises, async/await) e integração com Node.js. | `JavaScript` `Node.js` | `Ativo` | `⚪ Nível 1` |
| **[`typescript-lab`](https://github.com/heviane-labs/typescript-lab)** | Laboratório de tipagem estática avançada em TypeScript: generics, type guards, utility types e decorators. | `TypeScript` `Node.js` | `Ativo` | `⚪ Nível 1` |
| **[`devops-lab`](https://github.com/heviane-labs/devops-lab)** | Laboratório de contêineres Docker, Docker Compose, pipelines de automação e orquestração de serviços locais. | `Docker` `YAML` `DevOps` | `Ativo` | `⚪ Nível 1` |
| **[`git-and-github-lab`](https://github.com/heviane-labs/git-and-github-lab)** | Simulações práticas de fluxos Git corporativos: branching strategies (GitFlow, Trunk-Based), merge conflicts e rebase. | `Git` `Bash` | `Ativo` | `⚪ Nível 1` |
| **[`database-lab`](https://github.com/heviane-labs/database-lab)** | Laboratório de modelagem relacional, otimização de consultas SQL, criação de índices e transações ACID. | `SQL` `PostgreSQL` `MySQL` | `Ativo` | `⚪ Nível 1` |
| **[`backscan`](https://github.com/heviane-labs/backscan)** | Guia e scripts para configuração e execução da ferramenta de segurança e auditoria BackScan em ambiente Linux. | `Linux` `Shell` `Segurança` | `Referência` | `⚪ Nível 1` |

---

## 🎓 Estudos & Aprendizado (`@heviane-learning`)

Repositórios públicos de bootcamps, trilhas acadêmicas, certificações e desafios práticos de código:

| Repositório | Escopo & Descrição do Curso / Trilha | Stack Tecnológica | Status | Governança |
| :--- | :--- | :--- | :---: | :---: |
| **[`natty-or-not-lab`](https://github.com/heviane-learning/natty-or-not-lab)** | Projeto prático de engenharia assistida por IA: curadoria de conteúdo sintético, detecção de padrões e SDD estruturado. | `IA Generativa` `Docs-as-Code` | `Concluído` | `🟢 Nível 3` |
| **[`trilha-net-fundamentos-desafio`](https://github.com/heviane-learning/trilha-net-fundamentos-desafio)** | Solução do desafio prático de fundamentos da Trilha .NET da DIO (sistema de estacionamento orientado a objetos). | `.NET` `C#` `POO` | `Concluído` | `🟡 Nível 2` |
| **[`alura-imersao-devops`](https://github.com/heviane-learning/alura-imersao-devops)** | Projeto desenvolvido na Imersão DevOps da Alura: automação de deploy e provisionamento de infraestrutura no Google Cloud (GCP). | `Python` `Google Cloud` `DevOps` | `Concluído` | `🟡 Nível 2` |
| **[`lab-open-source`](https://github.com/heviane-learning/lab-open-source)** | Projeto prático de contribuição colaborativa em código aberto da Digital Innovation One (DIO). | `Git` `GitHub` `Open Source` | `Concluído` | `⚪ Nível 1` |
| **[`api-url-shortener`](https://github.com/heviane-learning/api-url-shortener)** | Microsserviço de encurtamento e redirecionamento de URLs com geração de hashes únicos e contagem de acessos. | `Node.js` `TypeScript` `Express` | `Concluído` | `⚪ Nível 1` |
| **[`clone-chatGPT`](https://github.com/heviane-learning/clone-chatGPT)** | Interface conversacional web integrando a API da OpenAI com renderização em streaming de respostas e histórico de chat. | `React` `TypeScript` `OpenAI API` | `Concluído` | `⚪ Nível 1` |
| **[`dio-github-copilot`](https://github.com/heviane-learning/dio-github-copilot)** | Exercícios e testes práticos de codificação assistida por IA utilizando o GitHub Copilot na Trilha DIO. | `TypeScript` `GitHub Copilot` | `Concluído` | `⚪ Nível 1` |
| **[`dio-desafio-github`](https://github.com/heviane-learning/dio-desafio-github)** | Projeto prático do módulo de controle de versão da DIO abordando branches, pull requests e Markdown. | `Git` `Markdown` | `Concluído` | `⚪ Nível 1` |
| **[`dio-prompts-for-article-generate-by-ia`](https://github.com/heviane-learning/dio-prompts-for-article-generate-by-ia)** | Coleção de prompts estruturados para ideação, roteirização e redação de artigos técnicos com auxílio de LLMs. | `Prompt Engineering` `Markdown` | `Concluído` | `⚪ Nível 1` |
| **[`ui-profile-github`](https://github.com/heviane-learning/ui-profile-github)** | Aplicação front-end para consulta dinâmica e exibição enriquecida de perfis e repositórios da API pública do GitHub. | `React` `JavaScript` `GitHub API` | `Concluído` | `⚪ Nível 1` |

---

## 📈 Plano de Evolução de Governança

1. **Promoção Progressiva de Maturidade:**
   - Repositórios de Labs ou Learning com relevância de portfólio são elevados para **Nível 2** (CI/CD ativo) ou **Nível 3** (adoção do template oficial `project-starter-kit` e SDD).
2. **Auditoria e Conciliação Automatizada:**
   - Auditoria contínua da árvore local via script [`audit-workspace.ps1`](./scripts/audit-workspace.ps1) com a flag `-StrictGovernance`.
   - Conciliação periódica com a API do GitHub via GitHub CLI (`gh`):

     ```powershell
     # Comando oficial de auditoria de paridade do catálogo (API GitHub)
     @('heviane', 'heviane-labs', 'heviane-learning') | ForEach-Object {
         gh repo list $_ --visibility=public --json name,isArchived
     }
     ```

3. **Sincronização Contínua de Ferramental:**
   - Manutenção do inventário de extensões via [`sync-extensions.ps1`](./scripts/sync-extensions.ps1).
