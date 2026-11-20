<#
.SYNOPSIS
    Script de Auditoria de Conformidade e Saúde do Workspace (Docs-as-Code).
.DESCRIPTION
    Varre os repositórios sob E:\Projects\GitHub para auditar:
    - Estado do Git (árvore limpa, commits não enviados ou não baixados)
    - Conformidade de Governança (AGENTS.md, README.md, .gitignore)
    - Verificação de Segurança (detecção de arquivos sensíveis como .env, .pem, .pfx)
.PARAMETER BasePath
    Caminho raiz do metadiretório. Padrão: E:\Projects\GitHub
.EXAMPLE
    .\audit-workspace.ps1
    .\audit-workspace.ps1 -Detailed
#>

[CmdletBinding()]
param (
    [string]$BasePath = "E:\Projects\GitHub",
    [switch]$Detailed
)

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " 🔍 AUDITORIA DO WORKSPACE MULTI-REPOSITÓRIOS ($BasePath)" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $BasePath)) {
    Write-Error "Caminho base '$BasePath' não encontrado."
    exit 1
}

$gitDirs = Get-ChildItem -Path $BasePath -Directory -Depth 3 -Filter ".git" -Hidden -Force
$totalRepos = $gitDirs.Count
$dirtyRepos = 0
$unpushedRepos = 0
$missingAgents = 0
$missingReadme = 0
$securityAlerts = 0

$results = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($gitDir in $gitDirs) {
    $repoPath = $gitDir.Parent.FullName
    $relPath = $repoPath.Replace("$BasePath\", "")
    
    # 1. Checagem do Git
    $statusShort = git -C $repoPath status -s 2>$null
    $branchInfo = git -C $repoPath status -s -b 2>$null | Select-Object -First 1
    
    $isDirty = [bool]$statusShort
    $isAhead = $branchInfo -match '\[ahead \d+\]'
    $isBehind = $branchInfo -match '\[behind \d+\]'
    
    if ($isDirty) { $dirtyRepos++ }
    if ($isAhead) { $unpushedRepos++ }

    # 2. Governança
    $hasAgents = (Test-Path (Join-Path $repoPath "AGENTS.md")) -or (Test-Path (Join-Path $repoPath "CLAUDE.md"))
    $hasReadme = Test-Path (Join-Path $repoPath "README.md")
    $hasGitignore = Test-Path (Join-Path $repoPath ".gitignore")

    if (-not $hasAgents) { $missingAgents++ }
    if (-not $hasReadme) { $missingReadme++ }

    # 3. Segurança (arquivos com potenciais credenciais)
    $sensitiveFiles = Get-ChildItem -Path $repoPath -File -Recurse -Depth 4 -ErrorAction SilentlyContinue | Where-Object {
        $_.FullName -notmatch '\\\.git\\' -and (
            ($_.Name -match '^\.env$' -and $_.Name -ne '.env.example') -or
            ($_.Extension -in @('.pem', '.pfx', '.key', '.pkcs12')) -or
            ($_.Name -match '^id_rsa')
        )
    }
    $hasSecurityAlert = [bool]$sensitiveFiles
    if ($hasSecurityAlert) { $securityAlerts++ }

    # Determinar status visual
    $statusIcon = if ($isDirty) { "⚠️ Modificado" } elseif ($isAhead) { "⬆️ Ahead" } else { "✅ Limpo" }

    $results.Add([PSCustomObject]@{
        Repositorio     = $relPath
        Status          = $statusIcon
        Ahead           = if ($isAhead) { "Sim" } else { "-" }
        AGENTS          = if ($hasAgents) { "OK" } else { "Ausente" }
        README          = if ($hasReadme) { "OK" } else { "Ausente" }
        Gitignore       = if ($hasGitignore) { "OK" } else { "Ausente" }
        AlertaSeguranca = if ($hasSecurityAlert) { "⚠️ $($sensitiveFiles.Name -join ', ')" } else { "Nenhum" }
    })
}

# Exibição
if ($Detailed) {
    $results | Format-Table -AutoSize
} else {
    # Exibe repositórios com pendências ou status relevante
    $attention = $results | Where-Object { $_.Status -ne "✅ Limpo" -or $_.Ahead -ne "-" -or $_.AlertaSeguranca -ne "Nenhum" }
    if ($attention) {
        Write-Host "📦 Repositórios que demandam atenção:" -ForegroundColor Yellow
        $attention | Format-Table -AutoSize
    } else {
        Write-Host "✨ Todos os repositórios estão sincronizados e com árvores limpas!" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "📊 RESUMO DA AUDITORIA:" -ForegroundColor Cyan
Write-Host " - Total de Repositórios Auditados : $totalRepos"
Write-Host " - Repositórios com Modificações   : $dirtyRepos" $(if ($dirtyRepos -gt 0) { "⚠️" } else { "✅" })
Write-Host " - Repositórios com Push Pendente  : $unpushedRepos" $(if ($unpushedRepos -gt 0) { "⬆️" } else { "✅" })
Write-Host " - Repositórios sem AGENTS/CLAUDE  : $missingAgents"
Write-Host " - Repositórios sem README         : $missingReadme"
Write-Host " - Alertas de Arquivos Sensíveis   : $securityAlerts" $(if ($securityAlerts -gt 0) { "🚨" } else { "✅" })
Write-Host ""
Write-Host "Dica: Execute com o parâmetro -Detailed para ver a tabela completa de todos os repositórios." -ForegroundColor DarkGray
