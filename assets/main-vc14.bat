@Echo OFF

:Main
: 1=:vc_library_architecture[x64|x86]
: 2=:save_copy_to

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set arch=%~1
Set regkey=HKLM\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\14.0\VC\Runtimes\%arch%
Set shim=%PROFILE_DRIVE_PATH%\vc2017%arch%.bat
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-Link.bat vc14%arch% version link > Nul
Call :is-installed && Call compare-version-cli.bat "%version%" "%ComSpec%" "/C Echo !VCREDIST%arch%_DOWNLOAD_ETAG!" compare
If "%compare%"=="2" Call install-msiexe-setup.bat "%version%" "%link%" "%~f2" > Nul
Call :is-installed && (
    Call :write-to-profile
    Call "%shim%" --version > auto-complete\vc2017%arch%
)
EndLocal
PopD
GoTo :EOF

:write-to-profile
    Echo Set VCREDIST%arch%_DOWNLOAD_ETAG=%version%> "%PROFILE_DRIVE_PATH%\mod_vc2017%arch%.bat"
    (
        Echo @Echo OFF
        Echo For /F "Tokens=3" %%%%V In ^('Reg Query "%regkey%" /V Version 2^^^>^^^&1 ^^^| Find "Version"'^) Do Echo %%%%V
    ) > "%shim%"
    GoTo :EOF

:is-installed
    Reg Query "%regkey%" /V Installed 2>&1 | Find "0x1" > Nul && Exit /B 0
    Exit /B 1