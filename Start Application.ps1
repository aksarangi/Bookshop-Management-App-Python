<#
.SYNOPSIS
Bookshop Project Launcher

.AUTHOR
Abheek Kumar Sarangi

.DESCRIPTION
- Runs setup.cmd once (one-time install enforced)
- Deletes setup.cmd and requirements.txt intentionally
- setup.cmd handles its own logging and user prompts
- Launches the Python application
- Compatible with Windows PowerShell 5.1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# -----------------------------
# Paths (always relative)
# -----------------------------
$rootDir     = $PSScriptRoot
$setupPath   = Join-Path $rootDir "setup.cmd"
$setupLog   = Join-Path $rootDir "setuplog.txt"
$reqPath     = Join-Path $rootDir "requirements.txt"
$pythonMain  = Join-Path $rootDir "main.py"

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "      Bookshop Project Launcher        " -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# -----------------------------
# Step 1: First-time setup
# -----------------------------
if (Test-Path $setupPath) {

    Write-Host "First-time setup detected." -ForegroundColor Yellow
    Write-Host "Running setup.cmd..." -ForegroundColor Yellow
    Write-Host ""

    $process = Start-Process `
        -FilePath "cmd.exe" `
        -ArgumentList "/c `"$setupPath`"" `
        -WorkingDirectory $rootDir `
        -Wait `
        -PassThru

    if ($process.ExitCode -ne 0) {
        Write-Host ""
        Write-Host "ERROR: Setup failed (exit code $($process.ExitCode))" -ForegroundColor Red
        Write-Host "Please check setup.log for details." -ForegroundColor Red
        exit $process.ExitCode
    }

    Write-Host ""
    Write-Host "Setup completed successfully." -ForegroundColor Green

    # -----------------------------
    # One-time install cleanup (INTENTIONAL)
    # -----------------------------
    try {
        Remove-Item -Path $setupPath -Force
        Write-Host "setup.cmd deleted (one-time install enforced)." -ForegroundColor Green
        Remove-Item -Path $setupLog -Force
        Write-Host "setuplog deleted." -ForegroundColor Green

        if (Test-Path $reqPath) {
            Remove-Item -Path $reqPath -Force
            Write-Host "requirements.txt deleted." -ForegroundColor Green
        }
    }
    catch {
        Write-Host "WARNING: Cleanup failed. Please remove files manually." -ForegroundColor Yellow
    }

} else {
    Write-Host "Ensured Application is Installed, Skipping Installation." -ForegroundColor Cyan
}

# -----------------------------
# Step 2: Launch Python application
# -----------------------------
if (-not (Test-Path $pythonMain)) {
    Write-Host "ERROR: main.py not found in $rootDir" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Launching Bookshop application..." -ForegroundColor Cyan

$pythonProcess = Start-Process `
    -FilePath "py" `
    -ArgumentList "-3 `"$pythonMain`"" `
    -WorkingDirectory $rootDir `
    -Wait `
    -PassThru

if ($pythonProcess.ExitCode -ne 0) {
    Write-Host ""
    Write-Host "Python application exited with code $($pythonProcess.ExitCode)" -ForegroundColor Red
    exit $pythonProcess.ExitCode
}

Write-Host ""
Write-Host "Application closed." -ForegroundColor Cyan
exit 0
