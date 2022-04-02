@Echo OFF

:Main
: 1=:versioned_package_backup_reference
: 2:=updated_link_reference
: 3:=updated_version_reference
: ERRORLEVEL:=is_link_updated

For /F "Tokens=1* Delims==" %%U In ('Set %~1') Do Call :GetLink "%%~V" %2 %3 %1
Exit /B %ERRORLEVEL%

:GetLink
    Call is-file-path-absolute.bat "%~1" || (
        If Not DEFINED %~2 ( Exit /B 1 ) Else Exit /B 0
    )
    MkDir "%~dp1" 2> Nul
    If Not DEFINED %~2 (
        For %%V In ("%~dp1*%~x1") Do (
            Set %~2=%%~fV
            Set %~3=%%~nV
            Set %~4=%%~fV
            Exit /B 0
        )
        Exit /B 1
    )
    If EXIST "%~f1" Set %~2=%~f1
    Exit /B 0