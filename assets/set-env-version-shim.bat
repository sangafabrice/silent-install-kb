@Echo OFF

:Main
: 1=:tool_path
: 2=:environment_variable
: 3=:gui_switch=-gui

Echo @Echo OFF
Call "%~dp0write-version-arg-check%~3.bat" "%~f1"
Echo If DEFINED %~2 Echo %%%~2%%