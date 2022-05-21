Set Named = WScript.Arguments.Named
With CreateObject("WScript.Shell").CreateShortcut(Named("Shortcut"))
    .TargetPath = Named("Target")
    .WorkingDirectory = CreateObject("Scripting.FileSystemObject").GetParentFolderName(.TargetPath)
    If Named.Exists("Icon") Then .IconLocation = Named("Icon")
    If Named.Exists("Args") Then .Arguments = Named("Args")
    .Save
End With