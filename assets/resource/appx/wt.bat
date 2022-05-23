@Echo OFF
For /F "Tokens=1 Delims=_" %%P In ("%~1") Do Call set-appx-version-shim-2.bat wt.exe "%%~P" > "%~2"
Call resource\wt\config.bat > Nul 2>&1