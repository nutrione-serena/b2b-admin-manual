$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

Write-Host "============================================"
Write-Host "  B2B Manual - GitHub Update"
Write-Host "============================================"
Write-Host ""

try {
    git rev-parse --is-inside-work-tree | Out-Null
} catch {
    Write-Host "[ERROR] This folder is not a git repository."
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Checking for changed files..."
git add -A | Out-Null

$staged = git diff --cached --name-only
if (-not $staged) {
    Write-Host ""
    Write-Host "No changes detected. Nothing to update."
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 0
}

Write-Host ""
Write-Host "Changed files:"
git diff --cached --name-status
Write-Host ""

# Stamp today's date into index.html's "최종 업데이트" line, only when there's
# an actual change to publish (so the date reflects the last real git update,
# not just whichever day someone happened to run this script).
$today = Get-Date -Format 'yyyy-MM-dd'
$indexPath = Join-Path $PSScriptRoot 'index.html'
if (Test-Path $indexPath) {
    $content = Get-Content -Raw -Encoding UTF8 $indexPath
    $updated = $content -replace '(최종\s*업데이트\s*:\s*)\d{4}-\d{2}-\d{2}', "`$1$today"
    if ($updated -ne $content) {
        [System.IO.File]::WriteAllText($indexPath, $updated, (New-Object System.Text.UTF8Encoding($false)))
        git add -- $indexPath | Out-Null
        Write-Host "Stamped index.html '최종 업데이트' date: $today"
        Write-Host ""
    }
}

$commitmsg = Read-Host "Commit message (press Enter for default)"
if ([string]::IsNullOrWhiteSpace($commitmsg)) {
    $commitmsg = "Update manual $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
}

git commit -m $commitmsg
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Commit failed."
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Pushing to GitHub..."
git push
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERROR] Push failed. Check your internet connection or GitHub login."
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "============================================"
Write-Host "  Done! Changes are on GitHub."
Write-Host "  https://nutrione-serena.github.io/b2b-admin-manual/"
Write-Host "  (the live page may take 1-2 minutes to update)"
Write-Host "============================================"
Write-Host ""
Read-Host "Press Enter to exit"
