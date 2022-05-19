@Echo OFF
PushD "%~dp0"
Call assets\update-console-app.bat shimmed\rufus.exe "%~f1" "" 1-2 non_cli
Call :write-to-profile "%PROFILE_DRIVE_PATH%\rufus.bat" rufus.shim.txt
PopD
GoTo :EOF

:write-to-profile
    SetLocal ENABLEDELAYEDEXPANSION
    If Not EXIST "%~f1" GoTo :EOF
    Type "%~f1" > %~2
    Type Nul > "%~f1"
    Set i=0
    :Loop
    If %i% GTR 0 Set skip=Skip=%i%
    For /F "%skip%Tokens=* Delims=#" %%L In (%~2) Do (
        (
            If %i%==2 (
                Echo If "%%*"=="" ^(
                Echo     Start "" /D "%%~dp0shimmed\" "rufus.exe" --gui
                Echo     GoTo :EOF
                Echo ^)
            )
            Echo %%L
        ) >> "%~f1"
        Set /A i+=1
        GoTo Loop
    )
    Del /F /Q %~2 > Nul 2>&1
    EndLocal