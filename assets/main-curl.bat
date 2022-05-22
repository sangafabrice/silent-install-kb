@Echo OFF

:Main
: 1=:save_copy_to

PushD "%~dp0"
Set CURL_CA_BUNDLE=%USERPROFILE%\Documents\cURL-CA-CERT\curl-ca-bundle.crt
Call set-system-autorun.bat > Nul
SetLocal ENABLEDELAYEDEXPANSION
Set program_data=
Call profile.init.bat curl
Set app=%program_data%\curl.exe
Set shim=%PROFILE_DRIVE_PATH%\curl.bat
Set LIBCURL_DEF=%PROFILE_DRIVE_PATH%\libcurl.def
Set LIBCURL_DLL=%PROFILE_DRIVE_PATH%\libcurl.dll
Set compare=2
Set version=
Set link=
Call dl-info\GetFrom-Link.bat Curl version link > Nul
Set version_zip=%~f1\%version%.zip
If EXIST "%app%" Call compare-version-cli.bat "%version%" "%ComSpec%" "/C Echo %CURL_VERSION%" compare
If "%compare%"=="2" (
    Call copy-local-link.bat version_zip link version || GoTo EndToLocal
    Call download-unzip-from.bat !link! unzippath curl.exe exepath curl-ca-bundle.crt crtpath libcurl-x64.def defpath libcurl-x64.dll dllpath
    If Not "!exepath!"=="" Call copy-curl.bat "!exepath!" "%app%" > Nul 2>&1
    If Not "!crtpath!"=="" Call :update-curl-certificate "!crtpath!" > Nul
    If Not "!dllpath!"=="" (
        If Not "!defpath!"=="" (
            Copy /Y "!dllpath!" "%LIBCURL_DLL%" > Nul
            Copy /Y "!defpath!" "%LIBCURL_DEF%" > Nul
        )
    )
    If Not "!unzippath!"=="" Call :RemoveUnzipped "!unzippath!"
)
If Not "%~f1"=="" Call save-package.bat "%version_zip%" "%app%" curl.exe "%CURL_CA_BUNDLE%" curl-ca-bundle.crt "%LIBCURL_DLL%" libcurl-x64.dll "%LIBCURL_DEF%" libcurl-x64.def
If EXIST "%app%" (
    Call :write-to-profile
    Call "%shim%" --version > auto-complete\curl
)
:EndToLocal
EndLocal
Call "%PROFILE_DRIVE_PATH%\mod_curl.bat" > Nul 2>&1
PopD
GoTo :EOF

:update-curl-certificate 1=:cert_path
    For /F "Tokens=*" %%C In ("%CURL_CA_BUNDLE%") Do (
        MkDir "%%~dpC" 2> Nul
        Copy /Y "%~1" "%%~dpC"
    )
    GoTo :EOF

:write-to-profile
    (
        Echo Set CURL_VERSION=%version%
        Echo Set CURL_CA_BUNDLE=%CURL_CA_BUNDLE%
    ) > "%PROFILE_DRIVE_PATH%\mod_curl.bat"
    Call set-env-version-shim.bat "%app%" CURL_VERSION > "%PROFILE_DRIVE_PATH%\curl.bat"
    GoTo :EOF

:RemoveUnzipped
    RmDir /S /Q "%~f1" 2> Nul
    If EXIST "%~f1" GoTo RemoveUnzipped