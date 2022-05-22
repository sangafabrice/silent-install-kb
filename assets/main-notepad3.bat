@Echo OFF

:Main
: 1=:save_copy_to

PushD "%~dp0"
Call set-system-autorun.bat > nul
SetLocal ENABLEDELAYEDEXPANSION
Call profile.init.bat notepad3
Set app=%program_data%\notepad3.exe
Set shim=%PROFILE_DRIVE_PATH%\notepad3.bat
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-Github.bat ini\notepad3.ini version link > Nul
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%shim%" --version compare
If "%compare%"=="2" (
    Set version_zip=%~f1\%version%.zip
    Call copy-local-link.bat version_zip link version || GoTo EndToLocal
    Call download-unzip-from.bat !link! unzippath "Notepad3_*_Setup.exe" exepath
    If Not "!exepath!"=="" (
        TaskKill /IM notepad3.exe /F /T > Nul 2>&1
        Call install-inno-setup.bat "!exepath!" notepad3 "%program_data%"
        If Not "%~f1"=="" Call save-package.bat "!version_zip!" "!exepath!" Notepad3__Setup.exe
        If Not "!unzippath!"=="" RmDir /S /Q "!unzippath!" 2> nul
    )
)
If EXIST "%app%" (
    Call set-version-shim.bat "%app%" * -gui > "%shim%"
    Call "%shim%" --version > auto-complete\notepad3
    Cscript //B set-shortcut.vbs /Target:"%app%"^
    /Shortcut:"%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Notepad 3.lnk"
)
:EndToLocal
EndLocal
PopD