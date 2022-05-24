@Echo OFF

:Main
: 1=:app_executable_relative_path_from_profile
: 2=:save_copy_to
: 3=:local_dl_name
: 4=:shim_command_for_version
: 5=:non_cli_flag
: 6=:app_host
: 7=:shortcut_name
: 8=:use_last_modified_flag

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
For /F "Tokens=1* Delims=\" %%L In ("%~1") Do (
    If /I "Profile:" EQU "%%~L" (
        Set "rel_exepath=%%~M"
        GoTo FromProfile
    )
)
Set app=%PROFILE_DRIVE_PATH%\%~1
Set shim=%app%
GoTo EndFromProfile
:FromProfile
Set program_data=
Call profile.init.bat %~nx1
Set app=%program_data%\%rel_exepath%
:EndFromProfile
Set shim_command=
If Not "%~nx1"=="%~1" (
    Set shim=%PROFILE_DRIVE_PATH%\%~n1.bat
    Set shim_command=%~4
    Set shim_command=!shim_command:_q_="!
    Set set_shim_bat=set-cli-version-shim.bat
    If "non_cli"=="%~5" set set_shim_bat=set-version-shim.bat
    If "non_cli_reg"=="%~5" set set_shim_bat=set-reg-version-shim.bat
)
Set app_host=Github
If Not ""=="%~6" Set app_host=%~6
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-%app_host%.bat ini\%~n1.ini version link > Nul
Set cmdline="%shim%" --version
If Not ""=="%~8" Set cmdline="%ComSpec%" "/C Echo !%~8!"
If EXIST "%app%" Call compare-version-cli.bat "%version%" %cmdline% compare
For /F "Tokens=1-2 Delims=\" %%T In ("%~3") Do (
    If /I "Chromium:" EQU "%%~T" GoTo InstallChromium
    If /I "Nsis:" EQU "%%~T" GoTo InstallNsis
    If /I "Inno:" EQU "%%~T" GoTo InstallInno
    If /I "MsiExe:" EQU "%%~T" GoTo InstallMsiExe
    If /I "Msi:" EQU "%%~T" (
        Set "add_options=%%U"
        GoTo InstallMsi
    )
    If /I "Portable:" EQU "%%~T" (
        Set "dl_ext=%%U"
        GoTo InstallPortable
    )
)
:InstallConsole
Set download_unzip_prefix=
If Not ""=="%~nx3" Set download_unzip_prefix=download-unzip-
Call %download_unzip_prefix%install-console-setup.bat "%version%" "%link%" "%app%" %~nx3 "%compare%" "%~f2" > Nul
If EXIST "%app%" If DEFINED shim_command Call %set_shim_bat% "%%%%%%%%~dp0%~1" %shim_command% > "%shim%"
GoTo EndShimming
:InstallNsis
If "%compare%"=="2" Call install-nsis-setup.bat "%version%" "%link%" "%program_data%" "%~f2" > Nul
GoTo EndInstall
:InstallInno
If "%compare%"=="2" Call download-install-inno-setup.bat "%version%" "%link%" %~n1 "%program_data%" "%~f2" > Nul
GoTo EndInstall
:InstallMsi
If DEFINED add_options Set "add_options=!add_options:program_data=%program_data%!"
If "%compare%"=="2" Call download-install-msi-setup.bat "%version%" "%link%" "%add_options%" "%~f2" > Nul
GoTo EndInstall
:InstallMsiExe
If "%compare%"=="2" Call install-msiexe-setup.bat "%version%" "%link%" "%~f2" > Nul
GoTo EndInstall
:InstallChromium
If "%compare%"=="2" (
    TaskKill /IM %~nx1 /F > Nul 2>&1
    Call download-install-chromium-setup.bat "%version%" "%link%" "%shim%" "%app%" "%~f2" > Nul
)
GoTo EndInstall
:InstallPortable
If "%compare%"=="2" (
    TaskKill /IM %~nx1 /F > Nul 2>&1
    Call download-unzip-portable-setup.bat "%version%.%dl_ext%" "%link%" "%program_data%" "%~f2" > Nul
)
GoTo EndInstall
:EndInstall
If EXIST "%app%" If DEFINED shim_command Call %set_shim_bat% "%app%" %shim_command% > "%shim%"
:EndShimming
If EXIST "%app%" (
    Call "%shim%" --version > auto-complete\%~n1
    If Not ""=="%~7" (
        Cscript //B set-shortcut.vbs /Target:"%app%"^
        /Shortcut:"%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%~7.lnk"
    )
    If Not ""=="%~8" Echo Set %~8=%version%> "%PROFILE_DRIVE_PATH%\mod_%~n1.bat"
)
EndLocal
If Not ""=="%~8" Call "%PROFILE_DRIVE_PATH%\mod_%~n1.bat" > Nul 2>&1
PopD