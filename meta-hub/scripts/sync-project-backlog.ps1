<#
.SYNOPSIS
    Sincroniza o backlog Docs-as-Code (Markdown) com o GitHub Project 14 via GitHub CLI (gh).
.DESCRIPTION
    Faz o parsing das tabelas de épicos no arquivo meta-hub/backlog.md, extrai os itens
    (Status, ID, Prioridade, Item, Descrição) e reconcilia de forma idempotente com os
    cards do GitHub Project 14 no GitHub, usando o ID entre colchetes como chave primária.
    
    Suporta modo de auditoria (-CheckOnly), criação de itens ausentes (-CreateMissing),
    e sincronização de status (-SyncStatus) e prioridade (-SyncPriority).
.PARAMETER BacklogPath
    Caminho relativo ou absoluto para o arquivo de backlog em Markdown.
    Padrão: "meta-hub/backlog.md"
.PARAMETER ProjectNumber
    Número do projeto no GitHub Projects v2.
    Padrão: 14
.PARAMETER Owner
    Usuário ou organização proprietária do projeto no GitHub.
    Padrão: "heviane"
.PARAMETER CheckOnly
    Executa em modo de auditoria/dry-run, exibindo a tabela comparativa
    sem realizar alterações no GitHub Project.
.PARAMETER CreateMissing
    Cria os itens do backlog Markdown que ainda não existem no GitHub Project como Draft Issues.
.PARAMETER SyncStatus
    Atualiza o campo Status no GitHub Project para coincidir com o status do Markdown.
.PARAMETER SyncPriority
    Atualiza o campo Priority (P0, P1, P2) no GitHub Project para coincidir com o Markdown.
.PARAMETER NonInteractive
    Suprime prompts de confirmação interativos para execução em esteiras de CI/CD.
.EXAMPLE
    .\meta-hub\scripts\sync-project-backlog.ps1 -CheckOnly
    Audita as divergências entre o backlog.md e o Project 14 sem alterar dados.
.EXAMPLE
    .\meta-hub\scripts\sync-project-backlog.ps1 -SyncStatus -SyncPriority
    Sincroniza os status e prioridades dos cards existentes no Project 14.
.EXAMPLE
    .\meta-hub\scripts\sync-project-backlog.ps1 -CreateMissing -SyncStatus -SyncPriority
    Reconciliação total: adiciona itens ausentes e atualiza status e prioridades.
.NOTES
    Requisitos:
    - GitHub CLI (gh) v2.20+ instalado e autenticado (gh auth login).
    - Escopo 'project' habilitado no token do gh (gh auth refresh -s project).
    - Compatível nativamente com Windows PowerShell 5.1 e PowerShell 7+.
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$BacklogPath = "meta-hub/backlog.md",
    [int]$ProjectNumber = 14,
    [string]$Owner = "heviane",
    [switch]$CheckOnly,
    [switch]$CreateMissing,
    [switch]$SyncStatus,
    [switch]$SyncPriority,
    [switch]$NonInteractive
)

$ErrorActionPreference = "Stop"

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " 🔄 SINCRONIZAÇÃO DOCS-AS-CODE & GITHUB PROJECT 14 ($Owner)" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Validação de Pré-requisitos
if (-not (Test-Path $BacklogPath)) {
    throw "Arquivo de backlog não encontrado em: $BacklogPath"
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI ('gh') não foi encontrado no PATH. Instale a CLI oficial em https://cli.github.com/."
}

Write-Host "📋 Lendo e parseando o backlog: $BacklogPath..." -ForegroundColor Green
$backlogLines = Get-Content -Path $BacklogPath -Encoding UTF8

$parsedItems = @()
$epicRegex = '^###\s+(Épico\s+\d+:.*?)(?:—|$)'
$tableRowRegex = '^\|\s*(🟢|🟡|⚪|💡)\s*\|\s*[`]?([A-Z0-9]+-[0-9]+)[`]?\s*\|\s*[`]?(P[0-3])[`]?\s*\|\s*\*\*([^*]+)\*\*\s*\|\s*(.*?)\s*\|'

$currentEpic = "Geral"

foreach ($line in $backlogLines) {
    if ($line -match $epicRegex) {
        $currentEpic = $matches[1].Trim()
        continue
    }

    if ($line -match $tableRowRegex) {
        $statusEmoji = $matches[1].Trim()
        $itemId = $matches[2].Trim()
        $priority = $matches[3].Trim()
        $itemTitle = $matches[4].Trim()
        $itemDesc = $matches[5].Trim()

        # Mapeamento do Status Markdown -> GitHub Project 14
        $targetStatus = switch ($statusEmoji) {
            "🟢" { "Done" }
            "🟡" { "In progress" }
            "⚪" { "Backlog" }
            "💡" { "Backlog" }
            Default { "Backlog" }
        }

        # Mapeamento de Prioridade (P3 mapeia para P2 pois o Project 14 suporta P0, P1, P2)
        $targetPriority = switch ($priority) {
            "P0" { "P0" }
            "P1" { "P1" }
            "P2" { "P2" }
            "P3" { "P2" }
            Default { "P2" }
        }

        $parsedItems += [PSCustomObject]@{
            Epic           = $currentEpic
            StatusEmoji    = $statusEmoji
            TargetStatus   = $targetStatus
            ID             = $itemId
            Priority       = $priority
            TargetPriority = $targetPriority
            Title          = $itemTitle
            Description    = $itemDesc
        }
    }
}

Write-Host "  ✓ Encontrados $($parsedItems.Count) itens no backlog Markdown." -ForegroundColor Cyan

# 2. Obter Metadados e Itens do GitHub Project 14
Write-Host "`n🔍 Consultando itens e campos do GitHub Project $ProjectNumber (Owner: $Owner)..." -ForegroundColor Green

try {
    $projectListJson = gh project list --owner $Owner --format json | ConvertFrom-Json
    $targetProject = $projectListJson.projects | Where-Object { $_.number -eq $ProjectNumber }
    if (-not $targetProject) {
        throw "Projeto número $ProjectNumber não encontrado para o owner '$Owner'."
    }
    $projectId = $targetProject.id

    $fieldsJson = gh project field-list $ProjectNumber --owner $Owner --format json | ConvertFrom-Json
    $statusField = $fieldsJson.fields | Where-Object { $_.name -eq "Status" }
    $priorityField = $fieldsJson.fields | Where-Object { $_.name -eq "Priority" }

    $statusOptions = @{}
    if ($statusField -and $statusField.options) {
        foreach ($opt in $statusField.options) {
            $statusOptions[$opt.name.ToLower()] = $opt.id
        }
    }

    $priorityOptions = @{}
    if ($priorityField -and $priorityField.options) {
        foreach ($opt in $priorityField.options) {
            $priorityOptions[$opt.name.ToLower()] = $opt.id
        }
    }

    $itemsJson = gh project item-list $ProjectNumber --owner $Owner --limit 300 --format json | ConvertFrom-Json
    $existingItems = $itemsJson.items
    Write-Host "  ✓ Projeto localizado: '$($targetProject.title)' (ID: $projectId)" -ForegroundColor Cyan
    Write-Host "  ✓ $($existingItems.Count) cards/itens encontrados no GitHub Project." -ForegroundColor Cyan
} catch {
    Write-Warning "Falha ao consultar a API do GitHub Projects: $_"
    throw
}

# 3. Reconciliação (Auditoria)
Write-Host "`n⚖️ Reconciliando Backlog Markdown vs. GitHub Project 14..." -ForegroundColor Green

$auditResults = @()
$inSyncCount = 0
$statusDiffCount = 0
$priorityDiffCount = 0
$missingCount = 0

foreach ($pItem in $parsedItems) {
    # Busca por ID exato entre colchetes no título do card: [ID]
    $escapedId = [regex]::Escape($pItem.ID)
    $matchedCard = $existingItems | Where-Object { $_.title -match "\[$escapedId\]" }

    if ($matchedCard) {
        $cardStatus = if ($matchedCard.status) { $matchedCard.status } else { "N/A" }
        $cardPriority = if ($matchedCard.priority) { $matchedCard.priority } else { "N/A" }

        $statusDiff = ($cardStatus.ToLower() -ne $pItem.TargetStatus.ToLower())
        $priorityDiff = ($cardPriority.ToLower() -ne $pItem.TargetPriority.ToLower())

        $alignment = "OK"
        if ($statusDiff -and $priorityDiff) {
            $alignment = "Status & Prioridade Divergentes"
            $statusDiffCount++
            $priorityDiffCount++
        } elseif ($statusDiff) {
            $alignment = "Status Divergente"
            $statusDiffCount++
        } elseif ($priorityDiff) {
            $alignment = "Prioridade Divergente"
            $priorityDiffCount++
        } else {
            $inSyncCount++
        }

        $auditResults += [PSCustomObject]@{
            ID             = $pItem.ID
            MarkdownStatus = "$($pItem.StatusEmoji) ($($pItem.TargetStatus))"
            ProjectStatus  = $cardStatus
            MarkdownPrio   = $pItem.Priority
            ProjectPrio    = $cardPriority
            Alinhamento    = $alignment
            CardId         = $matchedCard.id
            CardTitle      = $matchedCard.title
            ExistsInProject= $true
            ParsedItem     = $pItem
        }
    } else {
        $missingCount++
        $auditResults += [PSCustomObject]@{
            ID             = $pItem.ID
            MarkdownStatus = "$($pItem.StatusEmoji) ($($pItem.TargetStatus))"
            ProjectStatus  = "[AUSENTE]"
            MarkdownPrio   = $pItem.Priority
            ProjectPrio    = "[AUSENTE]"
            Alinhamento    = "Ausente no Project"
            CardId         = $null
            CardTitle      = "[$($pItem.ID)] $($pItem.Title)"
            ExistsInProject= $false
            ParsedItem     = $pItem
        }
    }
}

# 4. Exibição do Diagnóstico
Write-Host ""
$divergences = $auditResults | Where-Object { $_.Alinhamento -ne "OK" }
if ($divergences.Count -eq 0) {
    Write-Host "✨ Perfeito! Todos os $($parsedItems.Count) itens do Backlog estão sincronizados com o Project 14!" -ForegroundColor Green
} else {
    Write-Host "⚠️ Foram encontradas $($divergences.Count) divergências entre o Markdown e o GitHub Project:" -ForegroundColor Yellow
    $divergences | Select-Object ID, Alinhamento, MarkdownStatus, ProjectStatus, MarkdownPrio, ProjectPrio | Format-Table -AutoSize
}

Write-Host "📊 RESUMO DA AUDITORIA:" -ForegroundColor White
Write-Host " - Total de Itens no Markdown : $($parsedItems.Count)"
Write-Host " - Itens Perfeitamente Alinhados: $inSyncCount ✅"
Write-Host " - Status com Divergência     : $statusDiffCount ⚠️"
Write-Host " - Prioridades com Divergência: $priorityDiffCount ⚠️"
Write-Host " - Itens Ausentes no Project  : $missingCount ⚪"

# 5. Execução de Mutações (se habilitado)
if ($CheckOnly) {
    Write-Host "`nℹ️ Modo -CheckOnly ativado: Nenhuma alteração foi realizada no GitHub Project." -ForegroundColor Cyan
    return
}

$needsAction = ($CreateMissing -and $missingCount -gt 0) -or ($SyncStatus -and $statusDiffCount -gt 0) -or ($SyncPriority -and $priorityDiffCount -gt 0)

if (-not $needsAction) {
    Write-Host "`n💡 Nenhuma ação de mutação foi solicitada ou necessária (use -CheckOnly, -CreateMissing, -SyncStatus ou -SyncPriority)." -ForegroundColor Yellow
    return
}

Write-Host "`n🚀 Executando ações de sincronização solicitadas..." -ForegroundColor Green

# 5.1. Criar Itens Ausentes
if ($CreateMissing) {
    $missingItems = $auditResults | Where-Object { -not $_.ExistsInProject }
    foreach ($m in $missingItems) {
        $p = $m.ParsedItem
        $newTitle = "[$($p.ID)] $($p.Title)"
        $newBody = "### 📌 Item do Backlog ($($p.ID))`n`n$($p.Description)`n`n*Origem: Docs-as-Code (`meta-hub/backlog.md`)*"

        Write-Host "  ➕ Criando Draft Issue: $newTitle..." -ForegroundColor Yellow
        try {
            $createdJson = gh project item-create $ProjectNumber --owner $Owner --title $newTitle --body $newBody --format json | ConvertFrom-Json
            $newCardId = $createdJson.id

            # Ajustar Status inicial
            $statusKey = $p.TargetStatus.ToLower()
            if ($statusField -and $statusOptions.ContainsKey($statusKey)) {
                $optId = $statusOptions[$statusKey]
                gh project item-edit --id $newCardId --project-id $projectId --field-id $statusField.id --single-select-option-id $optId | Out-Null
            }

            # Ajustar Prioridade inicial
            $prioKey = $p.TargetPriority.ToLower()
            if ($priorityField -and $priorityOptions.ContainsKey($prioKey)) {
                $optId = $priorityOptions[$prioKey]
                gh project item-edit --id $newCardId --project-id $projectId --field-id $priorityField.id --single-select-option-id $optId | Out-Null
            }

            Write-Host "     ✓ Item criado e configurado com sucesso (ID: $newCardId)." -ForegroundColor Cyan
        } catch {
            Write-Warning "     ❌ Falha ao criar item $($newTitle): $_"
        }
    }
}

# 5.2. Sincronizar Status de Itens Existentes
if ($SyncStatus) {
    $statusDiffs = $auditResults | Where-Object { $_.ExistsInProject -and $_.Alinhamento -match "Status" }
    foreach ($d in $statusDiffs) {
        $p = $d.ParsedItem
        $statusKey = $p.TargetStatus.ToLower()
        if ($statusField -and $statusOptions.ContainsKey($statusKey)) {
            $optId = $statusOptions[$statusKey]
            Write-Host "  🔄 Atualizando Status de [$($p.ID)]: '$($d.ProjectStatus)' -> '$($p.TargetStatus)'..." -ForegroundColor Yellow
            try {
                gh project item-edit --id $d.CardId --project-id $projectId --field-id $statusField.id --single-select-option-id $optId | Out-Null
                Write-Host "     ✓ Status atualizado com sucesso." -ForegroundColor Cyan
            } catch {
                Write-Warning "     ❌ Falha ao atualizar status de [$($p.ID)]: $_"
            }
        }
    }
}

# 5.3. Sincronizar Prioridade de Itens Existentes
if ($SyncPriority) {
    $prioDiffs = $auditResults | Where-Object { $_.ExistsInProject -and $_.Alinhamento -match "Prioridade" }
    foreach ($d in $prioDiffs) {
        $p = $d.ParsedItem
        $prioKey = $p.TargetPriority.ToLower()
        if ($priorityField -and $priorityOptions.ContainsKey($prioKey)) {
            $optId = $priorityOptions[$prioKey]
            Write-Host "  🔄 Atualizando Prioridade de [$($p.ID)]: '$($d.ProjectPrio)' -> '$($p.TargetPriority)'..." -ForegroundColor Yellow
            try {
                gh project item-edit --id $d.CardId --project-id $projectId --field-id $priorityField.id --single-select-option-id $optId | Out-Null
                Write-Host "     ✓ Prioridade atualizada com sucesso." -ForegroundColor Cyan
            } catch {
                Write-Warning "     ❌ Falha ao atualizar prioridade de [$($p.ID)]: $_"
            }
        }
    }
}

Write-Host "`n✅ Operação de sincronização concluída com sucesso!" -ForegroundColor Green
