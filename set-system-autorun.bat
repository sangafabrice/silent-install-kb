@Echo OFF
If DEFINED PROFILE_SCRIPT If DEFINED PROFILE_DRIVE_PATH GoTo :EOF
For /F "Tokens=*" %%D In ('Call "%~dp0profile.init.bat" autorun_parent') Do (
    MkDir "%%D" 2> Nul
    PushD "%%D" > Nul && (
        Call :WithSystem32ACL %~dp0System32_ACL AutoRun > Nul
        PopD
    )
)
If DEFINED PROFILE_DRIVE_PATH Set PATH=%PROFILE_DRIVE_PATH%;%PATH%
GoTo :EOF

:WithSystem32ACL 1=:System32_ACL 2=:Autorun_folder_name
    Icacls "%windir%\system32" /Save %~f1 /Q > Nul
    Cscript //NoLogo %~dp0change-acl-filename.vbs %~f1 %2
    MkDir %2 2> Nul
    Icacls %2 /InheritanceLevel:D /Q 2> Nul
    Icacls %2 /SetOwner "NT SERVICE\TrustedInstaller" /Q 2> Nul
    Icacls . /Restore %~f1 /Q 2> Nul
    Del /F /Q %~f1
    Cd %2
    Call :WithProfileBat profile.bat
    GoTo :EOF

:WithProfileBat 1=:profile.bat
    If EXIST %1 (
        TakeOwn /F %1 /A
        Icacls %1 /Grant:R BUILTIN\Administrators:F /Q
    )
    (
        Echo @Echo OFF
        Echo For %%%%M In ^("%%~dp0mod_*.bat"^) Do Call "%%~dp0%%%%~nxM" ^> Nul
        Echo For %%%%M In ^("%%~dp0doskey_*.macro"^) Do DosKey /MacroFile="%%~dp0%%%%~nxM"
        Echo Set PROFILE_SCRIPT=%%~f0
        Echo Set PROFILE_DRIVE_PATH=%%~dp0
        Echo Set PROFILE_DRIVE_PATH=%%PROFILE_DRIVE_PATH:~0,-1%%
        Echo Call Set PATH=%%%%PATH:%%PROFILE_DRIVE_PATH%%;=%%%%
        Echo Set PATH=%%PROFILE_DRIVE_PATH%%;%%PATH%%
    ) > %1
    Icacls %1 /InheritanceLevel:D /Q
    Icacls %1 /SetOwner "NT SERVICE\TrustedInstaller" /Q
    Icacls %1 /Grant:R "NT SERVICE\TrustedInstaller":F /Q
    Icacls %1 /Grant:R "NT AUTHORITY\SYSTEM":RX /Q
    Icacls %1 /Grant:R BUILTIN\Administrators:RX /Q
    Reg Add "HKLM\SOFTWARE\Microsoft\Command Processor" /V AutoRun /D "%~f1" /F /Reg:64
    Set PROFILE_SCRIPT=%~f1
    Set PROFILE_DRIVE_PATH=%CD%
    GoTo :EOF