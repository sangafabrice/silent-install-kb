@Echo OFF

:Main
: 1=:app_executable
: 2=:save_copy_to
: 3=:local_dl_name

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set app=%PROFILE_DRIVE_PATH%\%~nx1
Set compare=2
Set version=
Set link=
Call ..\download-info\batch\GetFrom-Github.bat %~n1.ini version link > Nul
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%app%" --version compare
set download_unzip_prefix=
If Not ""=="%~3" set download_unzip_prefix=download-unzip-
Call %download_unzip_prefix%install-console-setup.bat "%version%" "%link%" "%app%" %~3 "%compare%" "%~f2" > Nul
If EXIST "%app%" Call "%app%" --version > auto-complete\%~n1
EndLocal
PopD