@Echo OFF

:Main
: 1=:version
: 2=:link
: [3=:save_copy_to]
: [4=:local_dl_name]

PushD "%~dp0"
SetLocal
Set [version]=%~1
Set [version_exe]=%~f3\%~1.exe
Set [link]=%~2
Call copy-local-link.bat [version_exe] [link] [version] || GoTo EndToLocal
For /F "Tokens=*" %%P In ('Call download-from.bat . "%[link]%" "%~nx4"') Do (
    Start "" /Wait "%%~fP" /Install /Quiet /NoRestart
    If Not "%~f3"=="" Call save-package.bat "%[version_exe]%" "%%~fP"
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
    GoTo :EOF