Set ScriptFSO = CreateObject("Scripting.FileSystemObject")
ScriptDir = ScriptFSO.GetParentFolderName(WScript.ScriptFullName)
GeneratedGUID = LCase(Left(CreateObject("Scriptlet.TypeLib").Guid, 38))
Msys2FullName = WScript.Arguments.Unnamed(0)
JSONMsys2FullName = JSONify(Msys2FullName)
JSONMsys2Path = JSONify(ScriptFSO.GetParentFolderName(Msys2FullName))
With CreateObject("WScript.Shell")
    JSONMsys2Profile = """{" &_
    "\""commandline\"":\""" & JSONMsys2FullName & " -defterm -no-start -mingw64\""," &_
    "\""guid\"":\""" & GeneratedGUID & "\""," &_
    "\""hidden\"": false," &_
    "\""icon\"":\""" & JSONMsys2Path & "\\Msys2.ico\""," &_
    "\""startingDirectory\"":\""" & JSONMsys2Path & "\\home\\" & .ExpandEnvironmentStrings("%USERNAME%") & "\""," &_
    "\""name\"":\""MSYS2\""" &_
    "}"""
    ' Add MSYS2 profile to Windows Terminal
    JSONTerminalSettings = .ExpandEnvironmentStrings("%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json")
    SetJsonSettings JSONTerminalSettings, .Exec("Cmd /C """&_
    "Jq --arg Guid " & GeneratedGUID & " "".defaultProfile = $Guid"" """ & JSONTerminalSettings & """ |" &_
    "Jq --argjson Json_txt " & JSONMsys2Profile & " --from-file """ & ScriptDir & "\wt-add.jq""""")
    With ScriptFSO.OpenTextFile(.ExpandEnvironmentStrings("%PROFILE_DRIVE_PATH%\doskey_msys2.macro"), 2, True)    
        .WriteLine("MSYSHere=msys2 -where . -defterm -no-start -mingw64")
        .Close()
    End With
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