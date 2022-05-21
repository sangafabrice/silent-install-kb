@Echo OFF

:Main
: 1=:version
: 2=:link
: 3=:shim_path
: 4=:program_data_exe
: [5=:save_copy_to]

PushD "%~dp0"
SetLocal ENABLEDELAYEDEXPANSION
Set [version]=%~1
Set [version_exe]=%~f5\%~1.exe
Set [link]=%~2
For /F "Tokens=2 Delims=[]" %%P In ('^
    Dir /AL 7z.exe ^|^
    FindStr "[ ]" ^
') Do If Not EXIST "%%~fP" GoTo EndToLocal
Call copy-local-link.bat [version_exe] [link] [version] || GoTo EndToLocal
For /F "Tokens=*" %%P In ('Call download-from.bat . "%[link]%"') Do (
    Set [unzippath]=%~dp0%%~nP
    7z x -aoa -o"![unzippath]!" "%%~fP" > Nul 2>&1
    For /F "Tokens=1 Delims= " %%F In ('Dir /B "![unzippath]!\*.7z" 2^> Nul') Do (
        7z x -aoa -o"![unzippath]!" "![unzippath]!\%%~nxF" > Nul 2>&1
        Del /F /Q "![unzippath]!\%%~nxF" > Nul
    )
    Call install-chromium-setup.bat "![unzippath]!" "%~f3" "%~f4"
    If Not "%~f5"=="" Call save-package.bat "%[version_exe]%" "%%~fP"
    Call :DeletePackage "%%~fP"
    Call :RemoveUnzipped "![unzippath]!"
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

:DeletePackage
    Del /F /Q "%~f1" > Nul 2>&1
    If EXIST "%~f1" GoTo DeletePackage
    GoTo :EOF