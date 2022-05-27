@Echo OFF
Set versionneddirname=%~f1
If "\"=="%versionneddirname:~-1%" Set versionneddirname=%versionneddirname:~0,-1%
For /F "Tokens=*" %%V In ("%versionneddirname%") Do (
    For %%D In (
        HKCR\Drive\shell\PowerShell%%~nxVx64
        HKCR\Directory\Shell\PowerShell%%~nxVx64
        HKCR\Directory\Background\Shell\PowerShell%%~nxVx64
        HKCR\LibraryFolder\background\shell\PowerShell%%~nxVx64
    ) Do Reg Query %%D > Nul 2>&1 && Reg Add %%D /V Extended /D "" /F /Reg:64 > Nul
)
GoTo :EOF