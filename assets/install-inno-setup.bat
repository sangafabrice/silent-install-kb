@Echo OFF

:Main
: 1=:package_to_install
: 2=:app_id
: 3=:program_data

PushD "%~dp0"
Call :switch-%~2 "%~f3" "%~2" 2> Nul 
GoTo EOS
:switch-audacity
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Audacity
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-barrier
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Barrier
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-eagle
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Autodesk EAGLE
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-ebookreader
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Icecream
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-fdm
    (
        Echo [Setup]
        Echo Lang=english
        Echo Dir=%~f1
        Echo Group=Free Download Manager
        Echo NoIcons=0
        Echo Tasks=quicklaunchicon
    ) > %~2.inno.ini
    GoTo :EOF
:switch-fontforge
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=FontForge
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-gimp
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Gimp
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-git
    (
        Echo [Setup]
        Echo Lang=default
        Echo Dir=%~f1
        Echo Group=Git
        Echo NoIcons=0
        Echo SetupType=default
        Echo Components=ext,ext\shellhere,ext\guihere,gitlfs,assoc,assoc_sh,autoupdate,windowsterminal
        Echo Tasks=
        Echo EditorOption=VisualStudioCode
        Echo CustomEditorPath=
        Echo DefaultBranchOption=main
        Echo PathOption=Cmd
        Echo SSHOption=OpenSSH
        Echo TortoiseOption=false
        Echo CURLOption=OpenSSL
        Echo CRLFOption=CRLFAlways
        Echo BashTerminalOption=MinTTY
        Echo GitPullBehaviorOption=Merge
        Echo UseCredentialManager=Core
        Echo PerformanceTweaksFSCache=Enabled
        Echo EnableSymlinks=Disabled
        Echo EnablePseudoConsoleSupport=Disabled
        Echo EnableFSMonitor=Disabled
    ) > %~2.inno.ini
    GoTo :EOF
:switch-groupmail
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Group Mail
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-hxd
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=HxD
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-innosetup
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Inno Setup
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-itopvpn
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=iTop VPN
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-laragon
    (
        Echo [Setup]
        Echo Lang=english
        Echo Dir=%~f1
        Echo Group=Laragon
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-letsview
    (
        Echo [Setup]
        Echo Lang=english
        Echo Dir=%~f1
        Echo Group=LetsView
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-linqpad
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=LINQPad
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-lsb
    (
        Echo [Setup]
        Echo Lang=english
        Echo Group=Lenovo Service Bridge
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-lunacy
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Lunacy
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-mamp
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=MAMP
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-nexus
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Winstep
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-notepad3
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Notepad3
        Echo NoIcons=0
        Echo Tasks=set_default
    ) > %~2.inno.ini
    GoTo :EOF
:switch-onlyoffice
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Only Office
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-pdfcandy
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Icecream
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-pichon
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Pichon
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-r_lang
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=R
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-ruby
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Ruby
        Echo NoIcons=0
        Echo SetupType=custom
        Echo Components=ruby,rdoc
    ) > %~2.inno.ini
    GoTo :EOF
:switch-simplecss
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Simple CSS
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-skype
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Skype
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-sublimemerge
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Sublime
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-sublimetext
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Sublime
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-vscode
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=Visual Studio Code
        Echo NoIcons=0
        Echo Tasks=addcontextmenufiles,addcontextmenufolders,associatewithfiles
    ) > %~2.inno.ini
    GoTo :EOF
:switch-wampserver
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=WAMP Server
        Echo NoIcons=0
        Echo SetupType=custom
        Echo Components=main,apache,php81,mariadb,mariadb\mariadb106,mysql,mysql\mysql80,apps,apps\phpmyadmin,apps\phpmyadmin49,apps\adminer,apps\phpsysinfo,aestandefault,wampcolors
    ) > %~2.inno.ini
    GoTo :EOF
:switch-webuilder
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=WeBuilder
        Echo NoIcons=0
    ) > %~2.inno.ini
    GoTo :EOF
:switch-winscp
    (
        Echo [Setup]
        Echo Lang=en
        Echo Dir=%~f1
        Echo Group=WinSCP
        Echo NoIcons=0
        Echo SetupType=full
        Echo Tasks=enableupdates,sendtohook,urlhandler
    ) > %~2.inno.ini
    GoTo :EOF
:EOS
Start "" /Wait "%~f1" /VerySilent /LoadInf="%~2.inno.ini" /NoRestart /AllUsers
Del /F /Q "%~2.inno.ini"
PopD