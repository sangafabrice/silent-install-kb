@Echo OFF

:Main
: 1=:save_copy_to

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set program_data=
Call profile.init.bat git
Set app=%program_data%\cmd\git.exe
Set shim=%PROFILE_DRIVE_PATH%\git.bat
Set macro=%PROFILE_DRIVE_PATH%\doskey_git.macro
Set config=resource\git\config.vbs
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-Github.bat ini\git.ini version link > Nul
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%shim%" --version compare
If "%compare%"=="2" (
    TaskKill /IM git* /F > Nul 2>&1
    TaskKill /IM bash.exe /F > Nul 2>&1
    Call download-install-inno-setup.bat "%version%" "%link%" git "%program_data%" "%~f1" > Nul
)
If EXIST "%app%" (
    Call set-version-shim.bat "%app%" * > "%shim%"
    Call "%shim%" --version > auto-complete\git
    If EXIST %config% Cscript %config% //B
    If EXIST "%macro%" DosKey /MacroFile="%macro%"
)
EndLocal
PopD