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

    Context "Conformidade do Inventário de Extensões" {
        It "vscode-extensions.md deve conter tabela de extensões válida" {
            $docPath = Join-Path $repoRoot "meta-hub/vscode-extensions.md"
            Test-Path $docPath | Should Be $true
            $content = [System.IO.File]::ReadAllText($docPath, [System.Text.Encoding]::UTF8)
            ($content -match '\|\s*Extens.o\s*\|\s*ID\s*\|\s*Vers.o\s*\|') | Should Be $true
        }
    }
}
