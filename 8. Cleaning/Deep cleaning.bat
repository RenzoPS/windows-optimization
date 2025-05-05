@echo off
color 0A
title Limpieza profunda de Windows - by Renzo

:: Verifica permisos de administrador
fsutil dirty query %systemdrive% >nul 2>&1
if %errorLevel% NEQ 0 (
    echo.
    echo Run as ADMIN.
    pause
    exit /b
)

echo ===============================
echo STARTING DEEP CLEANING...
echo ===============================
timeout /t 1 >nul

:: %TEMPS%
echo Cleaning %temp%...
takeown /f "%temp%" /r /d y >nul 2>&1
rd /s /q "%temp%" >nul 2>&1
mkdir "%temp%"

:: TEMPORALES DEL SISTEMA
echo Cleaning temp...
takeown /f "C:\Windows\Temp" /r /d y >nul 2>&1
rd /s /q "C:\Windows\Temp" >nul 2>&1
mkdir "C:\Windows\Temp"

:: PREFETCH
echo Cleaning prefetch...
del /s /f /q C:\Windows\Prefetch\*.* >nul 2>&1

echo Emptying the Recycle Bin...
powershell.exe -command "Clear-RecycleBin -Force"

:: ARCHIVOS .LOG
echo Cleaning .log files...
for /r %%G in (*.log) do del /f /q "%%G" >nul 2>&1

:: CACHE DE MINIATURAS (thumbcache)
echo Deleting thumbcache...
del /s /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1

:: CACHE DE ACTUALIZACIONES
echo Deleting old update downloads...
del /s /f /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1

:: ARCHIVOS DE DIAGNÓSTICO
echo Deleting diagnostic files...
del /s /f /q "C:\ProgramData\Microsoft\Diagnosis\*.xml" >nul 2>&1
del /s /f /q "C:\ProgramData\Microsoft\Diagnosis\*.log" >nul 2>&1

:: CACHE DE MICROSOFT STORE
echo Cleaning Microsoft store's cache...
del /s /f /q "%LOCALAPPDATA%\Packages\Microsoft.WindowsStore_*\LocalCache\*" >nul 2>&1

:: CACHE DE EDGE
echo Cleaning Edge's cache...
del /s /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*" >nul 2>&1
del /s /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\*" >nul 2>&1

:: CACHE DE CHROME
echo Cleaning Chrome's cache...
del /s /f /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*" >nul 2>&1
del /s /f /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache\*" >nul 2>&1

echo ===============================
echo CLEANING COMPLETED SUCCESSFULLY.
echo ===============================
pause
exit
