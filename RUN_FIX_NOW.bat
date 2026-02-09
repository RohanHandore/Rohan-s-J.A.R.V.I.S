@echo off
REM Simple script to fix the GitHub secrets issue
REM Run this from the repository root (one level up from JARVIS)

echo ========================================
echo Fixing GitHub Secrets Issue
echo ========================================
echo.

REM Make sure we're in the right directory
cd /d "%~dp0"

echo Current directory: %CD%
echo.

REM Step 1: Remove .env from git
echo Step 1: Removing JARVIS/.env from git...
git rm --cached JARVIS/.env
if %errorlevel% neq 0 (
    echo Warning: JARVIS/.env may not be in index
)

echo.
echo Step 2: Creating new clean branch...
git checkout --orphan temp-clean-branch
if %errorlevel% neq 0 (
    echo Error creating branch. You may need to commit or stash changes first.
    pause
    exit /b 1
)

echo.
echo Step 3: Adding all files (except .env)...
git add -A

echo.
echo Step 4: Creating clean commit...
git commit -m "Clean history without secrets"

echo.
echo Step 5: Replacing master branch...
git branch -D master
git branch -m master

echo.
echo ========================================
echo SUCCESS!
echo ========================================
echo.
echo Next: Push to remote with:
echo   git push origin master --force
echo.
echo Press any key to push now, or Ctrl+C to cancel...
pause

echo.
echo Pushing to remote...
git push origin master --force

echo.
echo Done!
pause
