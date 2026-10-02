@echo off
setlocal EnableExtensions

REM ============================================================
REM TFG / Questa ADMS diagnostic collector
REM Coloca este .bat y tfg_questa_diagnostico_remote.sh juntos.
REM Cambia SSH_HOST si "JOSE" no resuelve desde Windows.
REM ============================================================

set "SSH_USER=jalberic"
set "SSH_HOST=JOSE"
set "PROJECT=/home/jalberic/proyectos/TFG"
set "OUT=TFG_Questa_ADMS_diagnostico.txt"
set "SCRIPT=%~dp0tfg_questa_diagnostico_remote.sh"

if not exist "%SCRIPT%" (
    echo ERROR: No encuentro "%SCRIPT%"
    pause
    exit /b 1
)

echo Generando diagnostico...
echo Destino SSH: %SSH_USER%@%SSH_HOST%
echo Proyecto: %PROJECT%
echo Salida: %CD%\%OUT%
echo.

> "%OUT%" echo TFG - Diagnostico Questa / ADMS / Sample Hold
>> "%OUT%" echo Fecha Windows: %DATE% %TIME%
>> "%OUT%" echo SSH: %SSH_USER%@%SSH_HOST%
>> "%OUT%" echo Proyecto: %PROJECT%
>> "%OUT%" echo.

type "%SCRIPT%" | ssh %SSH_USER%@%SSH_HOST% "PROJECT='%PROJECT%' bash -s" >> "%OUT%" 2>&1

echo.
if errorlevel 1 (
    echo El comando SSH devolvio un error. Revisa igualmente "%OUT%".
) else (
    echo Diagnostico completado correctamente.
)
echo.
echo Pasame este archivo:
echo %CD%\%OUT%
echo.
pause
