@Echo OFF

:Main
: 1=:shell_app_folder_name
: 2=:app_id
For /F "Tokens=2 Delims=\_" %%N In ("%~1") Do (
    (
        Echo Explorer.exe "%~1^!%~2"
        Echo Exit
    ) > "%PROFILE_DRIVE_PATH%\%%~N.appx.bat"
    Echo @Echo OFF
    Echo If Not "%%~1"=="--version" ^(
    Echo     If Not "%%~1"=="-V" ^(
    Echo         Cmd /Q /D /C %%~dp0%%~N.appx.bat
    Echo         GoTo :EOF
    Echo     ^)
    Echo ^)
    Echo For /F %%%%V In ^('PowerShell -Command "& {(Get-AppxPackage %%~N).Version}"'^) Do Echo %%%%V
)
GoTo :EOF