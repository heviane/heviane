<#
.SYNOPSIS
    Script de Auditoria de Conformidade e Saúde do Workspace (Docs-as-Code).
.DESCRIPTION
    Varre os repositórios sob E:\Projects\GitHub para auditar:
    - Estado do Git (árvore limpa, commits não enviados ou não baixados)
    - Conformidade de Governança (AGENTS.md, README.md, .gitignore)
    - Verificação de Segurança (detecção de arquivos sensíveis como .env, .pem, .pfx)
    - Geração opcional de relatório executivo em Markdown para histórico de governança
.PARAMETER BasePath
    Caminho raiz do metadiretório. Padrão: E:\Projects\GitHub
.PARAMETER Detailed
    Exibe a tabela detalhada de todos os repositórios no console, mesmo os limpos.
.PARAMETER ExportReport
    Exporta o relatório consolidado em formato Markdown com timestamp.
.PARAMETER ReportPath
    Diretório de destino do relatório em Markdown. Padrão: H:\My Drive\Workspace Root Local\Governança Local & Prompts\auditorias
.EXAMPLE
    .\audit-workspace.ps1
    .\audit-workspace.ps1 -Detailed
    .\audit-workspace.ps1 -Detailed -ExportReport
#>

[CmdletBinding()]
param (
    [string]$BasePath = "E:\Projects\GitHub",
    [switch]$Detailed,
    [switch]$ExportReport,
    [string]$ReportPath = "H:\My Drive\Workspace Root Local\Governança Local & Prompts\auditorias"
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

# Exibição no Console
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
    $lines.Add("| **Repositórios sem AGENTS.md / CLAUDE.md** | $missingAgents | $statusAgentsDesc |")
    $lines.Add("| **Repositórios sem README.md** | $missingReadme | $statusReadmeDesc |")
    $lines.Add("| **Alertas de Arquivos Sensíveis (.env, .pfx, etc.)** | $securityAlerts | $statusSecDesc |")
    $lines.Add("")
    $lines.Add("---")
    $lines.Add("")
    $lines.Add("## 📦 Detalhamento por Repositório")
    $lines.Add("")
    $lines.Add("| Repositório | Status Git | Ahead | AGENTS.md | README.md | .gitignore | Alerta de Segurança |")
    $lines.Add("| :--- | :---: | :---: | :---: | :---: | :---: | :--- |")
    
    foreach ($r in $results) {
        $lines.Add("| " + '`' + $r.Repositorio + '`' + " | " + $r.Status + " | " + $r.Ahead + " | " + $r.AGENTS + " | " + $r.README + " | " + $r.Gitignore + " | " + $r.AlertaSeguranca + " |")
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
