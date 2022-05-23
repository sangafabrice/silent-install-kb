@Echo OFF

:Main
: 1=:version
: 2=:link
: 3=:program_data_exe
: [4=:save_copy_to]

PushD "%~dp0"
SetLocal ENABLEDELAYEDEXPANSION
Set [version]=%~1
Set [version_exe]=%~f4\%~1.exe
Set [link]=%~2
For /F "Tokens=2 Delims=[]" %%P In ('^
    Dir /AL 7z.exe ^|^
    FindStr "[ ]" ^
') Do If Not EXIST "%%~fP" GoTo EndToLocal
Call copy-local-link.bat [version_exe] [link] [version] || GoTo EndToLocal
For /F "Tokens=*" %%P In ('Call download-from.bat . "%[link]%"') Do (
    7z x -aoa -o"%%~dpnP" "%%~fP" > Nul 2>&1
    For /F "Tokens=*" %%X In ('Dir /S /B "%%~dpnP\%~nx3"') Do (
        Echo D|^
XCopy "%%~dpX" "%~dp3" /E /Y /Q > Nul
    )
    If Not "%~f4"=="" Call save-package.bat "%[version_exe]%" "%%~fP"
    Call :RemoveUnzipped "%%~dpnP"
    Call :DeletePackage "%%~fP"
)
Set [version]
Set [link]
:EndToLocal
EndLocal
PopD
GoTo :EOF

:RemoveUnzipped
    RmDir /S /Q "%~f1" 2> Nul
    If EXIST "%~f1" GoTo RemoveUnzipped
    GoTo :EOF

:DeletePackage
    Del /F /Q "%~f1" > Nul 2>&1
    If EXIST "%~f1" GoTo DeletePackage
    GoTo :EOF