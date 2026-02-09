@echo off
cd /d "%~dp0"
echo Checking git status...
git status
echo.
echo Staging all changes...
git add -A
echo.
echo Checking if there are changes to commit...
git diff --cached --quiet
if %errorlevel% neq 0 (
    echo Changes detected. Committing...
    git commit -m "Update JARVIS project"
) else (
    echo No changes to commit. Working tree is clean.
)
echo.
echo Pushing to remote repository...
git push origin master
echo.
echo Done!
pause
