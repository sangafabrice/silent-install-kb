@Echo OFF

:Main
: 1=:version
: 2=:link
: 3=:program_data_exe
: 4=:version_comparison_value
: [5=:save_copy_to]

PushD "%~dp0"
SetLocal ENABLEDELAYEDEXPANSION
Set [version]=%~1
Set [version_exe]=%~f5\%~1.exe
Set [link]=%~2
If "%~4"=="2" (
    Call copy-local-link.bat [version_exe] [link] [version] || GoTo EndToLocal
    For /F "Tokens=*" %%P In ('Call download-from.bat . "![link]!"') Do (
        Call make-shimmed-directory.bat "%~dp3"
        Copy /Y "%%~fP" "%~f3" > nul
        Call :DeletePackage "%%~fP"
    )
)
If Not "%~f5"=="" Call save-package.bat "%[version_exe]%" "%~f3"
Set [version]
Set [link]
:EndToLocal
EndLocal
PopD
GoTo :EOF

:DeletePackage
    Del /F /Q "%~f1" > Nul 2>&1
    If EXIST "%~f1" GoTo DeletePackage
    GoTo :EOF