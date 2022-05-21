@echo OFF

:Main
: 1=:version
: 2=:link
: 3=:msi_args
: [4=:save_copy_to]
: [5=:local_dl_name]

PushD "%~dp0"
SetLocal
Set [version]=%~1
Set [version_msi]=%~f4\%~1.msi
Set [link]=%~2
Call copy-local-link.bat [version_msi] [link] [version] || GoTo EndToLocal
For /F "Tokens=*" %%P In ('Call download-from.bat . "%[link]%" "%~nx5"') Do (
    Start "" /Wait MsiExec /i "%%~fP" /qn %~3
    If Not "%~f4"=="" Call save-package.bat "%[version_msi]%" "%%~fP"
    Del /F /Q "%%~fP" > Nul
)
Set [version]
Set [link]
:EndToLocal
EndLocal
PopD