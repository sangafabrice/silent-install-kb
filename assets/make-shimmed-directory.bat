@Echo OFF

:Main
: 1=:shimmed_directory

MkDir "%~f1" 2> Nul && (
    PushD "%~f1" && (
        Attrib +R . > Nul
        (
            Echo [.ShellClassInfo]
            Echo IconResource=shim.ico,0
        ) > desktop.ini
        Copy /Y "%~dp0shim.ico" shim.ico > Nul
        Attrib +H desktop.ini > Nul
        Attrib +H shim.ico > Nul  
        PopD
    )
)