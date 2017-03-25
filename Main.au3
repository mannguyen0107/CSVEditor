;#AutoIt3Wrapper_Change2CUI=y
;#pragma compile(Console, true)
#pragma compile(Icon, "Images\csvgen.ico")
#pragma compile(FileDescription, MBR CSV Generator - https://mybot.run)
#pragma compile(ProductName, CSV Generator)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.0)
#pragma compile(LegalCopyright, © https://mybot.run)
#pragma compile(Out, CSVGen.exe) ; Required

#include <ColorConstantS.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <Array.au3>

Global $g_sVersion = "v1.0"
Global $g_hMainFrm, $g_aLMenu[4][2], $g_cBtnNext, $g_cBtnBack
Global $g_aSIDEItem[8][3]

#Region GUI Design
$g_hMainFrm = GUICreate("CSV Editor - " & $g_sVersion, 800, 500, -1, -1)

;Left Menu
$cLMenuBG = GUICtrlCreateLabel("", 0, 0, 210, 500)
GUICtrlSetBkColor($cLMenuBG, $COLOR_WHITE)
GUICtrlSetState($cLMenuBG, $GUI_DISABLE)
$hLogo = GUICtrlCreatePic(@ScriptDir & "\Images\Logo.jpg", 5, 10, 200, 50)
$g_aLMenu[0][0] = GUICtrlCreateLabel("Deciding Attack Side", 0, 150, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$g_aLMenu[1][0] = GUICtrlCreateLabel("Making Drop Points", 0, 190, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$g_aLMenu[2][0] = GUICtrlCreateLabel("Troops Dropping", 0, 230, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$g_aLMenu[3][0] = GUICtrlCreateLabel("Generating CSV", 0, 270, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
setLMenuFontStyle($g_aLMenu)
addVerticalSeparator(210, 0, 500, "0x999999")

;BottomMenu
$cBMenuBG = GUICtrlCreateLabel("", 211, 450, 589, 50)
GUICtrlSetBkColor($cBMenuBG, $COLOR_WHITE)
GUICtrlSetState($cBMenuBG, $GUI_DISABLE)
$g_cBtnNext = GUICtrlCreateButton("Next >", 680, 460, 100, 30)
$g_cBtnBack = GUICtrlCreateButton("< Back", 550, 460, 100, 30)
addHorizontalSeparator(210, 450, 590, "0x999999")
GUISetState(@SW_SHOW, $g_hMainFrm)

;Child GUI (SIDE)
$g_aLMenu[0][1] = GUICreate("SIDE", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
GUICtrlCreateLabel("Which side do you want to attack from?", 20, 20, 300)
GUICtrlSetColor(-1, 0x3D3A39)
GUICtrlSetFont(-1, 13, 500)
GUICtrlCreateLabel("Please select and rank from 1 to 10 the most important thing for you when deciding which side to attack from.", 30, 50, 550, 35)
GUICtrlSetColor(-1, 0x3D3A39)
GUICtrlSetFont(-1, 10, 400)
createSIDEInputs("GoldMine.jpg", "Gold Mine", 50, 140, 0)
createSIDEInputs("ElixirCollector.jpg", "Elixir Collector", 50, 210, 1)
createSIDEInputs("DEDrill.jpg", "Dark Elixir Drill", 50, 280, 2)
createSIDEInputs("GoldStorage.jpg", "Gold Storage", 50, 350, 3)
createSIDEInputs("ElixirStorage.jpg", "Elixir Storage", 330, 140, 4)
createSIDEInputs("DEStorage.jpg", "Dark Elixir Storage", 330, 210, 5)
createSIDEInputs("TownHall.jpg", "Town Hall", 330, 280, 6)
createSIDEInputs("ForceSide.jpg", "Force Side", 330, 350, 7)
;GUICtrlSetBkColor(-1, 0xf4cb42)
GUISetState(@SW_SHOW, $g_aLMenu[0][1])

;Child GUI (MAKE)
$g_aLMenu[1][1] = GUICreate("MAKE", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
GUISetState(@SW_SHOW, $g_aLMenu[1][1])

;Child GUI (DROP)
$g_aLMenu[2][1] = GUICreate("DROP", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
GUISetState(@SW_SHOW, $g_aLMenu[2][1])

;Child GUI (DROP)
$g_aLMenu[3][1] = GUICreate("CSVGEN", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
GUISetState(@SW_SHOW, $g_aLMenu[3][1])

LMenuCheck(True, 0)
#EndRegion GUI Design


While 1
	$aGUIMsg = GUIGetMsg(1) ; Use advanced parameter to get array
	Switch $aGUIMsg[1] ; check which GUI sent the message
		Case $g_hMainFrm
			Switch $aGUIMsg[0] ; Now check for the messages for $g_hMainFrm
				Case $GUI_EVENT_CLOSE
					Exit
				Case $g_aLMenu[0][0] To $g_aLMenu[UBound($g_aLMenu, 1) - 1][0]
					For $i = 0 To UBound($g_aLMenu, 1) - 1
						If $aGUIMsg[0] = $g_aLMenu[$i][0] Then SwitchChildGUI($i)
					Next
				Case $g_cBtnNext
					For $i = 0 To UBound($g_aLMenu, 1) - 1
						If BitAND(WinGetState($g_aLMenu[$i][1]), 2) Then
							Switch $i
								Case 0
									For $r = 0 To UBound($g_aSIDEItem, 1) - 1
										If IsChecked($g_aSIDEItem[$r][1]) Then
											$g_aSIDEItem[$r][2] = GUICtrlRead($g_aSIDEItem[$r][0])
										Else
											$g_aSIDEItem[$r][2] = ""
										EndIf
									Next
							EndSwitch
							SwitchChildGUI($i + 1)
							;_ArrayDisplay($g_aSIDEItem, "$g_aSIDEItem")
							ExitLoop
						EndIf
					Next
				Case $g_cBtnBack
					For $i = 0 To UBound($g_aLMenu, 1) - 1
						If BitAND(WinGetState($g_aLMenu[$i][1]), 2) Then
							SwitchChildGUI($i - 1)
							ExitLoop
						EndIf
					Next
			EndSwitch
		Case $g_aLMenu[0][0] ; Child GUI SIDE
			Switch $aGUIMsg[0]
				Case $g_aSIDEItem[0][1] To $g_aSIDEItem[UBound($g_aSIDEItem, 1) - 1][1]
					For $r = 0 To UBound($g_aSIDEItem, 1) - 1
						If $aGUIMsg[0] = $g_aSIDEItem[$r][1] Then _Enable($g_aSIDEItem[$r][1], $g_aSIDEItem[$r][0])
					Next
			EndSwitch
	EndSwitch
WEnd

#Region Main GUI Functions
Func setLMenuLblColor($n, $c)
	Switch $c
		Case "Default"
			GUICtrlSetBkColor($n, $COLOR_WHITE)
		Case "Selected"
			GUICtrlSetBkColor($n, 0xf4cb42)
	EndSwitch
EndFunc   ;==>setLMenuLblColor

Func setLMenuFontStyle($n)
	For $i = 0 To UBound($g_aLMenu, 1) - 1
		GUICtrlSetColor($n[$i][0], 0x454242)
		GUICtrlSetFont($n[$i][0], 12, 600)
	Next
EndFunc   ;==>setLMenuFontStyle

Func LMenuCheck($default, $menuN)
	For $i = 0 To UBound($g_aLMenu, 1) - 1
		GUISetBkColor($COLOR_WHITE, $g_aLMenu[$i][1])
		If $default Then
			If $i = $menuN Then
				setLMenuLblColor($g_aLMenu[$i][0], "Selected")
				GUISetState(@SW_SHOW, $g_aLMenu[$i][1])
				GUICtrlSetState($g_cBtnBack, $GUI_HIDE)
			Else
				setLMenuLblColor($g_aLMenu[$i][0], "Default")
				GUISetState(@SW_HIDE, $g_aLMenu[$i][1])
			EndIf
		Else
			setLMenuLblColor($g_aLMenu[$i][0], "Default")
			GUISetState(@SW_HIDE, $g_aLMenu[$i][1])
		EndIf
	Next
EndFunc   ;==>LMenuCheck

Func SwitchChildGUI($i)
	LMenuCheck(False, 0)
	GUISetState(@SW_SHOW, $g_aLMenu[$i][1])
	setLMenuLblColor($g_aLMenu[$i][0], "Selected")
	If BitAND(WinGetState($g_aLMenu[0][1]), 2) Then
		GUICtrlSetState($g_cBtnBack, $GUI_HIDE)
	ElseIf BitAND(WinGetState($g_aLMenu[UBound($g_aLMenu,1) - 1][1]), 2) Then
		GUICtrlSetState($g_cBtnNext, $GUI_DISABLE)
	Else
		GUICtrlSetState($g_cBtnNext, $GUI_ENABLE)
		GUICtrlSetState($g_cBtnBack, $GUI_SHOW)
	EndIf
EndFunc   ;==>SwitchChildGUI

Func addVerticalSeparator($x, $y, $h, $c)
	GUICtrlCreateLabel("", $x, $y, 1, $h)
	GUICtrlSetBkColor(-1, $c)
EndFunc   ;==>addVerticalSeparator

Func addHorizontalSeparator($x, $y, $w, $c)
	GUICtrlCreateLabel("", $x, $y, $w, 1)
	GUICtrlSetBkColor(-1, $c)
EndFunc   ;==>addHorizontalSeparator
#EndRegion Main GUI Functions

#Region Child GUI (SIDE) Functions
Func IsChecked($control)
	Return BitAND(GUICtrlRead($control), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>IsChecked

Func _Enable($check, $input)
	If GUICtrlRead($check) = 1 Then
		GUICtrlSetState($input, $GUI_ENABLE)
	Else
		GUICtrlSetState($input, $GUI_DISABLE)
	EndIf
EndFunc   ;==>_Enable

Func createSIDEInputs($img, $s, $x, $y, $ar)
	GUICtrlCreatePic(@ScriptDir & "\Images\" & $img, $x, $y, 50, 50)
	GUICtrlCreateLabel($s & ":", $x + 60, $y + 10, 100, 15)
	$g_aSIDEItem[$ar][0] = GUICtrlCreateInput("", $x + 60, $y + 25, 100, 20)
	GUICtrlSetFont(-1, 9, 400)
	$g_aSIDEItem[$ar][1] = GUICtrlCreateCheckbox("", $x + 165, $y + 25, 20, 20)
	GUICtrlSetState($g_aSIDEItem[$ar][0], $GUI_DISABLE)
EndFunc   ;==>createSIDEInputs
#EndRegion Child GUI (SIDE) Functions
