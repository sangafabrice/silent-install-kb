On Error Resume Next
Set WshShell = CreateObject("WScript.Shell")
With WshShell
    ExtensionOption = .ExpandEnvironmentStrings(" --extensions-dir ""%ext_dir%""")
    For Each shellObject In Array("Drive", "Directory", "Directory\Background", "*") : ExtendCommand shellObject, "VSCode" : Next
    With .CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk")
        .Arguments = ExtensionOption
        .Save
    End With
End With
GetObject("winmgmts:\\.\root\default:StdRegProv").EnumKey &H80000002, "SOFTWARE\Classes", ShellObjects
For Each object In ShellObjects
    If InStr(1, object, "VSCode.", 1) = 1 Then ExtendCommand object, "open"
Next
ExtendCommand "Applications\Code.exe", "open"
With WshShell
    Const VSCodeSettingsKey = "HKCU\SOFTWARE\Classes\CustomUI\VSCodeSettings"
    Err.Clear
    ResetFlag = .RegRead(VSCodeSettingsKey)
    If Err.Number <> 0 Then
        SettingJSON = .ExpandEnvironmentStrings("%APPDATA%\Code\User\settings.json")
        With CreateObject("Scripting.FileSystemObject")
            CodeSettingJSON = .BuildPath(.GetParentFolderName(WScript.ScriptFullName), "settings.json")
        End With
        .Run "Cmd /C ""Copy /Y """ & CodeSettingJSON & """ """ & SettingJSON & """""", 0, True
        .RegWrite VSCodeSettingsKey, ""
    End If
End With


Sub ExtendCommand(ShellObject, Verb)
    CommandKey = "HKLM\SOFTWARE\Classes\" & ShellObject & "\shell\" & Verb & "\command\"
    With WshShell
        Value = .RegRead(CommandKey)
        If InStr(Value, "--extensions-dir") = 0 Then .RegWrite CommandKey, Value & ExtensionOption, "REG_EXPAND_SZ"  
    End With
End Sub

Private Function BuildPath(FileName)
    With CreateObject("Scripting.FileSystemObject")
        BuildPath = .BuildPath(.GetParentFolderName(WScript.ScriptFullName), FileName)
    End With
End Function