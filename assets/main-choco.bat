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
Set program_data=
Call profile.init.bat chocolatey
Set ChocolateyInstall=%program_data%
Set app=%program_data%\choco.exe
Set shim=%PROFILE_DRIVE_PATH%\chocolatey.bat
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-Chocolatey.bat version link > Nul
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%shim%" --version compare
For /F "Tokens=2 Delims=[]" %%P In ('^
    Dir /AL 7z.exe ^|^
    FindStr "[ ]" ^
') Do If Not EXIST "%%~fP" GoTo EndToLocal
If "%compare%"=="2" (
    Set version_exe=%~f1\%version%.nupkg
    Call copy-local-link.bat version_exe link version || GoTo EndToLocal
    For /F "Tokens=*" %%P In ('Call download-from.bat . "!link!"') Do (
        Set unzippath=%%~dpnP
        7z x -aoa -o"!unzippath!" "%%~fP" > Nul 2>&1
        For /F "Tokens=*" %%I In ('Dir /S /B "!unzippath!\chocolateyInstall.ps1" 2^> Nul') Do (
            SetX ChocolateyInstall "%program_data%" /M > Nul 2>&1
            PowerShell -NoProfile -InputFormat None -ExecutionPolicy Bypass -File %%~fI > Nul 2>&1
        )
        If Not "!unzippath!"=="" RmDir /S /Q "!unzippath!" 2> Nul
        If Not "%~f1"=="" Call save-package.bat "!version_exe!" "%%~fP"
        Call :DeletePackage "%%~fP"
    )
)
If EXIST "%app%" (
    Call set-version-shim.bat "%app%" 1-3 > "%shim%"
    Call "%shim%" --version > auto-complete\choco
)
:EndToLocal
EndLocal
PopD
GoTo :EOF

:DeletePackage
    Del /F /Q "%~f1" > Nul 2>&1
    If EXIST "%~f1" GoTo DeletePackage
    GoTo :EOF