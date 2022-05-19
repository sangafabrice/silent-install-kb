@Echo OFF

:Main
: 1=:file_path_to_check
: ERRORLEVEL:=is_file_path_absolute

SetLocal
If "%~1"=="" Exit /B 1
Set file_path_to_check=%~1
Set file_path_to_check=%file_path_to_check:\\=\%
If /I "%~dp1" EQU "%file_path_to_check%" Exit /B 1
If /I "%~f1" NEQ "%file_path_to_check%" Exit /B 1
EndLocal
Exit /B 0