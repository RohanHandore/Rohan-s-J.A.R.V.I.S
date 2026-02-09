@echo off
echo ========================================
echo Removing .env from Git History
echo ========================================
echo.
echo WARNING: This will rewrite git history!
echo Make sure you have a backup of your repository.
echo.
pause

cd /d "%~dp0"

echo.
echo Step 1: Removing .env from git tracking (if tracked)...
git rm --cached JARVIS/.env 2>nul
git rm --cached .env 2>nul

echo.
echo Step 2: Removing .env from all commits in history...
echo This may take a few minutes...
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch JARVIS/.env" --prune-empty --tag-name-filter cat -- --all

echo.
echo Step 3: Cleaning up backup refs...
git for-each-ref --format="%%(refname)" refs/original/ | for /f "tokens=*" %%a in ('more') do @git update-ref -d "%%a"

echo.
echo Step 4: Pruning and garbage collecting...
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo.
echo ========================================
echo Done! Now you can push with:
echo   git push origin master --force
echo ========================================
echo.
echo IMPORTANT: Use --force only if you're sure no one else
echo has pulled these commits. If others have the repo,
echo coordinate with them first!
echo.
pause
