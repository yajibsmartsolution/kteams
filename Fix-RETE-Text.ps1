& {
    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'
    $kedcoRoot = (Get-Location).Path
    $kedcoPage = Join-Path $kedcoRoot 'frontend\pages\operations-maintenance\re_te.html'
    if (-not (Test-Path -LiteralPath $kedcoPage -PathType Leaf)) {
        throw 'Open PowerShell in your KEDCO project folder and run this code again.'
    }

    $kedcoUtf8 = New-Object System.Text.UTF8Encoding -ArgumentList $false, $true
    $kedcoHtml = [System.IO.File]::ReadAllText($kedcoPage, $kedcoUtf8)
    $kedcoOriginal = $kedcoHtml

    # Replace menu decorations; retain IDs, attributes and menu labels.
    $kedcoMenus = @{ dashboard = 'DB'; register = 'RE'; map = 'MAP'; forms = 'EF'; records = 'REC' }
    foreach ($kedcoKey in $kedcoMenus.Keys) {
        $kedcoPattern = '(data-view="' + $kedcoKey + '"[^>]*>\s*<span class="nav-icon">)[^<]*(</span>)'
        $kedcoHtml = [regex]::Replace($kedcoHtml, $kedcoPattern, '${1}' + $kedcoMenus[$kedcoKey] + '${2}')
    }

    # Form type IDs and names remain unchanged.
    $kedcoForms = @{ ppe = 'PPE'; toolbox = 'TBT'; risk = 'JHA'; sgapp = 'OF1'; sg = 'OF4'; trouble = 'TR'; requisition = 'REQ' }
    foreach ($kedcoKey in $kedcoForms.Keys) {
        $kedcoPattern = '(\{id:"' + $kedcoKey + '",name:"[^"]*",icon:")[^"]*(")'
        $kedcoHtml = [regex]::Replace($kedcoHtml, $kedcoPattern, '${1}' + $kedcoForms[$kedcoKey] + '${2}')
    }

    # Numeric Unicode codes keep this PowerShell code safe to paste or save.
    $kedcoBolt = [string][char]0x26A1
    $kedcoPen = [string][char]0x270D
    $kedcoUpload = [string][char]0x21E7
    $kedcoCamera = [char]::ConvertFromUtf32(0x1F4F7)
    $kedcoPrinter = [char]::ConvertFromUtf32(0x1F5A8)
    $kedcoTimes = [string][char]0x00D7
    $kedcoSend = [string][char]0x27A4
    $kedcoCheck = [string][char]0x2713

    $kedcoHtml = $kedcoHtml.Replace('content:"' + $kedcoBolt + '"', 'content:""')
    $kedcoHtml = $kedcoHtml.Replace('Tap ' + $kedcoPen + ' / upload / camera', 'Draw / Upload / Camera')
    $kedcoHtml = $kedcoHtml.Replace('>' + $kedcoPen + ' Draw</button>', '>Draw</button>')
    $kedcoHtml = $kedcoHtml.Replace('>' + $kedcoUpload + ' Upload</button>', '>Upload</button>')
    $kedcoHtml = $kedcoHtml.Replace('>' + $kedcoCamera + ' Camera</button>', '>Camera</button>')
    $kedcoHtml = $kedcoHtml.Replace('>' + $kedcoTimes + ' Clear</button>', '>Clear</button>')
    $kedcoHtml = $kedcoHtml.Replace($kedcoSend + ' Send Form', 'Send Form')
    $kedcoHtml = $kedcoHtml.Replace($kedcoCheck + ' EXACT GPS SAVED', 'EXACT GPS SAVED')
    $kedcoHtml = $kedcoHtml.Replace($kedcoPrinter + ' Print Readable Network Map', 'Print Readable Network Map')
    $kedcoHtml = [regex]::Replace($kedcoHtml, '(<button\b[^>]*\bid="mobileMenu"[^>]*>)[^<]*(</button>)', '${1}Menu${2}')
    $kedcoHtml = [regex]::Replace($kedcoHtml, '(<button\b[^>]*\bdata-sig-close[^>]*>)[^<]*(</button>)', '${1}Close${2}')

    $kedcoSignatureLabels = @{ 'data-sign-open' = 'Draw'; 'data-sign-upload' = 'Upload'; 'data-sign-camera' = 'Camera'; 'data-sign-clear' = 'Clear' }
    foreach ($kedcoKey in $kedcoSignatureLabels.Keys) {
        $kedcoPattern = '(\.e-signature\.compact-signature \[' + $kedcoKey + '\]:before\{content:")[^"]*("\})'
        $kedcoHtml = [regex]::Replace($kedcoHtml, $kedcoPattern, '${1}' + $kedcoSignatureLabels[$kedcoKey] + '${2}')
    }
    $kedcoHtml = $kedcoHtml.Replace(
        '.e-signature.compact-signature .e-signature-actions{grid-template-columns:repeat(4,1fr);gap:2px}',
        '.e-signature.compact-signature .e-signature-actions{grid-template-columns:repeat(2,minmax(0,1fr));gap:3px}'
    )

    # Fit short text labels in the existing icon and signature controls.
    if ($kedcoHtml -notmatch 'id="reteTextCleanStyles"') {
        if ([regex]::Matches($kedcoHtml, '</head>').Count -ne 1) {
            throw 'The page has an unexpected head section. No files were changed.'
        }
        $kedcoStyle = '<style id="reteTextCleanStyles">.nav-icon{font-size:10px;font-weight:900}.icon-box{font-size:11px;font-weight:900}.signature-head [data-sig-close]{min-width:54px;font-size:11px}.brand-mark:after,.form-logo:after{display:none}</style>'
        $kedcoHtml = $kedcoHtml.Replace('</head>', $kedcoStyle + [Environment]::NewLine + '</head>')
    }

    if ($kedcoHtml -eq $kedcoOriginal) {
        Write-Host 'The RE/TE text correction is already installed.' -ForegroundColor Green
        return
    }

    # Keep a backup and copy the completed UTF-8 file over the current page.
    $kedcoBackup = $kedcoPage + '.text-backup-' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff') + '.bak'
    $kedcoTemporary = $kedcoPage + '.' + [guid]::NewGuid().ToString('N') + '.tmp'
    Copy-Item -LiteralPath $kedcoPage -Destination $kedcoBackup
    try {
        [System.IO.File]::WriteAllText($kedcoTemporary, $kedcoHtml, $kedcoUtf8)
        [System.IO.File]::Copy($kedcoTemporary, $kedcoPage, $true)
    } finally {
        if (Test-Path -LiteralPath $kedcoTemporary) { Remove-Item -LiteralPath $kedcoTemporary -Force }
    }
    Write-Host ('Corrected: ' + $kedcoPage) -ForegroundColor Green
    Write-Host ('Backup: ' + $kedcoBackup)
    Write-Host 'Press Ctrl+F5 in your browser.' -ForegroundColor Cyan
}
