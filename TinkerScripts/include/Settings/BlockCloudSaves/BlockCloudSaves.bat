@echo off

:: BatchGotAdmin | From superuser (Originally posted by Ben Gripka on stackoverflow)
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

REM The ascii art in cmd tutorials didn't teach me this >:(
REM Colored text looks bad, sry

netsh advfirewall firewall delete rule name="Disable GTA Online Cloud Saves" >nul
set /p=>NoSave.txt <nul
echo Block Cloud Saves Ready

if not exist NoSave.txt echo. > NoSave.txt
set "Val="

:Loop

set "Val="
set /p Val=<NoSave.txt

if "%Val%"=="Disable" (
	color 04
	netsh advfirewall firewall add rule name="Disable GTA Online Cloud Saves" dir=out remoteip=192.81.241.170,192.81.241.171,193.82.242.172 action=block enable=yes >nul
	set /p=Disabled>NoSave.txt <nul
	cls
	echo Cloud Saves Are Disabled! Your progress won't be saved.
	timeout /t 2 /nobreak >nul
	color 07
)

if "%Val%"=="Enable" (
	color 02
    netsh advfirewall firewall delete rule name="Disable GTA Online Cloud Saves" >nul
	set /p=Enabled>NoSave.txt <nul
	cls
	echo Cloud Saves Are Enabled! Your progress will be saved normally.
	timeout /t 2 /nobreak >nul
	color 07
)

if "%Val%"=="Close" (
	netsh advfirewall firewall delete rule name="Disable GTA Online Cloud Saves"
	set /p=Closed>"NoSave.txt" <nul
	exit
)

timeout /t 0 /nobreak >nul
goto Loop