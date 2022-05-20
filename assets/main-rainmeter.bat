@Echo OFF

:Main
: 1=:save_copy_to

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set program_data=
Call profile.init.bat rainmeter
Set app=%program_data%\rainmeter.exe
Set shim=%PROFILE_DRIVE_PATH%\rainmeter.bat
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-Github.bat ini\rainmeter.ini version link > Nul
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%shim%" --version compare
If "%compare%"=="2" (
    Set version_exe=%~f1\%version%.exe
    Call copy-local-link.bat version_exe link version || GoTo EndToLocal
    For /F "Tokens=*" %%P In ('Call download-from.bat . "!link!"') Do (
        Start "" /Wait "%%~fP" /S /PORTABLE=1 /D=%program_data%
        If Not "%~f1"=="" Call save-package.bat "!version_exe!" "%%~fP"
        Call :DeletePackage "%%~fP"
    )
)
If EXIST "%app%" (
    Call set-version-shim.bat "%app%" * -gui > "%shim%"
    Call "%shim%" --version > auto-complete\rainmeter
)
:EndToLocal
EndLocal
PopD
GoTo :EOF

:DeletePackage
    Del /F /Q "%~f1" > Nul 2>&1
    If EXIST "%~f1" GoTo DeletePackage
    GoTo :EOF