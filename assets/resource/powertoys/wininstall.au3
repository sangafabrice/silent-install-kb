#RequireAdmin
#include <Process.au3>

Run($CmdLine[1])
Local $Count = 6
Local $wTitle = "PowerToys"
Local $hWnd = WinWait($wTitle)
WaitClick($hWnd, "&Options", 1028, $Count)
WaitTextChange($hWnd, $CmdLine[2], 1034, $Count)
WaitClick($hWnd, "&OK", 1036, $Count)
WaitCheck($hWnd, 1031, $Count)
WaitClick($hWnd, "&Install", 1027, $Count)
WaitClick($wTitle, "&Close", 1061, $Count)


Func WaitClick($Handle, $Text, $Id, ByRef $Count)
	Local $CountEnd = $Count - 1
	While $Count <> $CountEnd
		$Count -= ControlClick($Handle, $Text, $Id)
	WEnd
EndFunc

Func WaitCheck($Handle, $Id, ByRef $Count)
	Local $CountEnd = $Count - 1
	While $Count <> $CountEnd
		ControlCommand($Handle, "", $Id, "Check")
		$Count -= ControlCommand($Handle, "", $Id, "IsChecked")
	WEnd
EndFunc

Func WaitTextChange($Handle, $Text, $Id, ByRef $Count)
	Local $CountEnd = $Count - 1
	While $Count <> $CountEnd
		$Count -= ControlSetText($Handle, "", $Id, $Text)
	WEnd
EndFunc