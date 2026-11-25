<#
.SYNOPSIS
    Script de Auditoria de Conformidade e Saúde do Workspace (Docs-as-Code).
.DESCRIPTION
    Varre os repositórios sob o diretório raiz do workspace para auditar:
    - Estado do Git (árvore limpa, commits não enviados ou desatualizados em relação ao remoto)
    - Conformidade de Governança (AGENTS.md, README.md, .gitignore)
    - Verificação de Segurança (detecção de arquivos sensíveis como .env.*, .pem, .pfx, chaves)
    - Geração opcional de relatório executivo em Markdown para histórico de governança
.PARAMETER BasePath
    Caminho raiz do metadiretório. Padrão: descoberto dinamicamente a partir de $env:WORKSPACE_ROOT ou do diretório pai que contém 'github.code-workspace'.
.PARAMETER Detailed
    Exibe a tabela detalhada de todos os repositórios no console, mesmo os limpos.
.PARAMETER ExportReport
    Exporta o relatório consolidado em formato Markdown com timestamp.
.PARAMETER ReportPath
    Diretório de destino do relatório em Markdown. Padrão: descoberto dinamicamente a partir de $env:GOVERNANCE_CLOUD_ROOT/auditorias ou ./reports/auditorias.
.PARAMETER Fetch
    Executa git fetch silencioso em cada repositório antes de inspecionar status para sincronização real de ahead/behind.
.PARAMETER StrictGovernance
    Considera ausência de arquivos de governança (AGENTS.md, README.md, .gitignore) como critério para listar repositórios no modo resumido.
.EXAMPLE
    .\audit-workspace.ps1
    .\audit-workspace.ps1 -Detailed
    .\audit-workspace.ps1 -Detailed -ExportReport
    .\audit-workspace.ps1 -Fetch -Detailed
    .\audit-workspace.ps1 -StrictGovernance
.INPUTS
    Nenhum. Este script não consome entrada por pipeline.
.OUTPUTS
    System.Management.Automation.PSCustomObject[] contendo o diagnóstico de cada repositório.
.NOTES
    Versão Mínima: Windows PowerShell 5.1 ou PowerShell 7.0+ (pwsh cross-platform).
    Sistemas Operacionais Suportados: Windows 10/11, Linux (Ubuntu/Debian), macOS.
    Dependências de CLI: Git CLI ('git') deve estar acessível no PATH do sistema operacional.
    Permissões: Requer permissão para execução de scripts (ex: Set-ExecutionPolicy -Scope Process RemoteSigned).
    Comportamento de Escrita / Dry-Run:
        - Somente leitura por padrão. Não altera estado do Git nem modifica arquivos.
        - Gera arquivo em disco apenas quando o parâmetro -ExportReport é explicitamente fornecido.
    Tratamento de Erros & Códigos de Saída (Exit Codes):
        0 - Execução concluída com sucesso.
        1 - Erro fatal (caminho base inexistente ou falha crítica de execução).
#>

[CmdletBinding()]
param (
    [string]$BasePath = "",
    [switch]$Detailed,
    [switch]$ExportReport,
    [string]$ReportPath = "",
    [switch]$Fetch,
    [switch]$StrictGovernance
)

# Resolução dinâmica de caminhos caso não fornecidos explicitamente
if ([string]::IsNullOrWhiteSpace($BasePath)) {
    if ($env:WORKSPACE_ROOT -and (Test-Path $env:WORKSPACE_ROOT)) {
        $BasePath = $env:WORKSPACE_ROOT
    } else {
        $candidate = (Resolve-Path $PSScriptRoot).Path
        $foundRoot = $null
        while ($candidate) {
            if (Test-Path (Join-Path $candidate "github.code-workspace")) {
                $foundRoot = $candidate
                break
            }
            $parent = Split-Path $candidate -Parent
            if ($parent -eq $candidate) { break }
            $candidate = $parent
        }
        if ($foundRoot) {
            $BasePath = $foundRoot
        } else {
            $BasePath = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
        }
    }
}

if ([string]::IsNullOrWhiteSpace($ReportPath)) {
    if ($env:GOVERNANCE_CLOUD_ROOT -and (Test-Path $env:GOVERNANCE_CLOUD_ROOT)) {
        $ReportPath = Join-Path $env:GOVERNANCE_CLOUD_ROOT "auditorias"
    } else {
        $ReportPath = Join-Path $BasePath "reports\auditorias"
    }
}

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " 🔍 AUDITORIA DO WORKSPACE MULTI-REPOSITÓRIOS ($BasePath)" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $BasePath)) {
    throw "Caminho base '$BasePath' não encontrado."
}

if ($Fetch) {
    Write-Host "🔄 Parâmetro -Fetch ativado: sincronizando referências remotas do Git..." -ForegroundColor Yellow
}

# 1. Varredura de repositórios (inclui .git como diretório ou arquivo de worktree/submódulo)
$gitEntries = @(Get-ChildItem -Path $BasePath -Depth 3 -Filter ".git" -Hidden -Force | Where-Object {
    $_.FullName -notmatch '[\\/](node_modules|\.venv|bin|obj|target)[\\/]'
})

$totalRepos = $gitEntries.Count
$dirtyRepos = 0
$unpushedRepos = 0
$behindRepos = 0
$missingAgents = 0
$missingReadme = 0
$securityAlerts = 0

$results = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($gitEntry in $gitEntries) {
    $repoPath = if ($gitEntry.PSIsContainer) { $gitEntry.Parent.FullName } else { $gitEntry.Directory.FullName }
    $baseTrim = $BasePath.TrimEnd('\', '/')
    $relPath = if ($repoPath.StartsWith($baseTrim, [System.StringComparison]::OrdinalIgnoreCase)) {
        $repoPath.Substring($baseTrim.Length).TrimStart('\', '/')
    } else {
        $repoPath
    }
    
    # Sincronização remota opcional
    if ($Fetch) {
        git -C $repoPath fetch --prune --quiet 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Falha ao executar 'git fetch' no repositório '$relPath'. Verifique a conectividade com o remoto."
        }
    }

    # 1. Checagem do Git (usando status com branch)
    $statusShort = git -C $repoPath status --porcelain 2>$null
    $branchInfo = git -C $repoPath status -s -b 2>$null | Select-Object -First 1
    
    $isDirty = [bool]$statusShort
    $aheadN = if ($branchInfo -match 'ahead (\d+)') { [int]$Matches[1] } else { 0 }
    $behindN = if ($branchInfo -match 'behind (\d+)') { [int]$Matches[1] } else { 0 }
    $isAhead = $aheadN -gt 0
    $isBehind = $behindN -gt 0
    
    $aheadCount = if ($isAhead) { "+$aheadN" } else { "-" }
    $behindCount = if ($isBehind) { "-$behindN" } else { "-" }

    if ($isDirty) { $dirtyRepos++ }
    if ($isAhead) { $unpushedRepos++ }
    if ($isBehind) { $behindRepos++ }

    # 2. Governança
    $hasAgents = (Test-Path (Join-Path $repoPath "AGENTS.md")) -or (Test-Path (Join-Path $repoPath "CLAUDE.md"))
    $hasReadme = Test-Path (Join-Path $repoPath "README.md")
    $hasGitignore = Test-Path (Join-Path $repoPath ".gitignore")

    if (-not $hasAgents) { $missingAgents++ }
    if (-not $hasReadme) { $missingReadme++ }

    # 3. Segurança (arquivos com potenciais credenciais/segredos)
    $sensitiveFiles = Get-ChildItem -Path $repoPath -File -Recurse -Force -Depth 4 -ErrorAction SilentlyContinue | Where-Object {
        $_.FullName -notmatch '[\\/](\.git|node_modules|\.venv|bin|obj|target)[\\/]' -and (
            ($_.Name -match '^\.env(\..+)?$' -and $_.Name -notmatch '\.(example|sample|template)$') -or
            ($_.Extension -in @('.pem', '.pfx', '.key', '.pkcs12', '.p12')) -or
            ($_.Name -match '^(id_rsa|credentials\.json|secrets\.)')
        )
    }
    $hasSecurityAlert = [bool]$sensitiveFiles
    if ($hasSecurityAlert) { $securityAlerts++ }

    # Determinar status visual
    $statusIcon = if ($isDirty) { 
        "⚠️ Modificado" 
    } elseif ($isAhead -and $isBehind) { 
        "🔄 Divergente"
    } elseif ($isAhead) { 
        "⬆️ Ahead" 
    } elseif ($isBehind) {
        "⬇️ Behind"
    } else { 
        "✅ Limpo" 
    }

    $results.Add([PSCustomObject]@{
        Repositorio     = $relPath
        Status          = $statusIcon
        Ahead           = $aheadCount
        Behind          = $behindCount
        AGENTS          = if ($hasAgents) { "OK" } else { "Ausente" }
        README          = if ($hasReadme) { "OK" } else { "Ausente" }
        Gitignore       = if ($hasGitignore) { "OK" } else { "Ausente" }
        AlertaSeguranca = if ($hasSecurityAlert) { "⚠️ $($sensitiveFiles.Name -join ', ')" } else { "Nenhum" }
    })
}

# Exibição no Console
if ($Detailed) {
    $results | Format-Table -AutoSize
} else {
    # Exibe repositórios com pendências ou status relevante
    $attention = $results | Where-Object { 
        $_.Status -ne "✅ Limpo" -or 
        $_.Ahead -ne "-" -or 
        $_.Behind -ne "-" -or 
        $_.AlertaSeguranca -ne "Nenhum" -or
        ($StrictGovernance -and ($_.AGENTS -eq "Ausente" -or $_.README -eq "Ausente" -or $_.Gitignore -eq "Ausente"))
    }
    if ($attention) {
        $alertTitle = if ($StrictGovernance) {
            "📦 Repositórios que demandam atenção (incluindo conformidade estrita de governança):"
        } else {
            "📦 Repositórios que demandam atenção:"
        }
        Write-Host $alertTitle -ForegroundColor Yellow
        $attention | Format-Table -AutoSize
    } else {
        if (-not $StrictGovernance -and ($missingAgents -gt 0 -or $missingReadme -gt 0)) {
            Write-Host "✨ Todos os repositórios estão sincronizados e com árvores limpas!" -ForegroundColor Green
            Write-Host "💡 Nota: Existem $missingAgents repositório(s) sem AGENTS.md e $missingReadme sem README.md." -ForegroundColor DarkYellow
            Write-Host "   Execute com -StrictGovernance para listar todas as pendências de governança." -ForegroundColor DarkGray
        } else {
            Write-Host "✨ Todos os repositórios estão sincronizados, com árvores limpas e 100% em conformidade com as regras de governança!" -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "📊 RESUMO DA AUDITORIA:" -ForegroundColor Cyan
Write-Host " - Total de Repositórios Auditados : $totalRepos"
Write-Host " - Repositórios com Modificações   : $dirtyRepos" $(if ($dirtyRepos -gt 0) { "⚠️" } else { "✅" })
Write-Host " - Repositórios com Push Pendente  : $unpushedRepos" $(if ($unpushedRepos -gt 0) { "⬆️" } else { "✅" })
Write-Host " - Repositórios Desatualizados     : $behindRepos" $(if ($behindRepos -gt 0) { "⬇️" } else { "✅" })
Write-Host " - Repositórios sem AGENTS/CLAUDE  : $missingAgents" $(if ($missingAgents -gt 0) { "⚠️" } else { "✅" })
Write-Host " - Repositórios sem README         : $missingReadme" $(if ($missingReadme -gt 0) { "⚠️" } else { "✅" })
Write-Host " - Alertas de Arquivos Sensíveis   : $securityAlerts" $(if ($securityAlerts -gt 0) { "🚨" } else { "✅" })
Write-Host ""

# 4. Exportação Opcional de Relatório em Markdown
if ($ExportReport) {
    if (-not (Test-Path $ReportPath)) {
        try {
            New-Item -ItemType Directory -Path $ReportPath -Force | Out-Null
        } catch {
            $ReportPath = Join-Path $BasePath "auditorias"
            New-Item -ItemType Directory -Path $ReportPath -Force | Out-Null
        }
    }
    
    $timestampDate = Get-Date -Format "yyyy-MM-dd"
    $timestampFull = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    $reportFile = Join-Path $ReportPath "audit-$timestampDate.md"
    
    $statusDirtyDesc = if ($dirtyRepos -gt 0) { "⚠️ Alerta" } else { "✅ OK" }
    $statusAheadDesc = if ($unpushedRepos -gt 0) { "⬆️ Ahead" } else { "✅ OK" }
    $statusBehindDesc = if ($behindRepos -gt 0) { "⬇️ Behind" } else { "✅ OK" }
    $statusAgentsDesc = if ($missingAgents -gt 0) { "⚠️ Ausente" } else { "✅ OK" }
    $statusReadmeDesc = if ($missingReadme -gt 0) { "⚠️ Ausente" } else { "✅ OK" }
    $statusSecDesc = if ($securityAlerts -gt 0) { "🚨 Risco Crítico" } else { "✅ Seguro" }

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add("# 🔍 Relatório de Auditoria do Workspace")
    $lines.Add("")
    $lines.Add("> **Data da Execução:** " + $timestampFull + "  ")
    $lines.Add("> **Caminho Base Auditado:** " + '`' + $BasePath + '`' + "  ")
    $lines.Add("> **Destino do Relatório:** " + '`' + $reportFile + '`')
    $lines.Add("")
    $lines.Add("---")
    $lines.Add("")
    $lines.Add("## 📊 Resumo Executivo")
    $lines.Add("")
    $lines.Add("| Métrica | Total | Situação |")
    $lines.Add("| :--- | :---: | :---: |")
    $lines.Add("| **Total de Repositórios Auditados** | $totalRepos | ℹ️ |")
    $lines.Add("| **Repositórios com Modificações Pendentes** | $dirtyRepos | $statusDirtyDesc |")
    $lines.Add("| **Repositórios com Push Pendente** | $unpushedRepos | $statusAheadDesc |")
    $lines.Add("| **Repositórios Desatualizados (Behind)** | $behindRepos | $statusBehindDesc |")
    $lines.Add("| **Repositórios sem AGENTS.md / CLAUDE.md** | $missingAgents | $statusAgentsDesc |")
    $lines.Add("| **Repositórios sem README.md** | $missingReadme | $statusReadmeDesc |")
    $lines.Add("| **Alertas de Arquivos Sensíveis (.env, .pfx, etc.)** | $securityAlerts | $statusSecDesc |")
    $lines.Add("")
    $lines.Add("---")
    $lines.Add("")
    $lines.Add("## 📦 Detalhamento por Repositório")
    $lines.Add("")
    $lines.Add("| Repositório | Status Git | Ahead | Behind | AGENTS.md | README.md | .gitignore | Alerta de Segurança |")
    $lines.Add("| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :--- |")
    
    foreach ($r in $results) {
        $lines.Add("| " + '`' + $r.Repositorio + '`' + " | " + $r.Status + " | " + $r.Ahead + " | " + $r.Behind + " | " + $r.AGENTS + " | " + $r.README + " | " + $r.Gitignore + " | " + $r.AlertaSeguranca + " |")
    }
    
    $lines.Add("")
    $lines.Add("---")
    $lines.Add("*Relatório gerado automaticamente por " + '`audit-workspace.ps1`' + " via Docs-as-Code.*")

    $lines | Set-Content -Path $reportFile -Encoding UTF8
    Write-Host "📄 Relatório de auditoria exportado com sucesso para:" -ForegroundColor Green
    Write-Host "   $reportFile" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host "Dica: Execute com -Detailed para ver todos os repositórios ou -ExportReport para gerar relatório em Markdown." -ForegroundColor DarkGray
}

if ($securityAlerts -gt 0) {
    Write-Host "🚨 ATENÇÃO: Foram encontrados $securityAlerts alerta(s) de arquivo(s) potencialmente sensível(is)!" -ForegroundColor Red
    exit 1
}

exit 0
