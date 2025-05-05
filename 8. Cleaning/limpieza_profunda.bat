@echo off
color 0A
title Limpieza profunda de Windows - by Renzo

:: Verifica permisos de administrador
fsutil dirty query %systemdrive% >nul 2>&1
if %errorLevel% NEQ 0 (
    echo.
    echo Ejecuta este script como ADMINISTRADOR.
    pause
    exit /b
)

echo ===============================
echo INICIANDO LIMPIEZA PROFUNDA...
echo ===============================
timeout /t 1 >nul

:: TEMPORALES DEL USUARIO
echo Limpiando archivos temporales del usuario...
takeown /f "%temp%" /r /d y >nul 2>&1
rd /s /q "%temp%" >nul 2>&1
mkdir "%temp%"

:: TEMPORALES DEL SISTEMA
echo Limpiando archivos temporales del sistema...
takeown /f "C:\Windows\Temp" /r /d y >nul 2>&1
rd /s /q "C:\Windows\Temp" >nul 2>&1
mkdir "C:\Windows\Temp"

:: PREFETCH
echo Limpiando Prefetch...
del /s /f /q C:\Windows\Prefetch\*.* >nul 2>&1

:: ARCHIVOS .LOG
echo Eliminando archivos .log (puede tardar)...
for /r %%G in (*.log) do del /f /q "%%G" >nul 2>&1

:: CACHE DE MINIATURAS (thumbcache)
echo Eliminando caché de miniaturas...
del /s /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1

:: CACHE DE ACTUALIZACIONES
echo Eliminando descargas de actualizaciones viejas...
del /s /f /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1

:: ARCHIVOS DE DIAGNÓSTICO
echo Eliminando archivos de diagnóstico...
del /s /f /q "C:\ProgramData\Microsoft\Diagnosis\*.xml" >nul 2>&1
del /s /f /q "C:\ProgramData\Microsoft\Diagnosis\*.log" >nul 2>&1

:: CACHE DE MICROSOFT STORE
echo Limpiando caché de Microsoft Store...
del /s /f /q "%LOCALAPPDATA%\Packages\Microsoft.WindowsStore_*\LocalCache\*" >nul 2>&1

:: CACHE DE EDGE
echo Limpiando caché de Edge...
del /s /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*" >nul 2>&1
del /s /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\*" >nul 2>&1

:: CACHE DE CHROME
echo Limpiando caché de Chrome...
del /s /f /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*" >nul 2>&1
del /s /f /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache\*" >nul 2>&1

:: ELIMINACIÓN SEGURA DE DRIVERS ANTIGUOS
echo Eliminando drivers obsoletos...
powershell -Command "Get-WmiObject Win32_PnPSignedDriver | Where-Object { $_.DriverProviderName -ne $null -and $_.DriverDate -lt (Get-Date).AddMonths(-6) } | ForEach-Object { pnputil /delete-driver $('oem' + $_.OEMINF.Split('\\')[-1]) /uninstall /force }" >nul 2>&1

echo ===============================
echo LIMPIEZA FINALIZADA CON ÉXITO.
echo Tu sistema está más liviano.
echo ===============================
pause
exit
