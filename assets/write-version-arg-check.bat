@Echo OFF

:Main
: 1=:tool_path

Echo If Not "%%~1"=="--version" ^(
Echo     If Not "%%~1"=="-V" ^(
Echo         "%~1" %%*
Echo         GoTo :EOF
Echo     ^)
Echo ^)