#!/bin/bash

# Update Node Package Manager
sudo npm install npm@latest -g
npm -v

# Update Node.js
sudo npm cache clean -f  ## Clear npm cache
sudo npm install -g n    ## Install module “n”
sudo n stable            ## Install the latest stable version (LTS)
sudo n latest            ## Install the latest current version
node -v                  ## After restarting the terminal, check the Node version

# Node Version Manager - https://github.com/nvm-sh/nvm
## Comandos mais usados
nvm ls ## Listar versões instaladas
nvm ls-remote ## Listar versões disponíveis para instalação
nvm install vX.X.X ## Instalar uma versão específica
nvm install node ## Instalar a versão mais recente
nvm uninstall vX.X.X ## Desinstalar uma versão
nvm use vX.X.X ## Usar uma versão
nvm use node ## Usar a versão mais recente
nvm current ## Mostrar versão atualmente em uso
nvm install 6 --reinstall-packages-from=5 ## Migração de pacotes globais
## Crie o arquivo .nvmrc na raiz do projeto e defina a versão. Ex: v17.7.1
nvm use ## NVM vai automaticamente encontrar .nvmrc e utilizar a versão indicada.
