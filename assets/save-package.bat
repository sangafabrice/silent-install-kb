@Echo OFF

:Main
: 1=:backup_zip 
: 2=:[[exe_path saved_exe_filename] ...]

SetLocal ENABLEDELAYEDEXPANSION
Call is-file-path-absolute.bat "%~1" || GoTo :EOF
If Not EXIST "%~f1" (
    MkDir "%~dp1" 2> Nul
    PushD "%~dp1" && (
        Call :TestPath %* || (
            PopD
            GoTo :EOF
        )
        Del /F /S /Q "%~dp1*" > Nul 2>&1
        Call :CopySetup %*
        PopD
    )
)
EndLocal
GoTo :EOF

:TestPath 1=:backup_zip [[2=:exe_path 3:=saved_exe_filename] ...]
    Shift & Shift
    If Not "%~0"=="" (
        If Not EXIST "%~0" Exit /B 1
        GoTo TestPath
    )
    Exit /b 0

:CopySetup 1=:backup_zip [[2=:exe_path 3:=saved_exe_filename] ...]
    Set backup_dir=%~dp1
    Set backup_extension=%~x1
    Set backup_filename=%~nx1
    If Not "%backup_extension%"==".zip" (
        Copy /Y  "%~2" ".\%backup_filename%" > Nul
        GoTo :EOF
    )
    If "%~x2"==".zip" (
        If "%~3"=="" (
            Copy /Y  "%~2" ".\%backup_filename%" > Nul
            GoTo :EOF
        )
    )
    :LoopCopy
    Shift & Shift
    If Not "%~0"=="" (
        Copy /Y "%~0" ".\%~1" > Nul
        Set setup_name="%backup_dir%%~1" !setup_name!
        If "%backup_extension%"==".zip" Set setup_name_zip="%~1" !setup_name_zip!
        GoTo LoopCopy
    )
    Tar -cf "%backup_filename%" %setup_name_zip% 2> Nul
    Del /F /S /Q %setup_name% > Nul 2>&1
    GoTo :EOF