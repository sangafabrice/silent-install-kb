@Echo OFF

:Main
: 1=:path_to_shim
: [2=:shim_alias ...]

SetLocal ENABLEDELAYEDEXPANSION
If Not "%~2"=="" (
    PushD "%~f1" && (
        Set path_to_shim=%~1
        If "!path_to_shim:~-1!"=="\" Set path_to_shim=!path_to_shim:~0,-1!
        Set first_shim_arg=%~dp0%~2.bat
        (
            Echo @Echo OFF
            Echo For /F "Tokens=*" %%%%p In ^("%%~n0.exe"^) Do If Not "%%%%~$PATH:p"=="" ^( "%%%%~$PATH:p" %%* ^& GoTo :EOF ^)
            Echo For /F "Tokens=*" %%%%p In ^("%%~n0.bat"^) Do If Not "%%%%~$PATH:p"=="" ^( "%%%%~$PATH:p" %%* ^& GoTo :EOF ^)
            Echo "!path_to_shim!\%%~n0" %%*
        ) > "!first_shim_arg!"
        Call :CopyToNextArg "!first_shim_arg!" %*
        PopD
    )
)
EndLocal
GoTo :EOF

:CopyToNextArg 1=:shim_script_path 2=:path_to_shim [3=:shim_alias ...]
    Shift /2 & Shift /2 & Shift
    Set root=%~dp0
    :LoopShift
    If Not "%1"=="" (
        Copy /Y "%root%%~n0.bat" "%root%%~1.bat" > nul
        Shift
        GoTo :LoopShift
    )
    GoTo :EOF