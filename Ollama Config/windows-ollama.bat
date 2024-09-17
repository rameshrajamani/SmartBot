@echo off
setlocal

REM Define variables
set OLLAMA_URL=https://www.ollama.com/download/OllamaSetup.exe
set OLLAMA_DIR=%USERPROFILE%\ollama
set OLLAMA_EXE=%OLLAMA_DIR%\ollama.exe
set TEXT_MODEL=phi3.5
set IMAGE_MODEL=moondream

REM Check for admin privileges
openfiles >nul 2>&1
if '%errorlevel%' neq '0' (
    echo Requesting admin privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

REM Create directory for Ollama
mkdir "%OLLAMA_DIR%"

REM Download Ollama
echo Downloading Ollama...
powershell -Command "Invoke-WebRequest -Uri %OLLAMA_URL% -OutFile %OLLAMA_DIR%\OllamaSetup.exe"

REM Install Ollama
echo Installing Ollama...
start /wait %OLLAMA_DIR%\OllamaSetup.exe /SILENT

REM Start Ollama service
echo Starting Ollama service...
start "" "%OLLAMA_EXE% serve"

REM Wait for the service to initialize
echo Waiting for Ollama service to start...
timeout /t 10 /nobreak >nul

REM Pull text model
echo Pulling text model %TEXT_MODEL%...
%OLLAMA_EXE% pull %TEXT_MODEL%

REM Confirm text model installation
echo Text model %TEXT_MODEL% pulled successfully!

REM Pull image model
echo Pulling image model %IMAGE_MODEL%...
%OLLAMA_EXE% pull %IMAGE_MODEL%

REM Confirm image model installation
echo Image model %IMAGE_MODEL% pulled successfully!

pause
