@Echo OFF

:Main
: 1=:save_copy_to_directory

PushD "%~dp0"
Call set-system-autorun.bat > nul
SetLocal ENABLEDELAYEDEXPANSION
Set app=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe
Set shim=%PROFILE_DRIVE_PATH%\msedge.bat
Set compare=2
Set version=
Set link=
Call :get-download-info version link
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%shim%" --version compare
If "%compare%"=="1" (
    TaskKill /IM msedge.exe /F > Nul 2>&1
    Call download-install-msi-setup.bat "%version%" "%link%" "" "%~f1" > Nul
)
If EXIST "%app%" (
    Call :write-to-profile "%app%"
    Call "%shim%" --version > auto-complete\msedge
)
EndLocal
PopD
GoTo :EOF

:get-download-info
    Set config=resource\msedge
    For /F "Tokens=1* Delims=:, " %%E In ('^
        Curl --config %config%\dl-info.conf ^|^
        Jq --from-file %config%\dl-info.jq ^
    ') Do (
        Set %%~E=%%~F
        Set %%~E=!%%~E:",=!
    )
    GoTo :EOF

:write-to-profile
    Set "wmicappname=%~f1"
    Set "wmicappname=%wmicappname:\=\\%"
    Set "wmicappname=%wmicappname:(=^^^(%"
    Set "wmicappname=%wmicappname:)=^^^)%"
    (
        Echo @Echo OFF
        Echo SetLocal
        Echo If Not "%%~1"=="--version" ^(
        Echo     If Not "%%~1"=="-V" ^(
        Echo         Start "" /D "%~dp1" "%~nx1" %%*
        Echo         GoTo :EOF
        Echo     ^)
        Echo ^)
        Echo For /F "Skip=1 Tokens=* Delims=." %%%%V In ^('"WMIC DATAFILE WHERE Name="%wmicappname%" GET Version"'^) Do ^(
        Echo     Echo %%%%V
        Echo     GoTo EndToLocal
        Echo ^)
        Echo :EndToLocal
        Echo EndLocal
    ) > "%shim%"
    Reg Add "HKCR\MSEdgePDF\shell\open\command" /VE /D "\"%~f1\" --app=\"%%1\"" /F /Reg:64 > Nul
    For %%T In (
        Core
        UA
    ) Do SchTasks /Change /TN MicrosoftEdgeUpdateTaskMachine%%T /Disable > Nul 2>&1
    GoTo :EOF