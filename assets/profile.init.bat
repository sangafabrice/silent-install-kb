@Echo OFF
If %~1==autorun_parent Echo %ProgramData%
If %~1==appx Set program_data=C:\Program Files\WindowsApps
If %~1==7z.exe Set program_data=%ProgramData%\7zip
If %~1==autoit Set program_data=%ProgramData%\AutoIt
If %~1==avastbrowser.exe Set program_data=%ProgramData%\AvastSecure
If %~1==barrier.exe Set program_data=%ProgramData%\Barrier
If %~1==blisk.exe Set program_data=%ProgramData%\Blisk
If %~1==brave.exe Set program_data=%ProgramData%\Brave
If %~1==chocolatey Set program_data=%ProgramData%\Chocolatey
If %~1==chrome.exe Set program_data=%ProgramData%\GoogleChrome
If %~1==curl Set program_data=%windir%\System32
If %~1==dotnet.exe Set program_data=%ProgramFiles%\dotnet
If %~1==fiddler.exe Set program_data=%ProgramData%\Fiddler
If %~1==firefox_dev Set program_data=%ProgramData%\FirefoxDeveloperEdition
If %~1==git (
    Set program_data=%ProgramData%\Git
    Set git_username=Full Name
    Set git_useremail=example@email.com
)
If %~1==ksolaunch.exe Set program_data=%ProgramData%\WPSOffice
If %~1==mjml.exe Set program_data=%ProgramData%\MJML
If %~1==mp3tag Set program_data=%ProgramData%\MP3Tag
If %~1==msys2 Set program_data=%ProgramData%\MSYS2
If %~1==node.exe Set program_data=%ProgramData%\NodeJS
If %~1==notepad3 Set program_data=%ProgramData%\Notepad3
If %~1==powershell Set program_data=%ProgramData%\PowerShell
If %~1==powertoys Set program_data=%ProgramData%\CustomUI\PowerToys
If %~1==rainmeter Set program_data=%ProgramData%\CustomUI\Rainmeter
If %~1==ruby Set program_data=%ProgramData%\Ruby
If %~1==sumatrapdf Set program_data=%ProgramData%\SumatraPDF
If %~1==taskbarx.exe Set program_data=%ProgramData%\CustomUI\TaskbarX
If %~1==utweb Set program_data=%ProgramData%\uTorrentWeb
If %~1==vlc.exe Set program_data=%ProgramData%\VLC
If %~1==vscode (
    Set program_data=%ProgramData%\VSCode
    Set ext_dir=%USERPROFILE%\.vscode\extensions
)
If %~1==zoom Set program_data=%ProgramData%\Zoom