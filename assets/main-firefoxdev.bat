@Echo OFF

:Main
: 1=:save_copy_to

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set program_data=
Call profile.init.bat firefox_dev
Set app=%program_data%\firefox.exe
Set shim=%PROFILE_DRIVE_PATH%\firefoxdev.bat
Set compare=2
Set version=
Set link=
Call :get-download-info version link
If EXIST "%app%" Call compare-version-cli.bat "%version:b=.%" "%ComSpec%" "/c Echo %FIREFOX_DEV_VERSION:b=.%" compare
If "%compare%"=="2" Call install-gecko-setup.bat "%version%" "%link%" "%app%" "%~f1" > Nul
If EXIST "%app%" (
    Call :write-to-profile
    Echo %version%> auto-complete\firefoxdev
)
EndLocal
Call "%PROFILE_DRIVE_PATH%\mod_firefoxdev.bat" > Nul 2>&1
PopD
GoTo :EOF

:get-download-info 1:=version 2:=link
    For /F "Tokens=2 Delims=? " %%L In ('^
        Curl --url "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=win64"^
             --head ^
             --request  "GET"^
             --header "User-Agent: winhttp"^
             --silent ^|^
        FindStr /I /B "Location:"^
    ') Do (
        Set %~1=%%~nL
        Set %~1=!%~1:Firefox%%20Setup%%20=!
        Set %~2=%%~L
        Set %~2=!%~2:%%=%%%%!
    )
    GoTo :EOF

:write-to-profile
    Echo Set FIREFOX_DEV_VERSION=%version%> "%PROFILE_DRIVE_PATH%\mod_firefoxdev.bat"
    Call set-env-version-shim.bat "%app%" FIREFOX_DEV_VERSION -gui > "%shim%"
    GoTo :EOF