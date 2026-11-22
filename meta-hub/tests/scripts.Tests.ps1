Describe "Automações PowerShell do Meta-Hub" {
    $repoRoot = (Resolve-Path "$PSScriptRoot/../..").Path
    $scriptsDir = Join-Path $repoRoot "meta-hub/scripts"

    Context "Integridade dos Arquivos de Script" {
        It "sync-extensions.ps1 deve existir" {
            $path = Join-Path $scriptsDir "sync-extensions.ps1"
            Test-Path $path | Should Be $true
        }

        It "audit-workspace.ps1 deve existir" {
            $path = Join-Path $scriptsDir "audit-workspace.ps1"
            Test-Path $path | Should Be $true
        }

        It "sync-extensions.ps1 deve ter sintaxe PowerShell válida (AST Parser)" {
            $path = Join-Path $scriptsDir "sync-extensions.ps1"
            $parseErrors = @()
            [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$parseErrors) | Out-Null
            $parseErrors.Count | Should Be 0
        }

        It "audit-workspace.ps1 deve ter sintaxe PowerShell válida (AST Parser)" {
            $path = Join-Path $scriptsDir "audit-workspace.ps1"
            $parseErrors = @()
            [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$parseErrors) | Out-Null
            $parseErrors.Count | Should Be 0
        }
    }

    Context "Documentação e Ajuda Nativa (Comment-Based Help)" {
        It "audit-workspace.ps1 deve conter Synopsis e Description na ajuda nativa" {
            $path = Join-Path $scriptsDir "audit-workspace.ps1"
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            $help = $ast.GetHelpContent()
            ([string]::IsNullOrWhiteSpace($help.Synopsis)) | Should Be $false
            ([string]::IsNullOrWhiteSpace($help.Description)) | Should Be $false
        }

        It "audit-workspace.ps1 deve conter notas de runtime e pré-requisitos na ajuda nativa" {
            $path = Join-Path $scriptsDir "audit-workspace.ps1"
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            $help = $ast.GetHelpContent()
            ($help.Notes -match "PowerShell") | Should Be $true
        }

        It "sync-extensions.ps1 deve conter Synopsis e Description na ajuda nativa" {
            $path = Join-Path $scriptsDir "sync-extensions.ps1"
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            $help = $ast.GetHelpContent()
            ([string]::IsNullOrWhiteSpace($help.Synopsis)) | Should Be $false
            ([string]::IsNullOrWhiteSpace($help.Description)) | Should Be $false
        }

        It "sync-extensions.ps1 deve conter notas de runtime e pré-requisitos na ajuda nativa" {
            $path = Join-Path $scriptsDir "sync-extensions.ps1"
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            $help = $ast.GetHelpContent()
            ($help.Notes -match "PowerShell") | Should Be $true
        }
    }

    Context "Parâmetros e Assinatura de Comandos" {
        It "sync-extensions.ps1 deve conter parâmetros DocPath e CheckOnly" {
            $path = Join-Path $scriptsDir "sync-extensions.ps1"
            $parseErrors = @()
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$parseErrors)
            $paramNames = $ast.ParamBlock.Parameters.Name.VariablePath.UserPath
            ($paramNames -contains "DocPath") | Should Be $true
            ($paramNames -contains "CheckOnly") | Should Be $true
        }

        It "audit-workspace.ps1 deve conter parâmetros BasePath, StrictGovernance e ExportReport" {
            $path = Join-Path $scriptsDir "audit-workspace.ps1"
            $parseErrors = @()
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$parseErrors)
            $paramNames = $ast.ParamBlock.Parameters.Name.VariablePath.UserPath
            ($paramNames -contains "BasePath") | Should Be $true
            ($paramNames -contains "StrictGovernance") | Should Be $true
            ($paramNames -contains "ExportReport") | Should Be $true
        }
    }

    Context "Tratamento de Caminhos e Parâmetros Inválidos" {
        It "audit-workspace.ps1 deve retornar código de saída 1 para diretório inexistente" {
            $script = Join-Path $scriptsDir "audit-workspace.ps1"
            $fakePath = Join-Path ([System.IO.Path]::GetTempPath()) "fake_dir_$(Get-Random)"
            $global:LASTEXITCODE = 0
            & $script -BasePath $fakePath 2>$null
            $LASTEXITCODE | Should Be 1
        }

        It "sync-extensions.ps1 deve retornar código de saída 1 para arquivo de documentação inexistente" {
            $script = Join-Path $scriptsDir "sync-extensions.ps1"
            $fakeDoc = Join-Path ([System.IO.Path]::GetTempPath()) "fake_doc_$(Get-Random).md"
            $global:LASTEXITCODE = 0
            & $script -DocPath $fakeDoc 2>$null
            $LASTEXITCODE | Should Be 1
        }
    }

    Context "Detecção Funcional em Sandbox Temporário" {
        BeforeAll {
            $script:sandbox = Join-Path ([System.IO.Path]::GetTempPath()) "audit_pester_sandbox_$(Get-Random)"
            New-Item -ItemType Directory -Path "$script:sandbox/repo-conforme/.git" -Force | Out-Null
            (Get-Item "$script:sandbox/repo-conforme/.git").Attributes = 'Directory, Hidden'
            New-Item -ItemType File -Path "$script:sandbox/repo-conforme/README.md" -Force | Out-Null
            New-Item -ItemType File -Path "$script:sandbox/repo-conforme/AGENTS.md" -Force | Out-Null
            New-Item -ItemType File -Path "$script:sandbox/repo-conforme/.gitignore" -Force | Out-Null

            New-Item -ItemType Directory -Path "$script:sandbox/repo-incompleto/.git" -Force | Out-Null
            (Get-Item "$script:sandbox/repo-incompleto/.git").Attributes = 'Directory, Hidden'
        }

        AfterAll {
            if ($script:sandbox -and (Test-Path $script:sandbox)) {
                Remove-Item -Path $script:sandbox -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        It "audit-workspace.ps1 deve detectar repositórios em sandbox e executar com sucesso" {
            $script = Join-Path $scriptsDir "audit-workspace.ps1"
            $global:LASTEXITCODE = 0
            & $script -BasePath $script:sandbox 2>$null
            $LASTEXITCODE | Should Be 0
        }

        It "audit-workspace.ps1 deve executar em modo estrito com sucesso" {
            $script = Join-Path $scriptsDir "audit-workspace.ps1"
            $global:LASTEXITCODE = 0
            & $script -BasePath $script:sandbox -StrictGovernance 2>$null
            $LASTEXITCODE | Should Be 0
        }
    }

    Context "Conformidade do Inventário de Extensões" {
        It "vscode-extensions.md deve conter tabela de extensões válida" {
            $docPath = Join-Path $repoRoot "meta-hub/vscode-extensions.md"
            Test-Path $docPath | Should Be $true
            $content = [System.IO.File]::ReadAllText($docPath, [System.Text.Encoding]::UTF8)
            ($content -match '\|\s*Extens.o\s*\|\s*ID\s*\|\s*Vers.o\s*\|') | Should Be $true
        }
    }
}
