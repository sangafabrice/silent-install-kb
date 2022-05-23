@Echo OFF

:Main
: 1=:version
: 2=:link
: 3=:program_data
: [4=:save_copy_to]
: [5=:local_dl_name]

PushD "%~dp0"
SetLocal ENABLEDELAYEDEXPANSION
Set [version]=%~1
Set [version_]=%~f4\%~1
Set [link]=%~2
Set [ErrorCount]=0
For %%E In (
    .appx
    .appxbundle
    .msix
    .msixbundle
) Do (
    Set [version_ext]=%[version_]%%%E
    Call copy-local-link.bat [version_ext] [link] [version]
    Set /A [ErrorCount]+=!ERRORLEVEL!
)
If 4 LEQ %[ErrorCount]% GoTo EndToLocal
Set [appx_volume]=
If Not "%~3"=="" Set [appx_volume]=-Volume %~f3
For /F "Tokens=*" %%P In ('Call download-from.bat . "%[link]%" "%~nx5"') Do (
    PowerShell -Command "& {Add-AppxPackage '%%~fP' -ForceUpdateFromAnyVersion %[appx_volume]%}"
    If Not "%~f4"=="" Call save-package.bat "%[version_]%%%~xP" "%%~fP"
    Call :DeletePackage "%%~fP"
)
Set [version]
Set [link]
:EndToLocal
EndLocal
PopD
GoTo :EOF

:DeletePackage
    Del /F /Q "%~f1" > Nul 2>&1
    If EXIST "%~f1" GoTo DeletePackage