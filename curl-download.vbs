Set Named = WScript.Arguments.Named
With CreateObject("WScript.Shell")
    CommandLine = "Curl --location " & Named("Url")
    If Named.Exists("Output") Then
        .Run CommandLine & " --output " & Named("Output"), 0, True
    Else
        .Run CommandLine & " --remote-name", 0, True
    End If
End With