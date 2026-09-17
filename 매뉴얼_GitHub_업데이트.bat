@echo off
setlocal
cd /d "%~dp0"

echo ============================================
echo   B2B Manual - GitHub Update
echo ============================================
echo.

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo [ERROR] This folder is not a git repository.
    pause
    exit /b 1
)

echo Checking for changed files...
git add -A

git diff --cached --quiet
if %errorlevel%==0 (
    echo.
    echo No changes detected. Nothing to update.
    echo.
    pause
    exit /b 0
)

echo.
echo Changed files:
git diff --cached --name-status
echo.

set "commitmsg="
set /p commitmsg=Commit message (press Enter for default):
if "%commitmsg%"=="" set "commitmsg=Update manual %date% %time%"

git commit -m "%commitmsg%"
if errorlevel 1 (
    echo [ERROR] Commit failed.
    pause
    exit /b 1
)

echo.
echo Pushing to GitHub...
git push

if errorlevel 1 (
    echo.
    echo [ERROR] Push failed. Check your internet connection or GitHub login.
    pause
    exit /b 1
)

echo.
echo ============================================
echo   Done! Changes are on GitHub.
echo   https://nutrione-serena.github.io/b2b-admin-manual/
echo   (the live page may take 1-2 minutes to update)
echo ============================================
echo.
pause
