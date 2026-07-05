@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM =====================================
REM Bookshop Project Setup
REM =====================================

REM Always run from THIS script's directory
cd /d "%~dp0"

set LOGFILE=setuplog.txt

echo ===============================
echo   Bookshop Project Setup
echo ===============================
echo.

echo ===============================>> "%LOGFILE%"
echo   Bookshop Project Setup       >> "%LOGFILE%"
echo ===============================>> "%LOGFILE%"
echo.>> "%LOGFILE%"

REM ---- Sanity check ----
echo Current directory:
cd
echo Current directory:>> "%LOGFILE%"
cd >> "%LOGFILE%"
echo.>> "%LOGFILE%"

REM ---- Install dependencies ----
if not exist "requirements.txt" (
    echo ERROR: requirements.txt not found.
    echo ERROR: requirements.txt not found.>> "%LOGFILE%"
    exit /b 1
)

echo Installing Python dependencies...
echo Installing Python dependencies...>> "%LOGFILE%"

python -m pip install --user -r requirements.txt >> "%LOGFILE%" 2>&1
if errorlevel 1 (
    echo ERROR: pip install failed.
    echo ERROR: pip install failed.>> "%LOGFILE%"
    exit /b 1
)

echo.>> "%LOGFILE%"

echo Database configuration (press Enter for defaults):
echo Database configuration started.>> "%LOGFILE%"

REM ---- User input (NOT logged) ----
set /p DB_HOST=DB_HOST [localhost]:
if "%DB_HOST%"=="" set DB_HOST=localhost

set /p DB_PORT=DB_PORT [3306]:
if "%DB_PORT%"=="" set DB_PORT=3306

set /p DB_USER=DB_USER [root]:
if "%DB_USER%"=="" set DB_USER=root

set /p DB_PASS=DB_PASS []:

set /p DB_NAME=DB_NAME [bookshop_db]:
if "%DB_NAME%"=="" set DB_NAME=bookshop_db

REM ---- Write .env ----
echo Writing .env file...
echo Writing .env file...>> "%LOGFILE%"

(
    echo DB_HOST=%DB_HOST%
    echo DB_PORT=%DB_PORT%
    echo DB_USER=%DB_USER%
    echo DB_PASS=%DB_PASS%
    echo DB_NAME=%DB_NAME%
) > .env

echo .env file written.>> "%LOGFILE%"

REM ---- SQL file check ----
set SQL_FILE=%~dp0backend\database\init_database.sql

echo Checking SQL file:
echo Checking SQL file:>> "%LOGFILE%"
echo %SQL_FILE%
echo %SQL_FILE%>> "%LOGFILE%"

if not exist "%SQL_FILE%" (
    echo ERROR: SQL file not found at %SQL_FILE%.
    echo ERROR: SQL file not found at %SQL_FILE%.>> "%LOGFILE%"
    exit /b 1
)

REM ---- Import database using MySQL CLI ----
echo Importing database using MySQL...
echo Importing database using MySQL...>> "%LOGFILE%"

REM Use password only if provided
if "%DB_PASS%"=="" (
    mysql -h %DB_HOST% -P %DB_PORT% -u %DB_USER% < "%SQL_FILE%" >> "%LOGFILE%" 2>&1
) else (
    mysql -h %DB_HOST% -P %DB_PORT% -u %DB_USER% -p%DB_PASS% < "%SQL_FILE%" >> "%LOGFILE%" 2>&1
)

if errorlevel 1 (
    echo ERROR: Database import failed.
    echo ERROR: Database import failed.>> "%LOGFILE%"
    exit /b 1
)

echo.
echo Database verified or created.
echo Database verified or created.>> "%LOGFILE%"

echo Setup completed successfully.
echo Setup completed successfully.>> "%LOGFILE%"

exit /b 0
