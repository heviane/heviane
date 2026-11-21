<#
.SYNOPSIS
    Sincroniza o inventário de extensões do VS Code com a documentação de governança (Docs-as-Code).
.DESCRIPTION
    Executa 'code --list-extensions --show-versions' para auditar e sincronizar o arquivo
    meta-hub/vscode-extensions.md, mantendo contagens, versões instaladas e snippets de reinstalação
    perfeitamente alinhados com o ambiente real de desenvolvimento.
.PARAMETER DocPath
    Caminho do arquivo Markdown de extensões. Padrão: ..\vscode-extensions.md
.PARAMETER CheckOnly
    Apenas valida se há divergências entre o VS Code e o documento (ideal para CI/Linters).
    Retorna código 1 se houver divergências e 0 se estiver 100% sincronizado.
.EXAMPLE
    .\sync-extensions.ps1
    .\sync-extensions.ps1 -CheckOnly
#>

[CmdletBinding()]
param (
    [string]$DocPath = "",
    [switch]$CheckOnly
)

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " 🔄 SINCRONIZAÇÃO DE EXTENSÕES DO VS CODE (Docs-as-Code)" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

if ([string]::IsNullOrWhiteSpace($DocPath)) {
    $DocPath = Join-Path $PSScriptRoot "..\vscode-extensions.md"
}

$resolvedDocPath = Resolve-Path $DocPath -ErrorAction SilentlyContinue
if (-not $resolvedDocPath) {
    Write-Error "Arquivo de documentação '$DocPath' não foi encontrado."
    exit 1
}
$docFullPath = $resolvedDocPath.Path

Write-Host "⏳ Consultando extensões instaladas no VS Code (code --list-extensions --show-versions)..." -ForegroundColor Yellow
$codeOutput = & code --list-extensions --show-versions 2>$null

if (-not $codeOutput) {
    Write-Error "Não foi possível executar 'code --list-extensions --show-versions'. Verifique se o executável 'code' está no PATH."
    exit 1
}

# 1. Parse das extensões instaladas
$installed = [System.Collections.Generic.Dictionary[string, PSCustomObject]]::new([System.StringComparer]::OrdinalIgnoreCase)
$rawInstalledList = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($line in $codeOutput) {
    $trimmed = $line.Trim()
    if ($trimmed -match '^([^@]+)@(.+)$') {
        $id = $Matches[1].Trim()
        $version = $Matches[2].Trim()
        $item = [PSCustomObject]@{
            Id      = $id
            Version = $version
        }
        $installed[$id] = $item
        $rawInstalledList.Add($item)
    }
}

$totalInstalled = $installed.Count
Write-Host "✅ Extensões detectadas no VS Code: $totalInstalled" -ForegroundColor Green
Write-Host ""

# 2. Ler conteúdo do documento
$docRaw = [System.IO.File]::ReadAllText($docFullPath, [System.Text.Encoding]::UTF8)

# Metadados de extensões conhecidas caso faltem no documento
$knownMetadata = @{
    "redhat.vscode-xml" = @{
        Name        = "XML (Red Hat)"
        Category    = "Qualidade de Código, Linters & Formatadores"
        Description = "Suporte à linguagem XML com validação de schemas XSD/DTD, formatação e autocompletar."
    }
}

# 3. Analisar divergências de IDs documentados
$docIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$idMatches = [regex]::Matches($docRaw, '\|\s*`([a-zA-Z0-9_\-\.]+)`\s*\|')
foreach ($m in $idMatches) {
    [void]$docIds.Add($m.Groups[1].Value)
}

$missingInDoc = [System.Collections.Generic.List[PSCustomObject]]::new()
foreach ($extId in $installed.Keys) {
    if (-not $docIds.Contains($extId)) {
        $missingInDoc.Add($installed[$extId])
    }
}

$orphanedInDoc = [System.Collections.Generic.List[string]]::new()
foreach ($docId in $docIds) {
    if (-not $installed.ContainsKey($docId)) {
        $orphanedInDoc.Add($docId)
    }
}

# Verificar divergências de versões nas tabelas
# Linha de categoria: | **Nome** | `id` | `versao` | Descrição |
# Linha alfabética:   | # | **Nome** | `id` | `versao` | Descrição |
$catRegex = [regex]'^\|\s*\*\*([^*]+)\*\*\s*\|\s*`([^`]+)`\s*\|\s*`([^`]+)`\s*\|\s*(.*?)\s*\|$'
$alphaRegex = [regex]'^\|\s*(\d+)\s*\|\s*\*\*([^*]+)\*\*\s*\|\s*`([^`]+)`\s*\|\s*`([^`]+)`\s*\|\s*(.*?)\s*\|$'

$lines = $docRaw -split '\r?\n'
$newLines = [System.Collections.Generic.List[string]]::new()
$versionUpdates = [System.Collections.Generic.List[PSCustomObject]]::new()
$updatedVersionsCount = 0
$bt = [char]96

foreach ($line in $lines) {
    $matched = $false
    
    $mAlpha = $alphaRegex.Match($line)
    if ($mAlpha.Success) {
        $matched = $true
        $num = $mAlpha.Groups[1].Value
        $name = $mAlpha.Groups[2].Value
        $id = $mAlpha.Groups[3].Value
        $docVersion = $mAlpha.Groups[4].Value
        $desc = $mAlpha.Groups[5].Value

        if ($installed.ContainsKey($id)) {
            $realVersion = $installed[$id].Version
            if ($docVersion -ne $realVersion) {
                $versionUpdates.Add([PSCustomObject]@{
                    Id         = $id
                    VersaoDoc  = $docVersion
                    VersaoReal = $realVersion
                })
                $updatedVersionsCount++
                $line = "| $num | **$name** | $bt$id$bt | $bt$realVersion$bt | $desc |"
            }
        }
    }

    if (-not $matched) {
        $mCat = $catRegex.Match($line)
        if ($mCat.Success) {
            $matched = $true
            $name = $mCat.Groups[1].Value
            $id = $mCat.Groups[2].Value
            $docVersion = $mCat.Groups[3].Value
            $desc = $mCat.Groups[4].Value

            if ($installed.ContainsKey($id)) {
                $realVersion = $installed[$id].Version
                if ($docVersion -ne $realVersion) {
                    $versionUpdates.Add([PSCustomObject]@{
                        Id         = $id
                        VersaoDoc  = $docVersion
                        VersaoReal = $realVersion
                    })
                    $updatedVersionsCount++
                    $line = "| **$name** | $bt$id$bt | $bt$realVersion$bt | $desc |"
                }
            }
        }
    }

    $newLines.Add($line)
}

# 4. Modo CheckOnly
if ($CheckOnly) {
    Write-Host "🔍 MODO DE VERIFICAÇÃO (-CheckOnly)" -ForegroundColor Cyan
    Write-Host " - Extensões no VS Code : $totalInstalled"
    Write-Host " - Extensões no Documento: $($docIds.Count)"
    Write-Host " - Extensões Ausentes no Documento: $($missingInDoc.Count)"
    Write-Host " - Versões Divergentes: $updatedVersionsCount"
    Write-Host " - Extensões no Documento Não Instaladas: $($orphanedInDoc.Count)"
    Write-Host ""

    if ($missingInDoc.Count -gt 0 -or $updatedVersionsCount -gt 0 -or $orphanedInDoc.Count -gt 0) {
        Write-Host "⚠️ Divergências detectadas no inventário de extensões!" -ForegroundColor Yellow
        if ($missingInDoc.Count -gt 0) {
            Write-Host "  Ausentes no documento:" -ForegroundColor Red
            foreach ($m in $missingInDoc) { Write-Host "   + $($m.Id)@$($m.Version)" -ForegroundColor Red }
        }
        if ($updatedVersionsCount -gt 0) {
            Write-Host "  Versões desatualizadas:" -ForegroundColor Yellow
            foreach ($u in $versionUpdates | Select-Object -Unique -Property Id, VersaoDoc, VersaoReal) {
                Write-Host "   * $($u.Id): $($u.VersaoDoc) -> $($u.VersaoReal)" -ForegroundColor Yellow
            }
        }
        exit 1
    } else {
        Write-Host "✨ O documento está 100% sincronizado com as extensões ativas do VS Code!" -ForegroundColor Green
        exit 0
    }
}

# 5. Modo Sincronização / Atualização
Write-Host "⚡ Sincronizando documento com as versões e extensões ativas..." -ForegroundColor Yellow

# Atualizar total de extensões no cabeçalho
for ($i = 0; $i -lt $newLines.Count; $i++) {
    if ($newLines[$i] -match '^> \*\*Total de extensões ativas:\*\* \d+') {
        $newLines[$i] = "> **Total de extensões ativas:** $totalInstalled"
        break
    }
}

$currentText = $newLines -join "`n"

# Inserir extensões ausentes conhecidas na categoria adequada
if ($missingInDoc.Count -gt 0) {
    foreach ($missing in $missingInDoc) {
        $extId = $missing.Id
        $extVersion = $missing.Version
        if ($knownMetadata.ContainsKey($extId)) {
            $meta = $knownMetadata[$extId]
            $categoryHeader = "## 🔍 Qualidade de Código, Linters & Formatadores"
            $targetRow = "| **$($meta.Name)** | $bt$extId$bt | $bt$extVersion$bt | $($meta.Description) |"
            
            $catIndex = $currentText.IndexOf($categoryHeader)
            if ($catIndex -ge 0) {
                $dividerIndex = $currentText.IndexOf("---", $catIndex)
                if ($dividerIndex -ge 0) {
                    $sub = $currentText.Substring(0, $dividerIndex).TrimEnd()
                    $currentText = $sub + "`n" + $targetRow + "`n`n" + $currentText.Substring($dividerIndex)
                    Write-Host "➕ Extensão adicionada à categoria '$($meta.Category)': $extId" -ForegroundColor Green
                }
            }
        } else {
            Write-Host "⚠️ Extensão sem metadados automáticos: $extId. Adicionando com metadados padrão." -ForegroundColor Yellow
        }
    }
}

# Extrair todas as extensões documentadas nas tabelas de categoria para reconstruir lista alfabética
$allExtEntries = [System.Collections.Generic.Dictionary[string, PSCustomObject]]::new([System.StringComparer]::OrdinalIgnoreCase)

$catTableScanRegex = [regex]'\| \*\*([^*]+)\*\* \| `([^`]+)` \| `([^`]+)` \| (.*?) \|'
foreach ($match in $catTableScanRegex.Matches($currentText)) {
    $name = $match.Groups[1].Value.Trim()
    $id = $match.Groups[2].Value.Trim()
    $version = if ($installed.ContainsKey($id)) { $installed[$id].Version } else { $match.Groups[3].Value.Trim() }
    $desc = $match.Groups[4].Value.Trim()

    if (-not $allExtEntries.ContainsKey($id) -and $installed.ContainsKey($id)) {
        $allExtEntries[$id] = [PSCustomObject]@{
            Name        = $name
            Id          = $id
            Version     = $version
            Description = $desc
        }
    }
}

# Fallback para extensões instaladas que não estejam nas categorias
foreach ($inst in $rawInstalledList) {
    if (-not $allExtEntries.ContainsKey($inst.Id)) {
        $allExtEntries[$inst.Id] = [PSCustomObject]@{
            Name        = $inst.Id
            Id          = $inst.Id
            Version     = $inst.Version
            Description = "Extensão instalada no VS Code."
        }
    }
}

# Ordenar alfabeticamente pelo nome da extensão
$sortedExtensions = $allExtEntries.Values | Sort-Object -Property Name

# Construir tabela alfabética
$alphaTableLines = [System.Collections.Generic.List[string]]::new()
$alphaTableLines.Add("## 📋 Lista Completa em Ordem Alfabética")
$alphaTableLines.Add("")
$alphaTableLines.Add("| # | Extensão | ID | Versão | Propósito / Descrição |")
$alphaTableLines.Add("| :--- | :--- | :--- | :--- | :--- |")

$count = 1
foreach ($ext in $sortedExtensions) {
    $alphaTableLines.Add("| $count | **$($ext.Name)** | $bt$($ext.Id)$bt | $bt$($ext.Version)$bt | $($ext.Description) |")
    $count++
}

# Construir bloco do script de reinstalação
$scriptBlockLines = [System.Collections.Generic.List[string]]::new()
$scriptBlockLines.Add("## 💾 Script para Reinstalação em Lote")
$scriptBlockLines.Add("")
$scriptBlockLines.Add("Caso precise reinstalar ou replicar o ambiente atual em outra máquina, copie e execute o script abaixo no PowerShell:")
$scriptBlockLines.Add("")
$scriptBlockLines.Add('```powershell')
$scriptBlockLines.Add('$extensions = @(')

$sortedById = $installed.Keys | Sort-Object
for ($i = 0; $i -lt $sortedById.Count; $i++) {
    $comma = if ($i -lt ($sortedById.Count - 1)) { "," } else { "" }
    $scriptBlockLines.Add("    `"$($sortedById[$i])`"$comma")
}

$scriptBlockLines.Add(')')
$scriptBlockLines.Add('')
$scriptBlockLines.Add('foreach ($ext in $extensions) {')
$scriptBlockLines.Add('    Write-Host "Instalando $ext..."')
$scriptBlockLines.Add('    code --install-extension $ext')
$scriptBlockLines.Add('}')
$scriptBlockLines.Add('```')

# Substituir seções alfabética e script no documento
$alphaHeader = "## 📋 Lista Completa em Ordem Alfabética"
$alphaIndex = $currentText.IndexOf($alphaHeader)
if ($alphaIndex -ge 0) {
    $beforeAlpha = $currentText.Substring(0, $alphaIndex).TrimEnd()
    $fullRebuilt = $beforeAlpha + "`n`n" + ($alphaTableLines -join "`n") + "`n`n---`n`n" + ($scriptBlockLines -join "`n") + "`n"
    $currentText = $fullRebuilt
}

# Salvar arquivo com UTF-8 sem BOM duplo
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($docFullPath, $currentText.Replace("`r`n", "`n").Replace("`n", "`r`n"), $utf8NoBom)

Write-Host "=================================================================" -ForegroundColor Green
Write-Host " 🎉 SINCRONIZAÇÃO CONCLUÍDA COM SUCESSO!" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host " - Total de extensões catalogadas : $($sortedExtensions.Count)" -ForegroundColor Cyan
Write-Host " - Versões atualizadas no arquivo : $updatedVersionsCount" -ForegroundColor Cyan
Write-Host " - Novas extensões adicionadas    : $($missingInDoc.Count)" -ForegroundColor Cyan
Write-Host " - Arquivo atualizado             : $docFullPath" -ForegroundColor DarkGray
Write-Host ""
