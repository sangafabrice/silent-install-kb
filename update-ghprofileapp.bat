@Echo OFF

:Main
: 1=:app_executable_relative_path_from_profile
: 2=:save_copy_to
: 3=:local_dl_name
: 4=:shim_command_for_version

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set app=%PROFILE_DRIVE_PATH%\%~1
Set shim=%app%
Set shim_command=
If "%~nx1" NEQ "%~1" (
    Set shim=%PROFILE_DRIVE_PATH%\%~n1.bat
    Set shim_command=%~4
    Set shim_command=!shim_command:_q_="!
)
Set compare=2
Set version=
Set link=
Call ..\download-info\batch\GetFrom-Github.bat %~n1.ini version link > Nul
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%shim%" --version compare
set download_unzip_prefix=
If Not ""=="%~3" set download_unzip_prefix=download-unzip-
Call %download_unzip_prefix%install-console-setup.bat "%version%" "%link%" "%app%" %~3 "%compare%" "%~f2" > Nul
If EXIST "%app%" (
    If DEFINED shim_command (
        Call set-cli-version-shim.bat "%%%%%%%%~dp0%~1" %shim_command% > "%shim%"
    )
    Call "%shim%" --version > auto-complete\%~n1
)
EndLocal
PopD