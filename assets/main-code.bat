@Echo OFF

:Main
: 1=:save_copy_to

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set program_data=
Call profile.init.bat vscode
Set app=%program_data%\code.exe
Set shim=%PROFILE_DRIVE_PATH%\code.bat
Set config=resource\code\config.vbs
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-Link.bat Code version link > Nul
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%shim%" --version compare
If "%compare%"=="2" (
    TaskKill /IM code.exe /f /t > Nul 2>&1
    Call download-install-inno-setup.bat "%version%" "%link%" vscode "%program_data%" "%~f1" > Nul
)
If EXIST "%app%" (
    Call :write-to-profile
    Call "%shim%" --version > auto-complete\code
    If EXIST %config% Cscript %config% //B
)
EndLocal
PopD
GoTo :EOF

:write-to-profile
    (
        Echo @Echo OFF
        Echo SetLocal ENABLEDELAYEDEXPANSION
        Echo If Not "%%~1"=="--version" ^(
        Echo     If Not "%%~1"=="-V" ^(
        Echo         Set Path=^^!Path:%%PROFILE_DRIVE_PATH%%;=^^!
        Echo         Set Path=^^!Path:%%PROFILE_DRIVE_PATH%%=^^!
        Echo         "%program_data%\bin\code.cmd" %%* --extensions-dir %ext_dir%
        Echo         GoTo :EOF
        Echo     ^)
        Echo ^)
        Echo For /F "Skip=1 Tokens=1-3 Delims=." %%%%V In ^('"WMIC DATAFILE WHERE Name="%app:\=\\%" GET Version"'^) Do ^(
        Echo     Echo %%%%V.%%%%W.%%%%X
        Echo     GoTo EndToLocal
        Echo ^)
        Echo :EndToLocal
        Echo EndLocal
    ) > "%shim%"
    GoTo :EOF