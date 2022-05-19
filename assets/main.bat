@Echo OFF

:Main
: 1=:app_executable_relative_path_from_profile
: 2=:save_copy_to
: 3=:local_dl_name
: 4=:shim_command_for_version
: 5=:non_cli_flag
: 6=:app_host

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
For /F "Tokens=1 Delims=\" %%L In ("%~1") Do If /I "Profile:" EQU "%%~L" GoTo FromProfile
Set app=%PROFILE_DRIVE_PATH%\%~1
Set shim=%app%
GoTo EndFromProfile
:FromProfile
Set program_data=
Call profile.init.bat %~nx1
Set app=%program_data%\%~nx1
:EndFromProfile
Set shim_command=
If Not "%~nx1"=="%~1" (
    Set shim=%PROFILE_DRIVE_PATH%\%~n1.bat
    Set shim_command=%~4
    Set shim_command=!shim_command:_q_="!
    Set set_shim_bat=set-cli-version-shim.bat
    If Not ""=="%~5" set set_shim_bat=set-version-shim.bat
)
Set app_host=Github
If Not ""=="%~6" Set app_host=%~6
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-%app_host%.bat ini\%~n1.ini version link > Nul
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%shim%" --version compare
For /F "Tokens=1 Delims=\" %%T In ("%~3") Do (
    If /I "Chromium:" EQU "%%~T" GoTo InstallChromium
)
:InstallConsole
Set download_unzip_prefix=
If Not ""=="%~nx3" Set download_unzip_prefix=download-unzip-
Call %download_unzip_prefix%install-console-setup.bat "%version%" "%link%" "%app%" %~nx3 "%compare%" "%~f2" > Nul
If EXIST "%app%" If DEFINED shim_command Call %set_shim_bat% "%%%%%%%%~dp0%~1" %shim_command% > "%shim%"
GoTo EndShimming
:InstallChromium
If "%compare%"=="2" (
    TaskKill /IM %~nx1 /F > Nul 2>&1
    Call download-install-chromium-setup.bat "%version%" "%link%" "%shim%" "%app%" "%~f2" > Nul
)
If EXIST "%app%" If DEFINED shim_command Call %set_shim_bat% "%app%" %shim_command% > "%shim%"
GoTo EndShimming
:EndShimming
If EXIST "%app%" Call "%shim%" --version > auto-complete\%~n1
EndLocal
PopD