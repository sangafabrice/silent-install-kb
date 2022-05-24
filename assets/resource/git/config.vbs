Const EXCLUDES_FILE = ".excludes-file"
Const GIT_CONFIG = "git config --global"
With CreateObject("Scripting.FileSystemObject")
    GITTXTREG = .BuildPath(.GetParentFolderName(WScript.ScriptFullName), "gittxt.reg")
    With CreateObject("WScript.Shell")
        USERPROFILE = .ExpandEnvironmentStrings("%USERPROFILE%")
        GITUSERNAME = .ExpandEnvironmentStrings("%git_username%")
        GITUSEREMAIL = .ExpandEnvironmentStrings("%git_useremail%")
        GITMACROFILE = .ExpandEnvironmentStrings("%PROFILE_DRIVE_PATH%\doskey_git.macro")
        .Run "Cmd /C """ & GIT_CONFIG &" user.name  """ & GITUSERNAME & """""", 0, True
        .Run "Cmd /C """ & GIT_CONFIG &" user.email """ & GITUSEREMAIL & """""", 0, True
        .Run "Cmd /C """ & GIT_CONFIG &" core.excludesFile ""~/" & EXCLUDES_FILE & """""", 0, True
        .Run "Reg Import " & GITTXTREG & " /Reg:64", 0, True
    End With
    With .OpenTextFile(.BuildPath(USERPROFILE, EXCLUDES_FILE), 2, True)
        .WriteLine("desktop.ini")
        .WriteLine(".bash*")
        .WriteLine(".ico")
        .Close()
    End With
    With .OpenTextFile(GITMACROFILE, 2, True)    
        .WriteLine("GInit=MkDir ""%CD%-mirror"" $T Git init --separate-git-dir """"%cd%-mirror"""" --initial-branch=main . $T Attrib +S +H .git /D")
        .Close()
    End With
End With