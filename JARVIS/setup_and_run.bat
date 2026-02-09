@echo off
REM J.A.R.V.I.S Setup and Run Script (Batch version)
REM This script creates a virtual environment, installs dependencies, and runs the server

echo ========================================
echo J.A.R.V.I.S Setup and Run Script
echo ========================================
echo.

cd /d "%~dp0"

echo [1/4] Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH!
    echo Please install Python from https://www.python.org/
    pause
    exit /b 1
)
python --version

echo.
echo [2/4] Creating virtual environment...
if exist "venv" (
    echo Virtual environment already exists. Skipping creation.
) else (
    python -m venv venv
    if errorlevel 1 (
        echo ERROR: Failed to create virtual environment!
        pause
        exit /b 1
    )
    echo Virtual environment created successfully!
)

echo.
echo [3/4] Activating virtual environment and installing requirements...

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Upgrade pip first
echo Upgrading pip...
python -m pip install --upgrade pip --quiet

REM Install requirements
echo Installing requirements from requirements.txt...
pip install -r requirements.txt

if errorlevel 1 (
    echo ERROR: Failed to install requirements!
    pause
    exit /b 1
)

echo All dependencies installed successfully!

echo.
echo [4/4] Checking for .env file...
if exist ".env" (
    echo .env file found!
) else (
    echo WARNING: .env file not found!
    echo The server may not work without GROQ_API_KEY set in .env
    echo.
)

echo.
echo ========================================
echo Starting J.A.R.V.I.S server...
echo ========================================
echo.
echo Server will be available at: http://localhost:8000
echo API Documentation: http://localhost:8000/docs
echo.
echo Press Ctrl+C to stop the server
echo.

REM Run the server
python run.py

pause
