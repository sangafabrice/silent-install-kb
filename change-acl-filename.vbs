'Modify the ACL file by changing the 
'%windir%\system32 filename 'system32'
'by another Directory name

Set UnNamed = WScript.Arguments.Unnamed
AclFilePath = Unnamed(0)
DirName = Unnamed(1)
With CreateObject("Scripting.FileSystemObject").GetFile(AclFilePath)
    With .OpenAsTextStream(1, -1)
        AclText = Replace(.ReadAll(), "system32", DirName, 1, 1, vbTextCompare)
        .Close()
    End With
    With .OpenAsTextStream(2, -1)
        .Write(AclText)
        .Close()
    End With
End With