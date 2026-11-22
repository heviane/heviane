# ADR-002: Segregação Física de Dados Sensíveis e Governança Local em Nuvem via Multi-Root Workspaces

> **Status:** `Aprovado`  
> **Data:** 2026-11-20  
> **Decisores:** Heviane Bastos  
> **Contexto Técnico:** Isolamento físico de certificados digitais ICP-Brasil A1, senhas, dados de clientes, credenciais de infraestrutura e diretrizes locais fora da árvore de repositórios Git, integrando unidades em nuvem (Google Drive) com Multi-Root Workspaces do VS Code.

---

## 1. 📌 Contexto e Forças do Problema

O ecossistema `@heviane` atua no desenvolvimento de soluções de software de alto impacto fiscal e corporativo (como o `nfse-nacional-api`), ao mesmo tempo em que mantém repositórios públicos no GitHub orientados a portfólio, código aberto e autoridade técnica.

Essa convivência expõe desafios críticos de segurança da informação, privacidade (LGPD) e integridade operacional:

* **Manipulação de Segredos Fiscais e Credenciais:** Aplicações de integração fiscal demandam o uso de Certificados Digitais ICP-Brasil A1 (`.pfx` / `.p12`), senhas em texto puro, acessos a servidores de nuvem (servidores de aplicação e bancos de dados em nuvem), credenciais SSH/SFTP e amostras de payloads com dados reais de empresas e tomadores.
* **Fragilidade do `.gitignore` como Única Linha de Defesa:** Em projetos com repositórios públicos, confiar exclusivamente no arquivo `.gitignore` para barrar segredos locais cria um risco residual inaceitável de erro humano (ex: `git add -f`, comutação para branches sem regras atualizadas ou scripts desatentos). Um único commit acidental de um certificado A1 vaza a identidade jurídica do cliente permanentemente.
* **Vulnerabilidade de Documentos Locais sem Nuvem:** Diretrizes locais, prompts de assistentes de IA, personas e históricos de análise armazenados exclusivamente no disco físico da máquina (ex: `<workspace-root>/docs`) corriam risco de perda total e irreversível em caso de pane no hardware local.
* **Ergonomia e Produtividade:** A desenvolvedora precisa de acesso rápido aos certificados e amostras para testes locais no terminal, sem precisar alternar entre múltiplos navegadores ou pastas desconectadas.

---

## 2. 🎯 Decisão Tomada

Decidimos adotar a **Segregação Física Total de Segredos e Governança Local**, transferindo dados sensíveis e bastidores para unidades dedicadas em nuvem (**Google Drive**), integradas transparentemente ao ambiente de desenvolvimento através de **Multi-Root Workspaces do VS Code** (`.code-workspace`).

### Pilares da Arquitetura:

1. **Segregação Física por Design (Redução Substancial de Riscos de Exposição):**
   * Nenhum certificado digital (`*.pfx`), credencial real de cliente ou anotação confidencial reside dentro da árvore de trabalho de qualquer repositório Git sob `<workspace-root>/GitHub`.
   * Para o motor do Git, esses arquivos **fisicamente não existem na árvore de versionamento**, mitigando por design o risco de vazamento acidental via `git add` ou `git push`.
2. **Topologia de Unidades Sincronizadas em Nuvem (Cloud Storage):**
   * **`<secure-vault>/clients/`:** Cofre corporativo contendo pastas dedicadas por cliente (`Cliente-Alfa`, `Cliente-Beta`, `Cliente-Gama`) com certificados, credenciais de acesso, contratos e históricos de deploy.
   * **`<governance-cloud>/workspace-local/`:** Central de governança da máquina de trabalho, abrigando prompts de IA, personas, notas de análise e diretrizes locais com backup e versionamento em nuvem contínuos.
   * **`<personal-vault>/career/`:** Espaço privado dedicado ao planejamento de carreira, estudos e dados pessoais.
   * *Nota de Portabilidade: As designações acima (`<workspace-root>`, `<secure-vault>`, etc.) representam papéis arquiteturais mapeados em unidades locais (ex: Windows drive letters ou montagens Unix).*
3. **Integração via Multi-Root Workspaces do VS Code:**
   * Utilização de arquivos `.code-workspace` na raiz do ambiente (como `github.code-workspace` e `nfse-nacional.code-workspace`), agrupando lado a lado as pastas de repositórios Git com as pastas do Google Drive no mesmo painel lateral do editor.
   * Configuração de filtros de busca (`search.exclude`) para excluir binários pesados (`*.pfx`, `*.zip`, `*.war`, `*.pdf`) da indexação global, preservando a performance do VS Code.

---

## 3. ⚖️ Consequências

### Consequências Positivas (Ganhos):

* **Proteção Robusta Contra Vazamentos no GitHub:** Mesmo operando com repositórios públicos, os dados confidenciais estão fisicamente segregados em outro disco (`H:` / `I:`), protegidos pela arquitetura.
* **Conformidade Estrita com LGPD e Sigilo Fiscal:** Certificados A1 de clientes ficam restritos a ambientes com controle de acesso corporativo e criptografia de nuvem.
* **Backup e Versionamento Automáticos em Nuvem:** Cada alteração em prompts, análises ou configurações locais é sincronizada em tempo real com o Google Drive, sobrevivendo a qualquer falha física da estação de trabalho.
* **Experiência Unificada de Desenvolvimento:** O editor exibe o código do projeto e a pasta de clientes no mesmo painel lateral, permitindo testes locais ágeis via variáveis de ambiente da sessão.

### Consequências Negativas (Custos / Trade-offs):

* **Dependência do Google Drive para Desktop:** A máquina de desenvolvimento requer o aplicativo do Google Drive ativo para montar as unidades virtuais (`H:` e `I:`).
* **Disciplina de Nomenclatura:** Exige manter o padrão de mapeamento nos arquivos de workspace compartilhados.

### Controles Adotados & Riscos Residuais:

* **Autenticação e Acesso no Google Drive:** O cofre em nuvem exige autenticação multifator (2FA) e perfil de acesso restrito à conta proprietária.
* **Segurança de Certificados Digitais:** Senhas de certificados A1 não devem ser salvas em texto puro na mesma pasta do arquivo binário `.pfx`.
* **Políticas de Compartilhamento:** Desativação de compartilhamento público ou por link das pastas de clientes no Google Drive para prevenir exposição externa.
* **Dependência do Cliente de Sincronização:** Caso o Google Drive Desktop esteja desconectado ou desautenticado, os caminhos virtuais ficam indisponíveis temporariamente até o restabelecimento do serviço.

### Riscos Mitigados:

* **Vazamento Acidental de Chaves Privadas (A1) no Git:** Mitigado por isolamento físico da árvore do repositório.
* **Perda Irreversível de Prompts e Histórico de Análises:** Mitigado pelo backup contínuo do Google Drive.

---

## 4. 🔍 Alternativas Consideradas

| Alternativa | Prós | Contras | Motivo da Rejeição |
| :--- | :--- | :--- | :--- |
| **Pasta Oculta no Repo com `.gitignore` (ex: `./.clients/`)** | Tudo na mesma pasta do projeto; fácil de referenciar. | Alto risco de falha humana (`git add -f`); sem backup em nuvem; polui o histórico local. | Rejeitada por violar a Regra de Ouro de segurança fiscal em repositórios públicos. |
| **Cofre em Serviço Externo (HashiCorp Vault / AWS Secrets)** | Padrão corporativo avançado. | Complexidade e custo desproporcionais para desenvolvimento autônomo; exige conexão contínua a APIs pagas. | Rejeitada por complexidade operacional excessiva para o estágio atual. |
| **Junções NTFS / Links Simbólicos (`mklink`)** | Mapeia pastas externas para dentro da árvore do repo. | Risco de recursão infinita no Git; o Git tenta indexar o conteúdo do link; falhas no sync do Drive. | Rejeitada por instabilidade técnica no Windows e risco de indexação indevida. |
| **Segregação Física + Multi-Root Workspace (Escolhida)** | Risco mitigado no Git por isolamento físico, backup em nuvem automático, sem custos extras e integrado nativamente ao VS Code. | Requer Google Drive montado no sistema operacional. | **Opção selecionada** por aliar alta segurança prática, baixo atrito e excelente ergonomia. |
