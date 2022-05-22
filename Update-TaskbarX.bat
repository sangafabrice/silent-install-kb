@Echo OFF
Call "%~dp0assets\main.bat" profile:\taskbarx.exe "%~f1" portable:\zip "* -gui" non_cli
TaskbarX