@echo off
REM Simple solution: Create a new branch without secrets
REM This is safer and more reliable than rewriting history

cd /d "%~dp0"
cd ..

echo ========================================
echo Simple Fix: New Branch Without Secrets
echo ========================================
echo.
echo This will create a clean branch without .env in history.
echo.
pause

echo.
echo Step 1: Creating new orphan branch...
git checkout --orphan temp-clean-branch

echo.
echo Step 2: Removing .env from staging...
git rm --cached JARVIS/.env 2>nul
git rm --cached .env 2>nul

echo.
echo Step 3: Adding all files except .env...
git add -A

echo.
echo Step 4: Committing clean history...
git commit -m "Clean history without secrets"

echo.
echo Step 5: Deleting old master branch...
git branch -D master

echo.
echo Step 6: Renaming branch to master...
git branch -m master

echo.
echo ========================================
echo SUCCESS! New clean branch created.
echo ========================================
echo.
echo Next step: Force push to remote
echo   git push origin master --force
echo.
echo IMPORTANT: 
echo - This will replace the remote master branch
echo - Make sure you're the only one using this repo
echo - Others will need to re-clone
echo.
pause
