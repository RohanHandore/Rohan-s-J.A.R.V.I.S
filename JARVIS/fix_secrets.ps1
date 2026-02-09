# PowerShell script to remove .env from git history
# Run this script from PowerShell: .\fix_secrets.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Removing .env from Git History" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Navigate to repository root
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath
Set-Location ..

Write-Host "Repository root: $(Get-Location)" -ForegroundColor Yellow
Write-Host ""

# Check if we're in a git repo
try {
    $null = git rev-parse --git-dir 2>&1
} catch {
    Write-Host "ERROR: Not in a git repository!" -ForegroundColor Red
    Write-Host "Please run this from the repository root." -ForegroundColor Red
    pause
    exit 1
}

Write-Host "Step 1: Removing JARVIS/.env from git index..." -ForegroundColor Green
git rm --cached JARVIS/.env 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "  - JARVIS/.env removed from index" -ForegroundColor Green
} else {
    Write-Host "  - JARVIS/.env not in index (may already be removed)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Step 2: Creating new orphan branch (clean history)..." -ForegroundColor Green
git checkout --orphan temp-clean-branch

Write-Host ""
Write-Host "Step 3: Removing .env from staging..." -ForegroundColor Green
git rm --cached JARVIS/.env 2>$null
git rm --cached .env 2>$null

Write-Host ""
Write-Host "Step 4: Adding all files except .env..." -ForegroundColor Green
git add -A

Write-Host ""
Write-Host "Step 5: Committing clean history..." -ForegroundColor Green
git commit -m "Clean history without secrets"

Write-Host ""
Write-Host "Step 6: Deleting old master branch..." -ForegroundColor Green
git branch -D master

Write-Host ""
Write-Host "Step 7: Renaming branch to master..." -ForegroundColor Green
git branch -m master

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SUCCESS! New clean branch created." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next step: Force push to remote" -ForegroundColor Yellow
Write-Host "  git push origin master --force" -ForegroundColor Yellow
Write-Host ""
Write-Host "IMPORTANT: " -ForegroundColor Red
Write-Host "- This will replace the remote master branch" -ForegroundColor Yellow
Write-Host "- Make sure you're the only one using this repo" -ForegroundColor Yellow
Write-Host "- Others will need to re-clone" -ForegroundColor Yellow
Write-Host ""
pause
