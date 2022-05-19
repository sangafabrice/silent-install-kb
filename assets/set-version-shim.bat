@Echo OFF

:Main
: 1=:tool_path
: 2=:version_attributes_indexes
: 3=:gui_switch=-gui

Echo @Echo OFF
Echo SetLocal
Call "%~dp0write-version-arg-check%~3.bat" "%~1"
Call :WriteVersionQuery "%~1" "%~2"
GoTo :EOF

:WriteVersionQuery
    Echo Set tool=%~1
    Echo Set tool=%%tool:\=\\%%
    Echo For /F "Skip=1 Tokens=%~2 Delims=." %%%%V In ^('"WMIC DATAFILE WHERE Name="%%tool%%" GET Version" 2^^^> Nul'^) Do ^(
    Call :Switch%~2 2> Nul
    GoTo EndOfSwitch
    :Switch*
    :Switch1
    Echo     Echo %%%%V
    GoTo :EOF
    :Switch1-2
    Echo     Echo %%%%V.%%%%W
    GoTo :EOF
    :Switch1-3
    Echo     Echo %%%%V.%%%%W.%%%%X
    GoTo :EOF
    :EndOfSwitch
    Echo     GoTo EndToLocal
    Echo ^)
    Echo :EndToLocal
    Echo EndLocal
    GoTo :EOF