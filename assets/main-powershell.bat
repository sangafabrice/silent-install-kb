@Echo OFF

:Main
: 1=:save_copy_to_directory

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set program_data=
Call profile.init.bat powershell
Set app=Dir /B /S "%program_data%\pwsh.exe"
Set shim=%PROFILE_DRIVE_PATH%\pwsh.bat
Set resource=resource\powershell
Set config=%resource%\config.vbs
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-Github.bat ini\powershell.ini version link > Nul
%app% > Nul 2>&1 && Call compare-version-cli.bat "%version%" "%shim%" --version compare
If "%compare%"=="2" (
    Call download-install-msi-setup.bat "%version%" "%link%" ^
    "INSTALLFOLDER="%program_data%" ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1" "%~f1" > Nul
)
For /F "Tokens=*" %%P In ('%app%') Do (
    Call set-version-shim.bat "%%~fP" 1-3 > "%shim%"
    Call "%shim%" --version > auto-complete\pwsh
    Call %resource%\extend-verb.bat "%%~dpP"
    If EXIST %config% Cscript //B %config% "%%~fP"
)
EndLocal
PopD
GoTo :EOF