@echo off
setlocal enabledelayedexpansion

rem Find the folder starting with ppr-modloader
for /d %%i in ("%~0\..\ppr-modloader*") do (
    set "modloader_folder=%%i"
    rem Only take the first match
    goto :found
)

:found
rem Check if the folder was found
if not defined modloader_folder (
    echo ppr-modloader folder not found.
    pause
    exit /b 1
)

rem Execute the PowerShell script
powershell -NoProfile -NoLogo -ExecutionPolicy Bypass -File "!modloader_folder!\Install-Modloader.ps1"
pause