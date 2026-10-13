[CmdletBinding()]
param(
    [string]$ProjectRoot = $PSScriptRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$utf8 = New-Object -TypeName System.Text.UTF8Encoding -ArgumentList $false
$root = (Resolve-Path -LiteralPath $ProjectRoot).Path.TrimEnd([char[]]@('\', '/'))
$rootPrefix = $root + [System.IO.Path]::DirectorySeparatorChar

# The complete patch data is embedded. No neighboring files are required.
$encodedPatch = 'ewogICJmaWxlcyI6IFsKICAgIHsKICAgICAgInBhdGgiOiAiZnJvbnRlbmQva2VkY28tY2VudHJhbC1lZm9ybS13b3JrZmxvdy5qcyIsCiAgICAgICJjaGFuZ2VzIjogWwogICAgICAgIHsKICAgICAgICAgICJvbGQiOiAiICAgIGlmIChzZWxlY3QuZGF0YXNldC5vcHRpb25zID09PSBtYXJrdXApIHJldHVybjtcbiAgICBjb25zdCB2YWx1ZSA9IHNlbGVjdC52YWx1ZTsiLAogICAgICAgICAgIm5ldyI6ICIgICAgLy8gQ29tcGFyZSB0aGUgbGl2ZSBvcHRpb25zOiB0aGUgUkUvVEUgcGFnZSBjYW4gYWxzbyB1cGRhdGUgdGhpcyBjb250cm9sLlxuICAgIC8vIFJlYnVpbGRpbmcgdW5jaGFuZ2VkIG9wdGlvbnMgcmV0cmlnZ2VycyB0aGUgZm9ybSBvYnNlcnZlciBhbmQgYmxvY2tzIGNsaWNrcy5cbiAgICBjb25zdCBleHBlY3RlZCA9IFt7IHZhbHVlOiAnJywgbGFiZWw6IHBsYWNlaG9sZGVyIH0sIC4uLm9wdGlvbnNdO1xuICAgIGlmIChzZWxlY3Qub3B0aW9ucy5sZW5ndGggPT09IGV4cGVjdGVkLmxlbmd0aCAmJiBleHBlY3RlZC5ldmVyeSgoaXRlbSwgaW5kZXgpID0+XG4gICAgICBzZWxlY3Qub3B0aW9uc1tpbmRleF0udmFsdWUgPT09IFN0cmluZyhpdGVtLnZhbHVlKSAmJlxuICAgICAgc2VsZWN0Lm9wdGlvbnNbaW5kZXhdLnRleHRDb250ZW50ID09PSBTdHJpbmcoaXRlbS5sYWJlbCkpKSByZXR1cm47XG4gICAgY29uc3QgdmFsdWUgPSBzZWxlY3QudmFsdWU7IiwKICAgICAgICAgICJleHBlY3RlZF9tYXRjaGVzIjogMQogICAgICAgIH0sCiAgICAgICAgewogICAgICAgICAgIm9sZCI6ICIgICAgICBpZiAoIXNjb3BlKSByZXR1cm47XG4gICAgICBsZXQgZ3JvdXAgPSBzY29wZS5xdWVyeVNlbGVjdG9yKCdbZGF0YS1yZS1yZWdpb24tZ3JvdXBdJyk7IiwKICAgICAgICAgICJuZXciOiAiICAgICAgaWYgKCFzY29wZSkgcmV0dXJuO1xuICAgICAgLy8gVGhlIGN1cnJlbnQgUkUvVEUgZm9ybSBhbHJlYWR5IG93bnMgdGhlc2UgdGhyZWUgcm91dGluZyBjb250cm9scy5cbiAgICAgIC8vIFJldXNlIHRoZW0gaW5zdGVhZCBvZiBhZGRpbmcgYW5vdGhlciBzZXQgd2l0aCBpZGVudGljYWwgZmllbGQgbmFtZXMuXG4gICAgICBjb25zdCBpbmxpbmVSZWdpb24gPSBzY29wZS5xdWVyeVNlbGVjdG9yKCdbZGF0YS1zZW5kLXJlZ2lvbi13cmFwXSBbZGF0YS1yZWNpcGllbnQtcmVnaW9uXScpO1xuICAgICAgaWYgKGlubGluZVJlZ2lvbiAmJiBzY29wZS5xdWVyeVNlbGVjdG9yKCdbZGF0YS1zZW5kLXBlcnNvbi13cmFwXSBbZGF0YS1yZWNpcGllbnQtcGVyc29uXScpICYmXG4gICAgICAgICAgc2NvcGUucXVlcnlTZWxlY3RvcignW2RhdGEtc2VuZC1zdGF0aW9uLXdyYXBdIFtkYXRhLXJlY2lwaWVudC1zdGF0aW9uXScpKSB7XG4gICAgICAgIGlubGluZVJlZ2lvbi5yZXF1aXJlZCA9IGlzUmVnaW9uYWxSRShzZWxlY3QudmFsdWUpO1xuICAgICAgICByZXR1cm47XG4gICAgICB9XG4gICAgICBsZXQgZ3JvdXAgPSBzY29wZS5xdWVyeVNlbGVjdG9yKCdbZGF0YS1yZS1yZWdpb24tZ3JvdXBdJyk7IiwKICAgICAgICAgICJleHBlY3RlZF9tYXRjaGVzIjogMQogICAgICAgIH0sCiAgICAgICAgewogICAgICAgICAgIm9sZCI6ICIgICAgICBzZWxlY3QuaW5uZXJIVE1MID0gJzxvcHRpb24gdmFsdWU9XCJcIj5TZWxlY3QgcmVjZWl2aW5nIHJlZ2lvbjwvb3B0aW9uPicgKyBhdmFpbGFibGVSZWdpb25zLm1hcChyZWdpb24gPT4gJzxvcHRpb24gdmFsdWU9XCInICsgZXNjKHJlZ2lvbi5pZCkgKyAnXCI+JyArIGVzYyhyZWdpb24ubmFtZSkgKyAnPC9vcHRpb24+Jykuam9pbignJyk7IiwKICAgICAgICAgICJuZXciOiAiICAgICAgc2V0T3B0aW9ucyhzZWxlY3QsIGF2YWlsYWJsZVJlZ2lvbnMubWFwKHJlZ2lvbiA9PiAoeyB2YWx1ZTogcmVnaW9uLmlkLCBsYWJlbDogcmVnaW9uLm5hbWUgfSkpLCAnU2VsZWN0IHJlY2VpdmluZyByZWdpb24nKTsiLAogICAgICAgICAgImV4cGVjdGVkX21hdGNoZXMiOiAxCiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAib2xkIjogIiAgICAgIHNlbGVjdC5pbm5lckhUTUwgPSAnPG9wdGlvbiB2YWx1ZT1cIlwiPkFsbCBwZXJzb25uZWwgaW4gc2VsZWN0ZWQgb2ZmaWNlPC9vcHRpb24+JyArIGVsaWdpYmxlLm1hcChwZXJzb24gPT4gJzxvcHRpb24gdmFsdWU9XCInICsgZXNjKHBlcnNvbi5pZCkgKyAnXCI+JyArIGVzYyhwZXJzb24uZnVsbF9uYW1lKSArICcgXHUyMDE0ICcgKyBlc2MoU3RyaW5nKHBlcnNvbi5wcmltYXJ5X3JvbGUgfHwgJycpLnJlcGxhY2UoL18vZywgJyAnKSkgKyAnPC9vcHRpb24+Jykuam9pbignJyk7IiwKICAgICAgICAgICJuZXciOiAiICAgICAgc2V0T3B0aW9ucyhzZWxlY3QsIGVsaWdpYmxlLm1hcChwZXJzb24gPT4gKHsgdmFsdWU6IHBlcnNvbi5pZCwgbGFiZWw6IHBlcnNvbi5mdWxsX25hbWUgKyAnIFx1MjAxNCAnICsgU3RyaW5nKHBlcnNvbi5wcmltYXJ5X3JvbGUgfHwgJycpLnJlcGxhY2UoL18vZywgJyAnKSB9KSksICdBbGwgcGVyc29ubmVsIGluIHNlbGVjdGVkIG9mZmljZScpOyIsCiAgICAgICAgICAiZXhwZWN0ZWRfbWF0Y2hlcyI6IDEKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICJvbGQiOiAiICAgICAgc2VsZWN0LmlubmVySFRNTCA9ICc8b3B0aW9uIHZhbHVlPVwiXCI+Tm8gc3BlY2lmaWMgZHV0eSBsb2NhdGlvbjwvb3B0aW9uPicgKyBzdGF0aW9ucy5tYXAoc3RhdGlvbiA9PiAnPG9wdGlvbiB2YWx1ZT1cIicgKyBlc2Moc3RhdGlvbikgKyAnXCI+JyArIGVzYyhzdGF0aW9uKSArICc8L29wdGlvbj4nKS5qb2luKCcnKTsiLAogICAgICAgICAgIm5ldyI6ICIgICAgICBzZXRPcHRpb25zKHNlbGVjdCwgc3RhdGlvbnMubWFwKHN0YXRpb24gPT4gKHsgdmFsdWU6IHN0YXRpb24sIGxhYmVsOiBzdGF0aW9uIH0pKSwgJ05vIHNwZWNpZmljIGR1dHkgbG9jYXRpb24nKTsiLAogICAgICAgICAgImV4cGVjdGVkX21hdGNoZXMiOiAxCiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAib2xkIjogIiAgICAgIHN0YXR1cy50ZXh0Q29udGVudCA9IHBlcnNvbm5lbC5sZW5ndGggPyBwZXJzb25uZWwubGVuZ3RoICsgJyBhY3RpdmUgcGVyc29ubmVsIGF2YWlsYWJsZSBpbiB0aGUgbG9jYWwgZGlyZWN0b3J5LicgOiAnTG9hZGluZyB0aGUgbG9jYWwgcGVyc29ubmVsIGRpcmVjdG9yeS4uLic7IiwKICAgICAgICAgICJuZXciOiAiICAgICAgY29uc3QgbWVzc2FnZSA9IHBlcnNvbm5lbC5sZW5ndGggPyBwZXJzb25uZWwubGVuZ3RoICsgJyBhY3RpdmUgcGVyc29ubmVsIGF2YWlsYWJsZSBpbiB0aGUgbG9jYWwgZGlyZWN0b3J5LicgOiAnTG9hZGluZyB0aGUgbG9jYWwgcGVyc29ubmVsIGRpcmVjdG9yeS4uLic7XG4gICAgICBpZiAoc3RhdHVzLnRleHRDb250ZW50ICE9PSBtZXNzYWdlKSBzdGF0dXMudGV4dENvbnRlbnQgPSBtZXNzYWdlOyIsCiAgICAgICAgICAiZXhwZWN0ZWRfbWF0Y2hlcyI6IDEKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICJvbGQiOiAiICAgIGNvbnN0IG9ic2VydmVyID0gbmV3IE11dGF0aW9uT2JzZXJ2ZXIoKCkgPT4geyBlbnN1cmVSZWNpcGllbnRPcHRpb25zKCk7IGVuc3VyZUZvcm1TZW5kQnV0dG9uKCk7IH0pO1xuICAgIG9ic2VydmVyLm9ic2VydmUoZG9jdW1lbnQuYm9keSwgeyBjaGlsZExpc3Q6IHRydWUsIHN1YnRyZWU6IHRydWUgfSk7IiwKICAgICAgICAgICJuZXciOiAiICAgIGxldCBlbmhhbmNlbWVudFF1ZXVlZCA9IGZhbHNlO1xuICAgIGNvbnN0IG9ic2VydmVGb3JtcyA9ICgpID0+IG9ic2VydmVyLm9ic2VydmUoZG9jdW1lbnQuYm9keSwgeyBjaGlsZExpc3Q6IHRydWUsIHN1YnRyZWU6IHRydWUgfSk7XG4gICAgY29uc3Qgb2JzZXJ2ZXIgPSBuZXcgTXV0YXRpb25PYnNlcnZlcigoKSA9PiB7XG4gICAgICBpZiAoZW5oYW5jZW1lbnRRdWV1ZWQpIHJldHVybjtcbiAgICAgIGVuaGFuY2VtZW50UXVldWVkID0gdHJ1ZTtcbiAgICAgIGdsb2JhbC5zZXRUaW1lb3V0KCgpID0+IHtcbiAgICAgICAgZW5oYW5jZW1lbnRRdWV1ZWQgPSBmYWxzZTtcbiAgICAgICAgLy8gRG8gbm90IG9ic2VydmUgbXV0YXRpb25zIHByb2R1Y2VkIGJ5IG91ciBvd24gc3luY2hyb25vdXMgZW5oYW5jZW1lbnQuXG4gICAgICAgIG9ic2VydmVyLmRpc2Nvbm5lY3QoKTtcbiAgICAgICAgdHJ5IHsgZW5zdXJlUmVjaXBpZW50T3B0aW9ucygpOyBlbnN1cmVGb3JtU2VuZEJ1dHRvbigpOyB9XG4gICAgICAgIGZpbmFsbHkgeyBvYnNlcnZlRm9ybXMoKTsgfVxuICAgICAgfSwgMCk7XG4gICAgfSk7XG4gICAgb2JzZXJ2ZUZvcm1zKCk7IiwKICAgICAgICAgICJleHBlY3RlZF9tYXRjaGVzIjogMQogICAgICAgIH0KICAgICAgXQogICAgfSwKICAgIHsKICAgICAgInBhdGgiOiAiZnJvbnRlbmQvcGFnZXMvb3BlcmF0aW9ucy1tYWludGVuYW5jZS9yZV90ZS5odG1sIiwKICAgICAgImNoYW5nZXMiOiBbCiAgICAgICAgewogICAgICAgICAgIm9sZCI6ICJ1cmwuc2VhcmNoUGFyYW1zLnNldCgncmV0ZVN0YXJ0dXAnLCcyMDI2MTAwMS12NCcpOyIsCiAgICAgICAgICAibmV3IjogInVybC5zZWFyY2hQYXJhbXMuc2V0KCdyZXRlU3RhcnR1cCcsJzIwMjYxMDAxLW1lbnUtdjEnKTsiLAogICAgICAgICAgImV4cGVjdGVkX21hdGNoZXMiOiAxCiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAib2xkIjogIjxzbWFsbD5WZXJzaW9uIDAxIE9jdCAyMDI2IFx1MDBiNyBzdGFydHVwIDQ8L3NtYWxsPiIsCiAgICAgICAgICAibmV3IjogIjxzbWFsbD5WZXJzaW9uIDAxIE9jdCAyMDI2IFx1MDBiNyBzdGFydHVwIDQgXHUwMGI3IG1lbnUgZml4IDE8L3NtYWxsPiIsCiAgICAgICAgICAiZXhwZWN0ZWRfbWF0Y2hlcyI6IDIKICAgICAgICB9CiAgICAgIF0KICAgIH0KICBdCn0='
$definitions = $utf8.GetString([System.Convert]::FromBase64String($encodedPatch)) | ConvertFrom-Json

function Get-ProjectPath([string]$RelativePath) {
    if ([System.IO.Path]::IsPathRooted($RelativePath)) {
        throw 'Patch targets must use relative paths inside the KEDCO project.'
    }
    $result = [System.IO.Path]::GetFullPath((Join-Path $root $RelativePath))
    if (-not $result.StartsWith($rootPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw 'Patch targets must remain inside the KEDCO project.'
    }
    return $result
}

$writes = New-Object System.Collections.Generic.List[object]
foreach ($definition in $definitions.files) {
    $target = Get-ProjectPath ([string]$definition.path)
    if (-not (Test-Path -LiteralPath $target -PathType Leaf)) {
        throw ('Required project file was not found: ' + $target + '. Use the project folder containing frontend and backend. No project files were changed.')
    }
    $raw = [System.IO.File]::ReadAllText($target, $utf8)
    $original = $raw.Replace("`r`n", "`n")
    $content = $original
    foreach ($change in $definition.changes) {
        $oldText = [string]$change.old
        $newText = [string]$change.new
        $expected = [int]$change.expected_matches
        $oldCount = [regex]::Matches($content, [regex]::Escape($oldText)).Count
        $newCount = [regex]::Matches($content, [regex]::Escape($newText)).Count
        if ($oldCount -eq $expected -and $newCount -eq 0) {
            $content = $content.Replace($oldText, $newText)
        } elseif ($oldCount -eq 0 -and $newCount -eq $expected) {
            # This fragment is already corrected.
        } else {
            throw ('The current file differs from the uploaded source: ' + $definition.path + '. No project files were changed. Supply this current file for a source-specific correction.')
        }
    }
    if ($content -ne $original) {
        if ($raw.Contains("`r`n")) { $content = $content.Replace("`n", "`r`n") }
        $writes.Add([pscustomobject]@{ Path = $target; Text = $content })
    }
}

if ($writes.Count -eq 0) {
    Write-Host 'The RE/TE menu correction is already installed.' -ForegroundColor Green
    exit 0
}

# Preflight finished. Back up every affected original before writing any file.
$backupRoot = Join-Path $root ('RETE-menu-fix-backup-' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
foreach ($write in $writes) {
    $relative = $write.Path.Substring($rootPrefix.Length)
    $backup = Join-Path $backupRoot $relative
    New-Item -ItemType Directory -Path (Split-Path -Parent $backup) -Force | Out-Null
    Copy-Item -LiteralPath $write.Path -Destination $backup
}

try {
    foreach ($write in $writes) {
        [System.IO.File]::WriteAllText($write.Path, $write.Text, $utf8)
        Write-Host ('Updated: ' + $write.Path.Substring($rootPrefix.Length)) -ForegroundColor Green
    }
} catch {
    foreach ($write in $writes) {
        $relative = $write.Path.Substring($rootPrefix.Length)
        Copy-Item -LiteralPath (Join-Path $backupRoot $relative) -Destination $write.Path -Force
    }
    throw
}

Write-Host ('Backup: ' + $backupRoot)
Write-Host 'RE/TE menu correction installed.' -ForegroundColor Green
Write-Host 'Restart KEDCO with your existing Stop/Start scripts, then press Ctrl+F5.'
