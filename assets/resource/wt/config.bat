@Echo OFF

:Main

PushD "%~dp0"
If /I "/SkipCheck"=="%~1" Goto Skipped
Reg Query HKCU\SOFTWARE\Classes\CustomUI /V "WTSettings" /Reg:64 > Nul 2>&1 &&^
PopD &&^
GoTo :EOF
:Skipped
Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /V "{9F156763-7844-4DC4-B2B1-901F640F5155}" /D "" /F /Reg:64 > Nul 2>&1
Call :WithSettingsJson "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" wt-profile-list.json
Reg Add HKCU\SOFTWARE\Classes\CustomUI /V "WTSettings" /D "" /F /Reg:64 > Nul 2>&1
PopD
GoTo :EOF

:WithSettingsJson 1=:settings_json 2=:profile_list_file
For /F "Tokens=1-3" %%T In (".defaultProfile .profiles.list profile_list") Do (
Type "%~f1" |^
Jq "%%~T, %%~U" > %~2
Jq --slurpfile %%~V %~2 "%%~U = $%%~V[1]" settings.json |^
Jq --slurpfile %%~V %~2 "%%~T = $%%~V[0]" > "%~f1"
)
Del /F /Q %~2 2> Nul