@Echo OFF

:Main
: 1=:winapps_shim
: 2=:package_name

SetLocal
Set PROFILE_DRIVE_PATH=
Echo @Echo OFF
Echo SetLocal ENABLEDELAYEDEXPANSION
Echo If Not "%%~1"=="--version" ^(
Echo     If Not "%%~1"=="-V" ^(
Echo         Set Path=^^!Path:%%PROFILE_DRIVE_PATH%%;=^^!
Echo         Set Path=^^!Path:%%PROFILE_DRIVE_PATH%%=^^!
Echo         Cmd /Q /D /C %~nx1 %%*
Echo         GoTo :EOF
Echo     ^)
Echo ^)
Echo EndLocal
Echo For /F %%%%V In ^('PowerShell -Command "& {(Get-AppxPackage %~2).Version}"'^) Do Echo %%%%V
EndLocal