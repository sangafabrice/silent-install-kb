@Echo OFF

:Main
: 1=:version
: 2=:link
: 3=:app_id
: 4=:program_data
: [5=:save_copy_to]
: [6=:local_dl_name]

PushD "%~dp0"
SetLocal
Set [version]=%~1
Set [version_exe]=%~f5\%~1.exe
Set [link]=%~2
Call copy-local-link.bat [version_exe] [link] [version] || GoTo EndToLocal
For /F "Tokens=*" %%P In ('Call download-from.bat . "%[link]%" "%~nx6"') Do (
    Call install-inno-setup.bat "%%~fP" %~3 "%~f4"
    If Not "%~f5"=="" Call save-package.bat "%[version_exe]%" "%%~fP"
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