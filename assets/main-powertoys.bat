@Echo OFF

:Main
: 1=:save_copy_to

PushD "%~dp0"
Call set-system-autorun.bat > nul
SetLocal ENABLEDELAYEDEXPANSION
Set program_data=
Call profile.init.bat powertoys
Set app=%program_data%\powertoys.exe
Set shim=%PROFILE_DRIVE_PATH%\powertoys.bat
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-Github.bat ini\powertoys.ini version link > Nul
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%shim%" --version compare
If "%compare%"=="2" (
    Set version_exe=%~f1\%version%.exe
    Call copy-local-link.bat version_exe link version || GoTo EndToLocal
    For /F "Tokens=*" %%P In ('Call download-from.bat . "!link!"') Do (
        Call :UninstallPreviousInstall
        Start "" /Wait resource\powertoys\wininstall.exe "%%~fP" "%program_data%"
        If Not "%~f1"=="" Call save-package.bat "!version_exe!" "%%~fP"
        Call :DeletePackage "%%~fP"
    )
)
If EXIST "%app%" (
    Call set-version-shim.bat "%app%" 1-3 -gui > "%shim%"
    Call "%shim%" --version > auto-complete\powertoys
)
:EndToLocal
EndLocal
PopD
GoTo :EOF

:UninstallPreviousInstall
    Set UninstallString=
    Call get-reg-app-info.bat LM64 PowerToys UninstallString
    If DEFINED UninstallString Start "" /Wait %UninstallString% /Quiet
    GoTo :EOF

:DeletePackage
    Del /F /Q "%~f1" > Nul 2>&1
    If EXIST "%~f1" GoTo DeletePackage
    GoTo :EOF