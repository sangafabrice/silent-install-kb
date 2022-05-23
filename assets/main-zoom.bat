@Echo OFF

:Main
: 1=:save_copy_to

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set program_data=
Call profile.init.bat zoom
Set app=%program_data%\bin\zoom.exe
Set installer=%program_data%\uninstall\Installer.exe
Set shim=%PROFILE_DRIVE_PATH%\zoom.bat
Set default_program_data=%APPDATA%\Zoom
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-Link.bat Zoom version link > Nul
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%shim%" --version compare
If "%compare%"=="2" (
    Set version_exe=%~f1\%version%.exe
    Call copy-local-link.bat version_exe link version || GoTo EndToLocal
    For /F "Tokens=*" %%P In ('Call download-from.bat . "!link!"') Do (
        Start "" /Wait "%%~fP" /silent
        Call :move-install-dir
        If Not "%~f1"=="" Call save-package.bat "!version_exe!" "%%~fP"
        Call :DeletePackage "%%~fP"
    )
)
If EXIST "%app%" (
    Call :configure-registry
    Call set-version-shim.bat "%app%" * -gui > "%shim%"
    Call "%shim%" --version > auto-complete\zoom
    Cscript //B set-shortcut.vbs /Target:"%installer%" /Args:"/uninstall" /Icon:"%installer%"^
    /Shortcut:"%APPDATA%\Microsoft\Windows\Start Menu\Programs\Zoom\Uninstall Zoom.lnk"
    Cscript //B set-shortcut.vbs /Target:"%app%" /Icon:"%app%"^
    /Shortcut:"%APPDATA%\Microsoft\Windows\Start Menu\Programs\Zoom\Zoom.lnk"
)
:EndToLocal
EndLocal
PopD
GoTo :EOF

:move-install-dir
    If EXIST "%default_program_data%" (
        Echo d| XCopy "%default_program_data%" "%program_data%" /E /Y /Q > Nul
        TaskKill /Im Zoom.exe /T /F > Nul 2>&1
        RmDir /S /Q "%default_program_data%" 2> Nul
    )
    GoTo :EOF

:configure-registry
    CScript //B resource\zoom\config.vbs %program_data%
    For /F "Tokens=*" %%V In ('^
        Reg Query "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Low Rights\ElevationPolicy" /S /F "Zoom.exe" ^|^
        FindStr /R /B /C:"HKEY_" ^
    ') Do Reg Add "%%~V" /V AppPath /D "%program_data%\bin" /F /Reg:64 > Nul
    GoTo :EOF

:DeletePackage
    Del /F /Q "%~f1" > Nul 2>&1
    If EXIST "%~f1" GoTo DeletePackage
    GoTo :EOF