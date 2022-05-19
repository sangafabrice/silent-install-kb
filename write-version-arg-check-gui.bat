@Echo OFF

:Main
: 1=:tool_path

SetLocal ENABLEDELAYEDEXPANSION
Set app=%~1
Set "app=Echo %app:\=^& Echo %"
Set app_dir=
For /F "Tokens=1 Delims=\" %%V In ('%app%') Do If /I "%%~V" NEQ "%~nx1" Set app_dir=!app_dir!%%~V\
Echo If Not "%%~1"=="--version" ^(
Echo     If Not "%%~1"=="-V" ^(
Echo         Start "" /D "%app_dir%" "%~nx1" %%*
Echo         GoTo :EOF
Echo     ^)
Echo ^)
EndLocal