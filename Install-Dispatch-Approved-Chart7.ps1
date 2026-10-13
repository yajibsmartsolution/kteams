[CmdletBinding()]
param(
    [string]$ProjectRoot = (Get-Location).Path,
    [string]$PagePath = 'frontend\pages\system-operations\dispatch.html'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$kedcoRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path
$kedcoPage = if ([System.IO.Path]::IsPathRooted($PagePath)) { $PagePath } else { Join-Path $kedcoRoot $PagePath }
if (-not (Test-Path -LiteralPath $kedcoPage -PathType Leaf)) {
    throw ('Dispatch page not found: ' + $kedcoPage + '. Run this installer in your KEDCO project folder, or specify -PagePath with the actual dispatch.html path.')
}
$kedcoUtf8 = New-Object System.Text.UTF8Encoding -ArgumentList $false, $true
$kedcoRaw = [System.IO.File]::ReadAllText($kedcoPage, $kedcoUtf8)
$kedcoHtml = $kedcoRaw.Replace("`r`n", "`n")
if (-not $kedcoHtml.Contains('data-kedco-eforms-page="dispatch"')) {
    throw 'The selected file is not the supplied Dispatch page. No files were changed.'
}

# Standalone payload: no ZIP extraction and no companion files are required.
$kedcoPayload = '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'
$kedcoMemory = New-Object System.IO.MemoryStream -ArgumentList (,[Convert]::FromBase64String($kedcoPayload))
$kedcoGzip = New-Object System.IO.Compression.GZipStream -ArgumentList $kedcoMemory, ([System.IO.Compression.CompressionMode]::Decompress)
$kedcoReader = New-Object System.IO.StreamReader -ArgumentList $kedcoGzip, $kedcoUtf8
try { $kedcoDefinitions = $kedcoReader.ReadToEnd() | ConvertFrom-Json }
finally { $kedcoReader.Dispose(); $kedcoMemory.Dispose() }

$kedcoInstalled = $kedcoHtml.Contains('id="kedcoDispatchApprovedChart7Script"')
if ($kedcoInstalled) {
    # Idempotence: also detect damaged or partially replaced installed fragments.
    foreach ($kedcoChange in $kedcoDefinitions.changes) {
        if ([regex]::Matches($kedcoHtml, [regex]::Escape([string]$kedcoChange.new)).Count -ne 1) {
            throw 'The installed chart update is incomplete or has been edited. No files were changed.'
        }
    }
    Write-Host 'The Dispatch hourly Chart 7 update is already installed.' -ForegroundColor Green
    exit 0
}

# Preflight ALL fragments before creating a backup or changing the page.
# Match only the chart container and closing tags, not a hash of the whole page.
foreach ($kedcoChange in $kedcoDefinitions.changes) {
    if ([regex]::Matches($kedcoHtml, [regex]::Escape([string]$kedcoChange.old)).Count -ne 1) {
        throw ('The current Dispatch chart section does not match the attached source: ' + [string]$kedcoChange.description + '. No files were changed.')
    }
}
foreach ($kedcoToken in @('id="hourlyChart"', 'id="dailyChart"', 'id="hourlyTotal"', 'id="dailyTotal"')) {
    if ([regex]::Matches($kedcoHtml, [regex]::Escape($kedcoToken)).Count -ne 1) {
        throw ('The existing Dispatch page has a missing or duplicate chart ID: ' + $kedcoToken + '. No files were changed.')
    }
}
foreach ($kedcoChange in $kedcoDefinitions.changes) {
    $kedcoHtml = $kedcoHtml.Replace([string]$kedcoChange.old, [string]$kedcoChange.new)
}
foreach ($kedcoToken in @('id="hourlyChart"', 'id="dailyChart"', 'id="hourlyTotal"', 'id="dailyTotal"', 'id="kedcoDispatchApprovedChart7Style"', 'id="kedcoDispatchApprovedChart7Script"')) {
    if ([regex]::Matches($kedcoHtml, [regex]::Escape($kedcoToken)).Count -ne 1) {
        throw ('The updated Dispatch page failed validation: ' + $kedcoToken + '. No files were changed.')
    }
}
if ($kedcoRaw.Contains("`r`n")) { $kedcoHtml = $kedcoHtml.Replace("`n", "`r`n") }

$kedcoBackup = $kedcoPage + '.chart7-backup-' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff') + '-' + [guid]::NewGuid().ToString('N') + '.bak'
$kedcoTemp = $kedcoPage + '.' + [guid]::NewGuid().ToString('N') + '.tmp'
Copy-Item -LiteralPath $kedcoPage -Destination $kedcoBackup
$kedcoAttempted = $false
try {
    [System.IO.File]::WriteAllText($kedcoTemp, $kedcoHtml, $kedcoUtf8)
    $kedcoAttempted = $true
    # Explicit paths avoid File.Replace(...,$null) failures in Windows PowerShell.
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
Write-Host 'Press Ctrl+F5 in your browser. A backend restart is not required.' -ForegroundColor Cyan
Write-Host 'Indigo = hourly total load; pale indigo = hourly KEDCO system allocation. Both charts use MW.'
