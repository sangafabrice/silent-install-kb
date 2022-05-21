@Echo OFF
PushD "%~dp0assets"
SetLocal ENABLEDELAYEDEXPANSION
Call profile.init.bat vlc.exe
Reg Add "HKLM\SOFTWARE\VideoLAN\VLC" /V InstallDir /D "%program_data%" /F /Reg:64 > Nul
EndLocal
Call main.bat profile:\vlc.exe "%~f1" Nsis: "* -gui" non_cli Link
PopD