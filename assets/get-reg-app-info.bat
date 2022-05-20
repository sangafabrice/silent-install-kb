@Echo OFF

:Main
: 1=:search_zone[CU|LM|LM64]
: 2=:search_string
: [3:=reg_valuename,...]

For /F "UseBackQ Tokens=*" %%V In (`^
    ^(^
        ^(If /I "CU"^=^="%~1" ^(Reg Query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /S /D /F "%~2"^)^) ^& ^
        ^(If /I "LM"^=^="%~1" ^(Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /S /D /F "%~2"^)^) ^& ^
        ^(If /I "LM64"^=^="%~1" ^(Reg Query "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /S /D /F "%~2"^)^) ^
    ^) ^| FindStr /R /B /C:"HKEY_" ^
`) Do (
    Call :QueryValueName "%%~V" %*
    GoTo :EOF
)
GoTo :EOF


:QueryValueName
    Shift /2
    :Loop
    Shift /2
    If Not "%~2"=="" (
        If /I "%~2" EQU "HKEY" ( Set "%~2=%~1" ) Else For /F "Tokens=1,2*" %%N In ('^
            Reg Query "%~1" /S ^|^
            FindStr "%~2" ^|^
            Sort^
        ') Do Set %%~N=%%P
        GoTo Loop
    )
    GoTo :EOF