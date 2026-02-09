@echo off
setlocal enabledelayedexpansion

REM Navigate to repository root
cd /d "%~dp0"
cd ..

echo ========================================
echo Removing .env from Git History - V2
echo ========================================
echo.
echo Repository root: %CD%
echo.

REM Check if we're in a git repo
git rev-parse --git-dir >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Not in a git repository!
    echo Please run this from the repository root.
    pause
    exit /b 1
)

echo Step 1: Removing JARVIS/.env from git index...
git rm --cached JARVIS/.env 2>nul
if %errorlevel% equ 0 (
    echo   - JARVIS/.env removed from index
) else (
    echo   - JARVIS/.env not in index (may already be removed)
)

echo.
echo Step 2: Setting environment variable to suppress warning...
set FILTER_BRANCH_SQUELCH_WARNING=1

echo.
echo Step 3: Removing JARVIS/.env from all commits...
echo   This may take several minutes. Please wait...
echo.

git filter-branch --force --index-filter "git rm --cached --ignore-unmatch JARVIS/.env" --prune-empty --tag-name-filter cat -- --all

if %errorlevel% neq 0 (
    echo.
    echo ERROR: filter-branch failed!
    echo.
    echo Trying alternative method...
    echo.
    goto :alternative
)

echo.
echo Step 4: Cleaning up backup references...
for /f "tokens=*" %%a in ('git for-each-ref --format="%%(refname)" refs/original/ 2^>nul') do (
    git update-ref -d "%%a" 2>nul
)

echo.
echo Step 5: Pruning reflog and garbage collecting...
git reflog expire --expire=now --all 2>nul
git gc --prune=now --aggressive 2>nul

echo.
echo ========================================
echo SUCCESS! .env has been removed from history.
echo ========================================
echo.
echo Next step: Force push to remote
echo   git push origin master --force
echo.
goto :end

:alternative
echo.
echo ========================================
echo Alternative Solution
echo ========================================
echo.
echo Since filter-branch failed, you have two options:
echo.
echo Option 1: Use GitHub's secret unblock URLs (quick but less secure)
echo   Visit the URLs shown in the error message to allow the secrets
echo.
echo Option 2: Install git-filter-repo (recommended)
echo   1. Install Python: https://www.python.org/downloads/
echo   2. Install git-filter-repo: pip install git-filter-repo
echo   3. Run: git filter-repo --path JARVIS/.env --invert-paths
echo.
echo Option 3: Create a new branch without secrets
echo   1. git checkout --orphan new-master
echo   2. git add -A
echo   3. git commit -m "Initial commit without secrets"
echo   4. git branch -D master
echo   5. git branch -m master
echo   6. git push origin master --force
echo.

:end
pause
