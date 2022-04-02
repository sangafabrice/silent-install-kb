@Echo OFF

:Main 
: 1=:version_to_check
: 2=:cli_tool_path
: 3=:cli_args
: 4:=comparison_value 

PushD "%~dp0"
Set %~4=2
If EXIST "%~2" For /F "Tokens=*" %%V In ('"%~2" %~3') Do For /F %%C In ('Call compare-version.bat "%~1" "%%~V"') Do Set %~4=%%C
PopD