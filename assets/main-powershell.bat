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
Set config=resource\powershell\config.vbs
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
    Call :extend-pwsh-verb "%%~dpP"
    If EXIST %config% Cscript //B %config% "%%~fP"
)
EndLocal
PopD
GoTo :EOF

:extend-pwsh-verb
    Set versionneddirname=%~1
    For /F "Tokens=*" %%V In ("%versionneddirname:~0,-1%") Do (
        For %%D In (
            HKCR\Drive\shell\PowerShell%%~nxVx64
            HKCR\Directory\Shell\PowerShell%%~nxVx64
            HKCR\Directory\Background\Shell\PowerShell%%~nxVx64
            HKCR\LibraryFolder\background\shell\PowerShell%%~nxVx64
        ) Do Reg Query %%D > Nul 2>&1 && Reg Add %%D /V Extended /D "" /F /Reg:64 > Nul
    )
    GoTo :EOF