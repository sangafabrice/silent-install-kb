@Echo OFF
PushD "%~dp0"
TaskKill /IM barrier*.exe /F /T > Nul 2>&1
Call assets\main.bat profile:\barrier.exe "%~f1" Inno: "1-3 -gui" non_cli
SetLocal ENABLEDELAYEDEXPANSION
Set program_data=
Call assets\profile.init.bat barrier.exe
If Not EXIST "%program_data%\barrier.exe" GoTo EndInstall
For %%F In ("%program_data%\barrier*.exe") Do (
    If /I "barrier.exe" NEQ "%%~nxF" (
        Echo @"%%~fF" %%*> "%PROFILE_DRIVE_PATH%\%%~nF.bat"
        Set files="%PROFILE_DRIVE_PATH%\%%~nF.bat" !files!<  Nul
    )
)
Echo "%PROFILE_DRIVE_PATH%\barrier.FILE" %files%> "%PROFILE_DRIVE_PATH%\barrier.FILE"
:EndInstall
EndLocal
PopD