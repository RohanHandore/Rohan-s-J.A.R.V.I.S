@echo off
REM Change to the script's directory (JARVIS)
cd /d "%~dp0"
REM Go up one level to the git repository root
cd ..

echo ========================================
echo Removing .env from Git History
echo ========================================
echo.
echo This script will:
echo 1. Remove .env from git tracking
echo 2. Remove .env from all commits in history
echo 3. Clean up git references
echo.
echo WARNING: This rewrites git history!
echo You will need to force push after this.
echo.
echo Current directory: %CD%
echo.
pause

echo.
echo Step 1: Removing .env from current index...
git rm --cached JARVIS/.env 2>nul
if %errorlevel% neq 0 (
    echo JARVIS/.env not found in index, trying .env...
    git rm --cached .env 2>nul
)

echo.
echo Step 2: Removing .env from all commits...
echo This may take a few minutes...
set FILTER_BRANCH_SQUELCH_WARNING=1
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch JARVIS/.env .env" --prune-empty --tag-name-filter cat -- --all

if %errorlevel% neq 0 (
    echo.
    echo ERROR: filter-branch failed. You may need to install git-filter-repo instead.
    echo Or try the alternative method using GitHub's secret unblock URLs.
    pause
    exit /b 1
)

echo.
echo Step 3: Cleaning up backup references...
for /f "tokens=*" %%a in ('git for-each-ref --format="%%(refname)" refs/original/') do @git update-ref -d "%%a" 2>nul

echo.
echo Step 4: Pruning reflog and garbage collecting...
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo.
echo ========================================
echo SUCCESS! .env has been removed from history.
echo ========================================
echo.
echo Next steps:
echo 1. Run: git push origin master --force
echo.
echo IMPORTANT: 
echo - Only use --force if you're the only one using this repo
echo - If others have cloned it, coordinate with them first
echo - They will need to re-clone or reset their local repos
echo.
pause
