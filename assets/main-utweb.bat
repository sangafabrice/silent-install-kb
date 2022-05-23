@Echo OFF

:Main
: 1=:save_copy_to

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set program_data=
Call profile.init.bat utweb
Set app=%program_data%\utweb.exe
Set shim=%PROFILE_DRIVE_PATH%\utweb.bat
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-Link.bat UTWeb version link > Nul
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%ComSpec%" "/C Echo %UTORRENT_WEB_DOWNLOAD_ETAG%" compare
For /F "Tokens=2 Delims=[]" %%P In ('^
    Dir /AL 7z.exe ^|^
    FindStr "[ ]" ^
') Do If Not EXIST "%%~fP" GoTo EndToLocal
If "%compare%"=="2" (
    Set version_exe=%~f1\%version%.exe
    Call copy-local-link.bat version_exe link version || GoTo EndToLocal
    TaskKill /IM utweb.exe /f /t > Nul 2>&1
    For /F "Tokens=*" %%P In ('Call download-from.bat . "!link!" utweb_installer.exe') Do (
        Set unzippath=%~dp0%%~nP
        7z x -aoa -o"!unzippath!" "%%~fP" > Nul 2>&1
        For /F "Tokens=*" %%G In ('Dir /B "!unzippath!\*.exe"') Do (
            Start "" /B "!unzippath!\%%~nxG"
            Call :ProcessTemp "%%~nxG"
        )
        If Not "%~f1"=="" Call save-package.bat "!version_exe!" "%%~fP"
        If Not "!unzippath!"=="" Call :RemoveUnzipped "!unzippath!"
        Call :DeletePackage "%%~fP"
    )
)
If EXIST "%app%" (
    Call :write-to-profile
    Call "%shim%" --version > auto-complete\utweb
)
:EndToLocal
EndLocal
Call "%PROFILE_DRIVE_PATH%\mod_utweb.bat" > Nul 2>&1
PopD
GoTo :EOF

:write-to-profile
    Echo Set UTORRENT_WEB_DOWNLOAD_ETAG=%version%> "%PROFILE_DRIVE_PATH%\mod_utweb.bat"
    Call set-version-shim.bat "%app%" 1-3 -gui > "%shim%"
    GoTo :EOF

:ProcessTemp
    Rem Dummy comment
    TaskList /Fi "IMAGENAME EQ %~nx1" /V /NH | FindStr /I "OleMainThreadWndName" > Nul && GoTo ProcessTemp
    TimeOut /T 5 > Nul
    For /D %%G In ("%TEMP%\%~nx1*") Do (
        For %%C In ("%%~fG\*.exe") Do (
            TaskKill /IM "%~nx1" /F > Nul 2>&1
            Start "" /Wait "%%~fC" /S /D=%program_data%
        )
        RmDir /S /Q "%%~fG" 2> Nul
        GoTo :EOF
    )
    GoTo :EOF

:RemoveUnzipped
    RmDir /S /Q "%~f1" 2> Nul
    If EXIST "%~f1" GoTo RemoveUnzipped
    GoTo :EOF

:DeletePackage
    Del /F /Q "%~f1" > Nul 2>&1
    If EXIST "%~f1" GoTo DeletePackage
    GoTo :EOF