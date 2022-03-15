#!/bin/bash

# Update apt package index.
sudo apt-get update

# Update Node Package Manager
sudo npm install npm@latest -g
npm -v

# Update Node
sudo npm cache clean -f  ## Clear npm cache
sudo npm install -g n    ## Install module “n”
sudo n stable            ## Install the latest stable version (LTS)
sudo n latest            ## Install the latest current version
node -v                  ## After restarting the terminal, check the Node version
