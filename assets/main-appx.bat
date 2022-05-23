@Echo OFF

:Main
: 1=:[profile|default]:\package_name - profile|default winapps volume
: 2=:[profile|default]:\shim_name - profile|default shim installation
: [3=:]save_copy_to
: [4=:]alias/perocess imagename
: [5=:]setup_host_server

PushD "%~dp0"
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set program_data=
Set shim=
For /F "Tokens=1* Delims=\" %%L In ("%~1") Do (
    If /I "Profile:" EQU "%%~L" Call profile.init.bat appx
    Set appxname=PowerShell -Command "& {(Get-AppxPackage %%~nxM).PackageFamilyName}"
)
For /F "Tokens=1* Delims=\" %%L In ("%~2") Do (
    If /I "Profile:" EQU "%%~L" (
        Set shim=%PROFILE_DRIVE_PATH%\%~n2.bat
    ) Else (
        Set shim=%LOCALAPPDATA%\Microsoft\WindowsApps\%~n2.exe
    )
)
Set app_host=Github
If Not ""=="%~5" Set app_host=%~5
Set image_name=%~n2.exe
If Not ""=="%~4" Set image_name=%~4
set compare=2
set version=
set link=
Call dl-info\GetFrom-%app_host%.bat ini\%~n2.ini version link > Nul
%appxname% | FindStr /V /R /C:"^$" > Nul && Call compare-version-cli.bat "%version%" "%shim%" --version compare
If "%compare%"=="2" (
    TaskKill /IM %image_name% /F /T > Nul 2>&1
    Call install-appx-setup.bat "%version%" "%link%" "%program_data%" "%~f3" > Nul
)
For /F %%P In ('%appxname%') Do (
    For /F "Tokens=*" %%S In ("%shim%") Do If ".bat"=="%%~xS" Call resource\appx\%~n2.bat "%%~P" "%%~fS"
    Call "%shim%" --version > auto-complete\translucenttb
)
EndLocal
PopD