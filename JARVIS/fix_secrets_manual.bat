@echo off
REM This script provides manual steps to fix the secret issue
REM Run these commands one by one from the repository root

echo ========================================
echo Manual Steps to Remove .env from History
echo ========================================
echo.
echo IMPORTANT: Run these commands from the repository root
echo (one level up from JARVIS directory)
echo.
echo Step 1: Navigate to repository root
echo   cd ..
echo.
echo Step 2: Remove .env from git tracking
echo   git rm --cached JARVIS/.env
echo.
echo Step 3: Remove from history (choose ONE method):
echo.
echo   Method A - Using filter-branch:
echo   set FILTER_BRANCH_SQUELCH_WARNING=1
echo   git filter-branch --force --index-filter "git rm --cached --ignore-unmatch JARVIS/.env" --prune-empty --tag-name-filter cat -- --all
echo.
echo   Method B - Using BFG Repo-Cleaner (if installed):
echo   bfg --delete-files JARVIS/.env
echo.
echo Step 4: Clean up
echo   git for-each-ref --format="%%(refname)" refs/original/ | for /f "tokens=*" %%a in ('more') do @git update-ref -d "%%a"
echo   git reflog expire --expire=now --all
echo   git gc --prune=now --aggressive
echo.
echo Step 5: Force push
echo   git push origin master --force
echo.
echo ========================================
pause
