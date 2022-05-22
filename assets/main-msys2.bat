@Echo OFF

:Main
: 1=:save_copy_to

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set program_data=
Call profile.init.bat msys2
Set shim=%PROFILE_DRIVE_PATH%\msys2.bat
Set macro=%PROFILE_DRIVE_PATH%\doskey_msys2.macro
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-Github.bat ini\msys2.ini version link > Nul
If DEFINED version Set version=%version:-=%
Set program_data=%program_data%\%version%
Set app=%program_data%\msys2_shell.cmd
Call :get-auto-install-js auto_install_js
Call compare-version-cli.bat "%version%" "%shim%" --version compare
If "%compare%"=="2" (
    Set version_exe=%~f1\%version%.exe
    Call copy-local-link.bat version_exe link version || GoTo EndToLocal
    For /F "Tokens=*" %%P In ('Call download-from.bat . "!link!"') Do (
        If DEFINED auto_install_js Start "" /Wait "%%~fP" --platform minimal --script "%auto_install_js%" InstallDir=%program_data%
        If Not "%~f1"=="" Call save-package.bat "!version_exe!" "%%~fP"
        Call :DeletePackage "%%~fP"
    )
    If EXIST "%app%" Cscript //B %resource_dir%\config.vbs "%app%"
)
If EXIST "%app%" (
    Call set-reg-version-shim.bat "%app%" CU "MSYS2 64bit" > "%shim%"
    Call "%shim%" --version > auto-complete\msys2
    If EXIST "%macro%" DosKey /MacroFile="%macro%"
)
:EndToLocal
EndLocal
PopD
GoTo :EOF

:get-auto-install-js 1:=auto_install_js
    Set auto_install=https://raw.githubusercontent.com/msys2/msys2-installer/master/auto-install.js
    Set resource_dir=resource\msys2
    For /F "Tokens=1* Delims=/ " %%H In ('Curl %auto_install% -I -s') Do (
        If /I "%%~H" EQU "HTTP" Echo %%I| FindStr /R "20[0-9]" > Nul 2>&1 || GoTo :EOF
        If /I "%%~H" EQU "Etag:" If Not EXIST "%resource_dir%\%%~I.js" (
            MkDir %resource_dir% 2> Nul
            Del /F /Q %resource_dir%\*.js 2> Nul
            Call download-from.bat %resource_dir% %auto_install% %%~I.js > Nul
            GoTo EndOfRequest
        )
    )
    :EndOfRequest
    For /F "Tokens=*" %%F In ('Dir /B /S "%resource_dir%\*.js"') Do Set auto_install_js=%%~fF
    GoTo :EOF

:DeletePackage
    Del /F /Q "%~f1" > Nul 2>&1
    If EXIST "%~f1" GoTo DeletePackage
    GoTo :EOF