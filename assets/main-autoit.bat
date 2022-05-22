@Echo OFF

:Main
: 1=:save_copy_to

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set program_data=
Call profile.init.bat autoit
Set app=%program_data%\autoit%AUTOIT_MAJOR%.exe
Set shim=%PROFILE_DRIVE_PATH%\autoit.bat
Set compare=2
Set version=
Set major=
Set link=
Call :get-download-info version link major
If DEFINED major Set app=%program_data%\autoit%major%.exe
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%shim%" --version compare
If "%compare%"=="2" Call install-nsis-setup.bat "%version%" "%link%" "%program_data%" "%~f1" > Nul
If EXIST "%app%" (
    If DEFINED major Echo Set "AUTOIT_MAJOR=%major%" > "%PROFILE_DRIVE_PATH%\mod_autoit.bat"
    Call set-version-shim.bat "%app%" * -gui > "%shim%"
    Call "%shim%" --version > auto-complete\autoit
)
EndLocal
Call "%PROFILE_DRIVE_PATH%\mod_autoit.bat" > Nul 2>&1
PopD
GoTo :EOF

:get-download-info 1:=version 2:=link 3:=version_major
    For /F %%V In ('^
        Curl https://www.autoitscript.com/autoit3/docs/history.htm -s ^|^
        Pup ".c3 text{}"^
    ') Do (
        Set %~1=%%V
        For /F "Tokens=1 Delims=." %%M In ("%%V") Do (
            Set %~3=%%M
            Call :get-link %~1 %~2 %%M
        )
        GoTo :EOF
    )
    GoTo :EOF

:get-link 1:=version_ref 2:=link_ref 3:=version_major
    Set base=https://www.autoitscript.com/autoit%~3/files/archive/autoit/
    For /L %%I In (1,1,3) Do If "!%~1:~-2!"==".0" Set %~1=!%~1:~0,-2!
    For /F %%L In ('^
        Curl %base% -s ^|^
        Pup "a[href$=setup.exe] attr{href}" ^|^
        FindStr /B "autoit-v!%~1!"^
    ') Do (
        For /F "Tokens=2 Delims=-" %%V In ("%%L") Do (
            Call compare-version.bat !%~1! %%V | Find "1" > Nul && Set %~2=%base%%%L
            GoTo :EOF
        )
    )
    GoTo :EOF