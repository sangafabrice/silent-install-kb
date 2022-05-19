@Echo OFF

:Main
: 1=:link
: 2:=unzippath
: [[3=:exename 4:=exepath] ...]

PushD "%~dp0"
For /F %%P In ('Call download-from.bat . "%~1"') Do (
    MkDir "%%~dpnP" 2> Nul
    PushD "%%~dpnP" > Nul && (
        For /F "Tokens=*" %%C In ('CD') Do Set %~2=%%C
        Tar -xf "%%P"
        Call :GetSetupPath %*
        PopD
    )
    Call :DeletePackage "%%~fP"
)
PopD
GoTo :EOF

:GetSetupPath [[1=:setup_name 2:=setup_path] ...]
    Shift & Shift
    :LoopShift
    If Not "%~1"=="" (
        For /F "Tokens=*" %%C In ('Dir /S /B "%~1"') Do Set %~2=%%C
        Shift & Shift
        GoTo LoopShift
    )
    GoTo :EOF

:DeletePackage
    Del /F /Q "%~f1" > Nul 2>&1
    If EXIST "%~f1" GoTo DeletePackage