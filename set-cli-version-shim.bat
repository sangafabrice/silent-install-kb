@Echo OFF

:Main
: 1=:tool_path
: 2=:command_arguments
: 3=:tokens

Echo @Echo OFF
Call "%~dp0write-version-arg-check.bat" "%~1"
Call :WriteVersionQuery "%~1" "%~2" "%~3"
GoTo :EOF

:WriteVersionQuery
    Echo For /F "Tokens=%~3" %%%%V In ^('"%~1" %~2'^) Do ^(
    Echo     Echo %%%%V
    Echo     GoTo :EOF
    Echo ^)