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
Call dl-info\GetFrom-Link.bat Firefox-Dev version link > Nul
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

:write-to-profile
    Echo Set FIREFOX_DEV_VERSION=%version%> "%PROFILE_DRIVE_PATH%\mod_firefoxdev.bat"
    Call set-env-version-shim.bat "%app%" FIREFOX_DEV_VERSION -gui > "%shim%"
    GoTo :EOF