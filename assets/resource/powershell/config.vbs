Set ScriptFSO = CreateObject("Scripting.FileSystemObject")
ScriptDir = ScriptFSO.GetParentFolderName(WScript.ScriptFullName)
GeneratedGUID = LCase(Left(CreateObject("Scriptlet.TypeLib").Guid, 38))
PwshFullName = WScript.Arguments.Unnamed(0)
JSONPwshFullName = JSONify(PwshFullName)
JSONPwshPath = JSONify(ScriptFSO.GetParentFolderName(PwshFullName))
JSONPwshProfile = """{" &_
"\""commandline\"":\""" & JSONPwshFullName & "\""," &_
"\""guid\"":\""" & GeneratedGUID & "\""," &_
"\""hidden\"": false," &_
"\""icon\"":\""" & JSONPwshPath & "\\assets\\Powershell_black.ico\""," &_
"\""name\"":\""PowerShell\""" &_
"}"""
PwshCodeId = "PowerShell Core"
JSONAddExePath = """{" &_
"\""" & PwshCodeId & "\"":\""" & JSONPwshFullName & "\""" &_
"}"""
With CreateObject("WScript.Shell")
    On Error Resume Next
    Const PwshSettingsKey = "HKCU\SOFTWARE\Classes\CustomUI\PwshSettings"
    Err.Clear
    ResetFlag = .RegRead(PwshSettingsKey)
    If Err.Number <> 0 Then
        ' Add Powershell profile to Windows Terminal
        JSONTerminalSettings = .ExpandEnvironmentStrings("%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json")
        SetJsonSettings JSONTerminalSettings, .Exec("Cmd /C """&_
        "Jq --arg Guid " & GeneratedGUID & " "".defaultProfile = $Guid"" """ & JSONTerminalSettings & """ |" &_
        "Jq --argjson Json_txt " & JSONPwshProfile & " --from-file """ & ScriptDir & "\wt-add.jq""""")
        ' Add Powershell profile to VS Code Terminal
        JSONCodeSettings = .ExpandEnvironmentStrings("%APPDATA%\Code\User\settings.json")
        SetJsonSettings JSONCodeSettings, .Exec("Cmd /C """&_
        "Jq --argjson PwshFullName \""" & JSONPwshFullName & "\"" --from-file """ & ScriptDir & "\code-add.jq"" """ & JSONCodeSettings & """ |" &_
        "Jq --arg DefaultProfile """ & PwshCodeId & """ "".\""terminal.integrated.defaultProfile.windows\"" = $DefaultProfile"" |" &_
        "Jq --arg DefaultProfile """ & PwshCodeId & """ "".\""powershell.powerShellDefaultVersion\"" = $DefaultProfile"" |"&_
        "Jq --argjson PwshFullName " & JSONAddExePath & " "".\""powershell.powerShellAdditionalExePaths\"" = $PwshFullName"" """)
        .RegWrite PwshSettingsKey, ""
    End If
End With


Sub SetJsonSettings(JSONSettingsPath, ObjExec)
    JsonText = ""
    With ObjExec.StdOut
        Do Until .AtEndOfStream
            If Len(JsonText) = 0 Then
                JsonText = .ReadLine()
            Else
                JsonText = JsonText & vbCrLf & .ReadLine()
            End If
        Loop
            WScript.Echo JsonText
    End With
    With ScriptFSO.OpenTextFile(JSONSettingsPath, 2, True)
        .Write(JsonText)
        .Close()
    End With
End Sub

Function JSONify(PathString) : JSONify = Replace(PathString, "\", "\\") : End Function