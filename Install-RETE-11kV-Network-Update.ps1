[CmdletBinding()]
param([string]$ProjectRoot = (Get-Location).Path)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$kedcoUtf8 = New-Object System.Text.UTF8Encoding -ArgumentList $false, $true
$kedcoRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path
$kedcoPage = Join-Path $kedcoRoot 'frontend\pages\operations-maintenance\re_te.html'
if (-not (Test-Path -LiteralPath $kedcoPage -PathType Leaf)) {
    throw ('The page was not found: ' + $kedcoPage + '. Run this installer from the KEDCO project folder.')
}

# Standalone update matched to the supplied re_te(2).html.
# Existing external scripts, form workflows and saved data remain in place.
$kedcoPayload = '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'
$kedcoMemory = New-Object System.IO.MemoryStream -ArgumentList (,[Convert]::FromBase64String($kedcoPayload))
$kedcoGzip = New-Object System.IO.Compression.GZipStream -ArgumentList $kedcoMemory, ([System.IO.Compression.CompressionMode]::Decompress)
$kedcoReader = New-Object System.IO.StreamReader -ArgumentList $kedcoGzip, $kedcoUtf8
try { $kedcoDefinitions = $kedcoReader.ReadToEnd() | ConvertFrom-Json }
finally { $kedcoReader.Dispose(); $kedcoMemory.Dispose() }

function Update-KedcoFragments([string]$Text, $Changes) {
    $kedcoIndex = 0
    foreach ($kedcoChange in $Changes) {
        $kedcoIndex++
        $kedcoOld = [string]$kedcoChange.old
        $kedcoNew = [string]$kedcoChange.new
        $kedcoExpected = [int]$kedcoChange.expected_matches
        $kedcoOldCount = [regex]::Matches($Text, [regex]::Escape($kedcoOld)).Count
        $kedcoNewCount = [regex]::Matches($Text, [regex]::Escape($kedcoNew)).Count
        $kedcoEmbedded = [regex]::Matches($kedcoNew, [regex]::Escape($kedcoOld)).Count * $kedcoExpected
        if ($kedcoNewCount -eq $kedcoExpected -and $kedcoOldCount -eq $kedcoEmbedded) {
            continue
        }
        if ($kedcoOldCount -ne $kedcoExpected -or $kedcoNewCount -ne 0) {
            throw ('Network update check ' + $kedcoIndex + ' did not match the attached re_te(2).html. No files were changed. Check that you are installing into the project containing that current page.')
        }
        $Text = $Text.Replace($kedcoOld, $kedcoNew)
    }
    return $Text
}

$kedcoRaw = [System.IO.File]::ReadAllText($kedcoPage, $kedcoUtf8)
$kedcoHtml = $kedcoRaw.Replace("`r`n", "`n")
if ($kedcoHtml.Contains('KEDCO_RETE_11KV_NETWORK_V1')) {
    foreach ($kedcoToken in @('id="nm11"', 'id="nm11Register"', 'function reteFeeder11Key(', 'window.KEDCO_RETE_11KV_NETWORK=')) {
        if (-not $kedcoHtml.Contains($kedcoToken)) {
            throw 'The existing 11 kV update is incomplete. No files were changed.'
        }
    }
    Write-Host 'The RE/TE 11 kV network update is already installed.' -ForegroundColor Green
    exit 0
}

# Validate every expected fragment before creating a backup or modifying files.
$kedcoHtml = Update-KedcoFragments $kedcoHtml $kedcoDefinitions.changes
foreach ($kedcoToken in @('id="nm11"', 'id="nm11Register"', 'function reteFeeder11Key(', 'window.KEDCO_RETE_11KV_NETWORK=')) {
    if ([regex]::Matches($kedcoHtml, [regex]::Escape($kedcoToken)).Count -ne 1) {
        throw ('The updated page failed validation: ' + $kedcoToken + '. No files were changed.')
    }
}
if ($kedcoRaw.Contains("`r`n")) { $kedcoHtml = $kedcoHtml.Replace("`n", "`r`n") }

$kedcoBackup = $kedcoPage + '.11kv-backup-' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff') + '-' + [guid]::NewGuid().ToString('N') + '.bak'
$kedcoTemp = $kedcoPage + '.' + [guid]::NewGuid().ToString('N') + '.tmp'
Copy-Item -LiteralPath $kedcoPage -Destination $kedcoBackup
$kedcoAttempted = $false
try {
    [System.IO.File]::WriteAllText($kedcoTemp, $kedcoHtml, $kedcoUtf8)
    $kedcoAttempted = $true
    # Explicit source and destination avoid the previous null backup-path error.
    [System.IO.File]::Copy($kedcoTemp, $kedcoPage, $true)
} catch {
    $kedcoInstallError = $_
    if ($kedcoAttempted) {
        try { [System.IO.File]::Copy($kedcoBackup, $kedcoPage, $true) }
        catch { Write-Warning ('Restore the original page from: ' + $kedcoBackup) }
    }
    throw $kedcoInstallError
} finally {
    if (Test-Path -LiteralPath $kedcoTemp) { Remove-Item -LiteralPath $kedcoTemp -Force }
}

Write-Host ('Updated: ' + $kedcoPage) -ForegroundColor Green
Write-Host ('Backup: ' + $kedcoBackup)
Write-Host 'The 11 kV feeder update is installed. Press Ctrl+F5 in your browser.' -ForegroundColor Cyan
Write-Host 'Gwaran Old/New have no recorded injection source and remain listed for confirmation.'
