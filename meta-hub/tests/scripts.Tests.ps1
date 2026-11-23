Describe "Automações PowerShell do Meta-Hub" {
    BeforeAll {
        $script:repoRoot = (Resolve-Path "$PSScriptRoot/../..").Path
        $script:scriptsDir = Join-Path $script:repoRoot "meta-hub/scripts"

        function Assert-True([bool]$condition, [string]$message = "Asserção falhou") {
            if (-not $condition) { throw $message }
        }
        function Assert-Equal($actual, $expected, [string]$message = "Valores divergentes") {
            if ($actual -ne $expected) { throw "$message (Esperado: '$expected', Obtido: '$actual')" }
        }
        function Assert-Zero([int]$actual, [string]$message = "Valor deveria ser zero") {
            if ($actual -ne 0) { throw "$message (Obtido: $actual)" }
        }
        function Assert-NotEmpty([string]$text, [string]$message = "Texto não deveria ser vazio") {
            if ([string]::IsNullOrWhiteSpace($text)) { throw $message }
        }
    }

    Context "Integridade dos Arquivos de Script" {
        It "sync-extensions.ps1 deve existir" {
            $path = Join-Path $script:scriptsDir "sync-extensions.ps1"
            Assert-True (Test-Path $path) "Arquivo sync-extensions.ps1 não encontrado em $path"
        }

        It "audit-workspace.ps1 deve existir" {
            $path = Join-Path $script:scriptsDir "audit-workspace.ps1"
            Assert-True (Test-Path $path) "Arquivo audit-workspace.ps1 não encontrado em $path"
        }

        It "sync-project-backlog.ps1 deve existir" {
            $path = Join-Path $script:scriptsDir "sync-project-backlog.ps1"
            Assert-True (Test-Path $path) "Arquivo sync-project-backlog.ps1 não encontrado em $path"
        }

        It "sync-extensions.ps1 deve ter sintaxe PowerShell válida (AST Parser)" {
            $path = Join-Path $script:scriptsDir "sync-extensions.ps1"
            $parseErrors = @()
            [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$parseErrors) | Out-Null
            Assert-Zero $parseErrors.Count "Erros de sintaxe encontrados em sync-extensions.ps1"
        }

        It "audit-workspace.ps1 deve ter sintaxe PowerShell válida (AST Parser)" {
            $path = Join-Path $script:scriptsDir "audit-workspace.ps1"
            $parseErrors = @()
            [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$parseErrors) | Out-Null
            Assert-Zero $parseErrors.Count "Erros de sintaxe encontrados em audit-workspace.ps1"
        }

        It "sync-project-backlog.ps1 deve ter sintaxe PowerShell válida (AST Parser)" {
            $path = Join-Path $script:scriptsDir "sync-project-backlog.ps1"
            $parseErrors = @()
            [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$parseErrors) | Out-Null
            Assert-Zero $parseErrors.Count "Erros de sintaxe encontrados em sync-project-backlog.ps1"
        }
    }

    Context "Documentação e Ajuda Nativa (Comment-Based Help)" {
        It "audit-workspace.ps1 deve conter Synopsis e Description na ajuda nativa" {
            $path = Join-Path $script:scriptsDir "audit-workspace.ps1"
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            $help = $ast.GetHelpContent()
            Assert-NotEmpty $help.Synopsis "Synopsis não preenchida em audit-workspace.ps1"
            Assert-NotEmpty $help.Description "Description não preenchida em audit-workspace.ps1"
        }

        It "audit-workspace.ps1 deve conter notas de runtime e pré-requisitos na ajuda nativa" {
            $path = Join-Path $script:scriptsDir "audit-workspace.ps1"
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            $help = $ast.GetHelpContent()
            Assert-True ($help.Notes -match "PowerShell") "Notas de runtime de audit-workspace.ps1 devem citar PowerShell"
        }

        It "sync-extensions.ps1 deve conter Synopsis e Description na ajuda nativa" {
            $path = Join-Path $script:scriptsDir "sync-extensions.ps1"
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            $help = $ast.GetHelpContent()
            Assert-NotEmpty $help.Synopsis "Synopsis não preenchida em sync-extensions.ps1"
            Assert-NotEmpty $help.Description "Description não preenchida em sync-extensions.ps1"
        }

        It "sync-extensions.ps1 deve conter notas de runtime e pré-requisitos na ajuda nativa" {
            $path = Join-Path $script:scriptsDir "sync-extensions.ps1"
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            $help = $ast.GetHelpContent()
            Assert-True ($help.Notes -match "PowerShell") "Notas de runtime de sync-extensions.ps1 devem citar PowerShell"
        }

        It "sync-project-backlog.ps1 deve conter Synopsis e Description na ajuda nativa" {
            $path = Join-Path $script:scriptsDir "sync-project-backlog.ps1"
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            $help = $ast.GetHelpContent()
            Assert-NotEmpty $help.Synopsis "Synopsis não preenchida em sync-project-backlog.ps1"
            Assert-NotEmpty $help.Description "Description não preenchida em sync-project-backlog.ps1"
        }

        It "sync-project-backlog.ps1 deve conter notas de runtime e pré-requisitos na ajuda nativa" {
            $path = Join-Path $script:scriptsDir "sync-project-backlog.ps1"
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            $help = $ast.GetHelpContent()
            Assert-True ($help.Notes -match "PowerShell") "Notas de runtime de sync-project-backlog.ps1 devem citar PowerShell"
        }
    }

    Context "Parâmetros e Assinatura de Comandos" {
        It "sync-extensions.ps1 deve conter parâmetros DocPath e CheckOnly" {
            $path = Join-Path $script:scriptsDir "sync-extensions.ps1"
            $parseErrors = @()
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$parseErrors)
            $paramNames = $ast.ParamBlock.Parameters.Name.VariablePath.UserPath
            Assert-True ($paramNames -contains "DocPath") "Parâmetro DocPath não encontrado"
            Assert-True ($paramNames -contains "CheckOnly") "Parâmetro CheckOnly não encontrado"
        }

        It "audit-workspace.ps1 deve conter parâmetros BasePath, StrictGovernance e ExportReport" {
            $path = Join-Path $script:scriptsDir "audit-workspace.ps1"
            $parseErrors = @()
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$parseErrors)
            $paramNames = $ast.ParamBlock.Parameters.Name.VariablePath.UserPath
            Assert-True ($paramNames -contains "BasePath") "Parâmetro BasePath não encontrado"
            Assert-True ($paramNames -contains "StrictGovernance") "Parâmetro StrictGovernance não encontrado"
            Assert-True ($paramNames -contains "ExportReport") "Parâmetro ExportReport não encontrado"
        }

        It "sync-project-backlog.ps1 deve conter parâmetros de controle e escopo" {
            $path = Join-Path $script:scriptsDir "sync-project-backlog.ps1"
            $parseErrors = @()
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$parseErrors)
            $paramNames = $ast.ParamBlock.Parameters.Name.VariablePath.UserPath
            Assert-True ($paramNames -contains "BacklogPath") "Parâmetro BacklogPath não encontrado"
            Assert-True ($paramNames -contains "ProjectNumber") "Parâmetro ProjectNumber não encontrado"
            Assert-True ($paramNames -contains "Owner") "Parâmetro Owner não encontrado"
            Assert-True ($paramNames -contains "CheckOnly") "Parâmetro CheckOnly não encontrado"
            Assert-True ($paramNames -contains "CreateMissing") "Parâmetro CreateMissing não encontrado"
            Assert-True ($paramNames -contains "SyncStatus") "Parâmetro SyncStatus não encontrado"
            Assert-True ($paramNames -contains "SyncPriority") "Parâmetro SyncPriority não encontrado"
        }
    }

    Context "Tratamento de Caminhos e Parâmetros Inválidos" {
        It "audit-workspace.ps1 deve retornar erro para diretório inexistente" {
            $script = Join-Path $script:scriptsDir "audit-workspace.ps1"
            $fakePath = Join-Path ([System.IO.Path]::GetTempPath()) "fake_dir_$(Get-Random)"
            $hasError = $false
            try {
                & $script -BasePath $fakePath -ErrorAction Stop 2>$null
            } catch {
                $hasError = $true
            }
            Assert-True $hasError "Deveria ter sinalizado erro para diretório inexistente"
        }

        It "sync-extensions.ps1 deve retornar erro para arquivo de documentação inexistente" {
            $script = Join-Path $script:scriptsDir "sync-extensions.ps1"
            $fakeDoc = Join-Path ([System.IO.Path]::GetTempPath()) "fake_doc_$(Get-Random).md"
            $hasError = $false
            try {
                & $script -DocPath $fakeDoc -ErrorAction Stop 2>$null
            } catch {
                $hasError = $true
            }
            Assert-True $hasError "Deveria ter sinalizado erro para arquivo inexistente"
        }

        It "sync-project-backlog.ps1 deve retornar erro para arquivo de backlog inexistente" {
            $script = Join-Path $script:scriptsDir "sync-project-backlog.ps1"
            $fakeBacklog = Join-Path ([System.IO.Path]::GetTempPath()) "fake_backlog_$(Get-Random).md"
            $hasError = $false
            try {
                & $script -BacklogPath $fakeBacklog -ErrorAction Stop 2>$null
            } catch {
                $hasError = $true
            }
            Assert-True $hasError "Deveria ter sinalizado erro para backlog inexistente"
        }
    }

    Context "Detecção Funcional em Sandbox Temporário" {
        BeforeAll {
            $script:sandbox = Join-Path ([System.IO.Path]::GetTempPath()) "audit_pester_sandbox_$(Get-Random)"
            New-Item -ItemType Directory -Path "$script:sandbox/repo-conforme/.git" -Force | Out-Null
            try { (Get-Item "$script:sandbox/repo-conforme/.git").Attributes = 'Directory, Hidden' } catch {}
            New-Item -ItemType File -Path "$script:sandbox/repo-conforme/README.md" -Force | Out-Null
            New-Item -ItemType File -Path "$script:sandbox/repo-conforme/AGENTS.md" -Force | Out-Null
            New-Item -ItemType File -Path "$script:sandbox/repo-conforme/.gitignore" -Force | Out-Null

            New-Item -ItemType Directory -Path "$script:sandbox/repo-incompleto/.git" -Force | Out-Null
            try { (Get-Item "$script:sandbox/repo-incompleto/.git").Attributes = 'Directory, Hidden' } catch {}
        }

        AfterAll {
            if ($script:sandbox -and (Test-Path $script:sandbox)) {
                Remove-Item -Path $script:sandbox -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        It "audit-workspace.ps1 deve detectar repositórios em sandbox e executar com sucesso" {
            $script = Join-Path $script:scriptsDir "audit-workspace.ps1"
            $global:LASTEXITCODE = 0
            & $script -BasePath $script:sandbox 2>$null
            Assert-Equal $LASTEXITCODE 0 "Deveria retornar código de saída 0"
        }

        It "audit-workspace.ps1 deve executar em modo estrito com sucesso" {
            $script = Join-Path $script:scriptsDir "audit-workspace.ps1"
            $global:LASTEXITCODE = 0
            & $script -BasePath $script:sandbox -StrictGovernance 2>$null
            Assert-Equal $LASTEXITCODE 0 "Deveria retornar código de saída 0"
        }
    }

    Context "Conformidade do Inventário de Extensões" {
        It "vscode-extensions.md deve conter tabela de extensões válida" {
            $docPath = Join-Path $script:repoRoot "meta-hub/vscode-extensions.md"
            Assert-True (Test-Path $docPath) "Arquivo vscode-extensions.md não encontrado"
            $content = [System.IO.File]::ReadAllText($docPath, [System.Text.Encoding]::UTF8)
            Assert-True ($content -match '\|\s*Extens.o\s*\|\s*ID\s*\|\s*Vers.o\s*\|') "Tabela de extensões não possui cabeçalho esperado"
        }
    }

    Context "Execução de Auditoria do Backlog em Modo CheckOnly" {
        It "sync-project-backlog.ps1 deve executar em modo CheckOnly quando autenticado" {
            $hasProjectAuth = $false
            try {
                $testQuery = gh project list --owner heviane --format json 2>$null
                if ($LASTEXITCODE -eq 0 -and $testQuery) {
                    $parsed = $testQuery | ConvertFrom-Json
                    if ($parsed.projects -and $parsed.projects.Count -gt 0) {
                        $hasProjectAuth = $true
                    }
                }
            } catch {}

            if (-not $hasProjectAuth) {
                # Em ambiente de CI sem token com escopo 'project' (GITHUB_TOKEN padrão), omite a chamada de rede remota
                return
            }

            $script = Join-Path $script:scriptsDir "sync-project-backlog.ps1"
            $backlog = Join-Path $script:repoRoot "meta-hub/backlog.md"
            $hasError = $false
            try {
                & $script -BacklogPath $backlog -CheckOnly -NonInteractive 2>$null | Out-Null
            } catch {
                $hasError = $true
            }
            Assert-True (-not $hasError) "Execução de sync-project-backlog.ps1 -CheckOnly não deveria falhar"
        }
    }
}
