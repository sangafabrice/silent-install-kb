@Echo OFF

:Main
: 1=:version_ext
: 2=:link
: 3=:program_data
: [4=:save_copy_to]
: [5=:local_dl_name]

PushD "%~dp0"
SetLocal
Set [version]=%~1
Set [version_ext]=%~f4\%~nx1
Set [link]=%~2
For /F "Tokens=2 Delims=[]" %%P In ('^
    Dir /AL 7z.exe ^|^
    FindStr "[ ]" ^
') Do If Not EXIST "%%~fP" GoTo EndToLocal
Call copy-local-link.bat [version_ext] [link] [version] || GoTo EndToLocal
For /F "Tokens=*" %%P In ('Call download-from.bat . "%[link]%" "%~nx5"') Do (
    7z x -aoa -o"%~f3" "%%~fP" > Nul 2>&1
    If Not "%~f4"=="" Call save-package.bat "%[version_ext]%" "%%~fP"
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