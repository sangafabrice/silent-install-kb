@Echo OFF

:Main
: 1=:username/repo_pattern
: 2=:package_pattern_string
: 3:=version
: 4:=resource_link

If ""=="%~2" ( Call :get-download-info %1 "/" %3 %4 ) Else Call :get-download-info %*
Exit /B %ERRORLEVEL%

:get-download-info *=:
    PushD "%~dp0"
    If Not ""=="%~3" Set %~3=
    If Not ""=="%~4" Set %~4=
    Call set-shim-path.bat ..\tools Jq
    For /F "Tokens=1-2 Delims=*" %%D In ("%~2") Do (
        For /F "Tokens=*" %%V In ('^
            Curl https://api.github.com/repos/%~1/releases/latest -s ^|^
            Jq ".tag_name, ((.assets|map(select(.name|(contains(\"%%~D\") and endswith(\"%%~E\")))))|.[].browser_download_url)" 2^> Nul^
        ') Do (
            If /I "null" EQU "%%~V" (
                If Not ""=="%~3" Set %~3=
                If Not ""=="%~4" Set %~4=
                PopD
                Exit /B 1
            )
            Echo %%~V| FindStr /I /B /R "http:// https://" > Nul && (
                If Not ""=="%~4" ( Set "%~4=%%~V" ) Else Echo %%~V
                PopD
                Exit /B 0
            )
            If Not ""=="%~3" ( Set "%~3=%%~V" ) Else Echo %%~V
        )
    )
    PopD
    Exit /B 0