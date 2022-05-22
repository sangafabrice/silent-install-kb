@Echo OFF

:Main
: 1=:save_copy_to

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Call profile.init.bat sumatrapdf
Set app=%program_data%\sumatrapdf.exe
Set shim=%PROFILE_DRIVE_PATH%\sumatrapdf.bat
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-Link.bat SumatraPDF version link > Nul
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%shim%" --version compare
If "%compare%"=="2" (
    Set version_exe=%~f1\%version%.exe
    Call copy-local-link.bat version_exe link version || GoTo EndToLocal
    For /F "Tokens=*" %%P In ('Call download-from.bat . "!link!"') Do (
        Start "" /Wait "%%~fP" -install /s /d "%program_data%"
        If Not "%~f1"=="" Call save-package.bat "!version_exe!" "%%~fP"
        Call :DeletePackage "%%~fP"
    )
)
If EXIST "%app%" (
    Call set-version-shim.bat "%app%" 1-3 -gui > "%shim%"
    Call "%shim%" --version > auto-complete\sumatrapdf
)
:EndToLocal
EndLocal
PopD
GoTo :EOF

:DeletePackage
    Del /F /Q "%~f1" > Nul 2>&1
    If EXIST "%~f1" GoTo DeletePackage
    GoTo :EOF