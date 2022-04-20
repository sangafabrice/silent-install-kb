@Echo OFF

:Main 
: 1=:download_directory
: 2=:package_link 
: [3=:output_name]
: return:=package_path

SetLocal ENABLEDELAYEDEXPANSION
Set curl_download_vbs=Cscript "%~dp0curl-download.vbs" //B /Url:
PushD "%~f1" > Nul && (
    Echo %~2| FindStr /I /R "^http:// ^https://" > Nul && (
        If Not "%~3"=="" (
            %curl_download_vbs%"%~2" /Output:"%~nx3"
            Call :ReturnLocalPath "%~nx3"
            GoTo End
        ) Else (
            For /F "Tokens=1" %%F In ('^
                Echo %~nx2^|^
                FindStr /C:"%%20"^
            ') Do (
                Set output_name=/output:"%%~nxF"
                Set output_name=!output_name:%%20=_!
            )
            %curl_download_vbs%"%~2" !output_name!
            If DEFINED output_name (
                Call :ReturnLocalPath !output_name:/output:=!
                GoTo End
            )
            Call :ReturnLocalPath "%~nx2"
        )
    )
    Echo %~2| FindStr /I /R "^[A-Z]:\\\\" > Nul && (
        Set save_dir=%~dp2
        For /F "Tokens=*" %%P In ("!save_dir:~0,-1!") Do (
            Copy /Y "%~f2" "%%~nP_%~nx2" > Nul
            Call :ReturnLocalPath "%%~nP_%~nx2"
        )
    )
)
:End
EndLocal
GoTo :EOF

:ReturnLocalPath 1=:local_name
    If EXIST "%~f1" Echo %~f1
    PopD
    GoTo :EOF