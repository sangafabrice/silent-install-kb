@Echo OFF

:Main
: 1=:app_full_path
: 2=:search_zone[CU|LM|LM64]
: 3=:string_to_search_in_reg
: 4=:gui_switch=-gui

PushD "%~dp0"
Echo @Echo OFF
Call write-version-arg-check%~4.bat "%~f1"
Echo SetLocal
Echo Call "%%~dp0get-reg-app-info.bat" %~2 "%~3" DisplayVersion
Echo Echo %%DisplayVersion%%
Echo EndLocal
Copy /Y get-reg-app-info.bat "%PROFILE_DRIVE_PATH%" > Nul
PopD