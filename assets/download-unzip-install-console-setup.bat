@Echo OFF

:Main
: 1=:version
: 2=:link
: 3=:program_data_exe
: 4=:local_dl_name
: 5=:version_comparison_value
: [6=:save_copy_to]
: 7=:[additional_exe additional_local_dl_name]

PushD "%~dp0"
SetLocal ENABLEDELAYEDEXPANSION
Set [version]=%~1
Set [version_zip]=%~f6\%~1.zip
Set [link]=%~2
Set [additionalexepath]=
Set [additionalarg]=
If "%~5"=="2" (
    Call copy-local-link.bat [version_zip] [link] [version] || GoTo EndToLocal
    If Not "%~7"=="" Set [additionalarg]="%~8" [additionalexepath]
    Call download-unzip-from.bat "![link]!" [unzippath] "%~4" [exepath] ![additionalarg]!
    If Not "![exepath]!"=="" (
        Call make-shimmed-directory.bat "%~dp3"
        Copy /Y "![exepath]!" "%~f3" > Nul
        If Not "![additionalexepath]!"=="" Copy /Y "![additionalexepath]!" "%~f7" > Nul
        If Not "![unzippath]!"=="" Call :RemoveUnzipped "![unzippath]!"
    )
)
Set [additionalarg]=
If Not "%~7"=="" Set [additionalarg]="%~f7" "%~8"
If Not "%~f6"=="" Call save-package.bat "%[version_zip]%" "%~f3" "%~4" ![additionalarg]!
Set [version]
Set [link]
:EndToLocal
EndLocal
PopD
GoTo :EOF

:RemoveUnzipped
    RmDir /S /Q "%~f1" 2> Nul
    If EXIST "%~f1" GoTo RemoveUnzipped