@Echo OFF

:Main
: 1=:unzipped_installer
: 2=:shim_path
: 3=:program_data_exe

MkDir "%~dp3" 2> Nul
For /F "Tokens=1" %%V In ('"%~f2" --version 2^> Nul') Do RmDir /S /Q "%~dp3%%~V" 2> Nul
For /F "Tokens=1 Delims= " %%X In ('Dir /S /B "%~f1\%~nx3" 2^> Nul') Do Echo D| XCopy "%%~dpX" "%~dp3" /E /Y /Q > Nul
SetLocal ENABLEDELAYEDEXPANSION
PushD "%~dp3" && (
    For /F "Tokens=*" %%L In ('Dir /S /B .\*Logo.png 2^> Nul') Do (
        Set temp_logo=%%~fL
        Set temp_logo=!temp_logo:%~dp3=!
        If "%%~nxL"=="SmallLogo.png" ( Set small_logo=!temp_logo! ) Else Set big_logo=!temp_logo!
    )
    (
        Echo ^<Application xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'^>
        Echo   ^<VisualElements
        Echo       ShowNameOnSquare150x150Logo='on'
        Echo       Square150x150Logo='!big_logo!'
        Echo       Square70x70Logo='!small_logo!'
        Echo       Square44x44Logo='!small_logo!'
        Echo       ForegroundText='light'
        Echo       BackgroundColor='#5F6368'/^>
        Echo ^</Application^>
    ) > chrome.VisualElementsManifest.xml
    PopD
)
EndLocal