@Echo OFF

:Main
: 1=:save_copy_to

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set app=%PROFILE_DRIVE_PATH%\jq.exe
Set compare=2
Set version=
Set link=
Call get-download-info-from-github.bat stedolan/jq jq-win64.exe version link
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%app%" --version compare
Call install-console-setup.bat "%version%" "%link%" "%app%" "%compare%" "%~f1" > Nul
If EXIST "%app%" Call "%app%" --version > auto-complete\jq
EndLocal
PopD