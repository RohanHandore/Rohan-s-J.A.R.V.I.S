# J.A.R.V.I.S Setup and Run Script
# This script creates a virtual environment, installs dependencies, and runs the server

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "J.A.R.V.I.S Setup and Run Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Navigate to JARVIS directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "[1/4] Checking Python installation..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "Found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Python is not installed or not in PATH!" -ForegroundColor Red
    Write-Host "Please install Python from https://www.python.org/" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[2/4] Creating virtual environment..." -ForegroundColor Yellow
if (Test-Path "venv") {
    Write-Host "Virtual environment already exists. Skipping creation." -ForegroundColor Green
} else {
    python -m venv venv
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to create virtual environment!" -ForegroundColor Red
        exit 1
    }
    Write-Host "Virtual environment created successfully!" -ForegroundColor Green
}

Write-Host ""
Write-Host "[3/4] Activating virtual environment and installing requirements..." -ForegroundColor Yellow

# Activate virtual environment
& ".\venv\Scripts\Activate.ps1"

# Upgrade pip first
Write-Host "Upgrading pip..." -ForegroundColor Cyan
python -m pip install --upgrade pip --quiet

# Install requirements
Write-Host "Installing requirements from requirements.txt..." -ForegroundColor Cyan
pip install -r requirements.txt

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to install requirements!" -ForegroundColor Red
    exit 1
}

Write-Host "All dependencies installed successfully!" -ForegroundColor Green

Write-Host ""
Write-Host "[4/4] Checking for .env file..." -ForegroundColor Yellow
if (Test-Path ".env") {
    Write-Host ".env file found!" -ForegroundColor Green
} else {
    Write-Host "WARNING: .env file not found!" -ForegroundColor Yellow
    Write-Host "The server may not work without GROQ_API_KEY set in .env" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting J.A.R.V.I.S server..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Server will be available at: http://localhost:8000" -ForegroundColor Green
Write-Host "API Documentation: http://localhost:8000/docs" -ForegroundColor Green
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Run the server
python run.py
