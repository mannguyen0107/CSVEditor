;#AutoIt3Wrapper_Change2CUI=y
;#pragma compile(Console, true)
#pragma compile(Icon, "Images\csvedit.ico")
#pragma compile(FileDescription, MBR CSV Editor - https://mybot.run)
#pragma compile(ProductName, CSV Editor)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.0)
#pragma compile(LegalCopyright, © https://mybot.run)
#pragma compile(Out, CSVEditor.exe) ; Required

#include <ColorConstantS.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <Array.au3>
#include <GuiListView.au3>

Global $g_sVersion = "v1.0"
Global $g_hMainFrm, $g_aLMenu[4][2], $g_cBtnNext, $g_cBtnBack
Global $g_aSIDEItem[8][3]
Global $g_cMAKEListView, $g_aMAKEList[7][7], $g_aMAKEInputs[7][2], $g_cMAKEBtnAdd, $g_cMAKEBtnDel, $g_cMAKEBtnEdit, $gBtnAddUnderCursor = False, $gBtnDelUnderCursor = False

#Region GUI Design
$g_hMainFrm = GUICreate("CSV Editor - " & $g_sVersion, 800, 500, -1, -1)

;Left Menu
$cLMenuBG = GUICtrlCreateLabel("", 0, 0, 210, 500)
GUICtrlSetBkColor($cLMenuBG, $COLOR_WHITE)
GUICtrlSetState($cLMenuBG, $GUI_DISABLE)
$hLogo = GUICtrlCreatePic(@ScriptDir & "\Images\Logo.jpg", 5, 10, 0, 0)
$g_aLMenu[0][0] = GUICtrlCreateLabel("Deciding Attack Side", 0, 180, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$g_aLMenu[1][0] = GUICtrlCreateLabel("Making Drop Points", 0, 220, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$g_aLMenu[2][0] = GUICtrlCreateLabel("Troops Dropping", 0, 260, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$g_aLMenu[3][0] = GUICtrlCreateLabel("Generating CSV", 0, 300, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
setLMenuFontStyle($g_aLMenu)
addVerticalSeparator(210, 0, 500, "0x999999")

;BottomMenu
$cBMenuBG = GUICtrlCreateLabel("", 211, 450, 589, 50)
GUICtrlSetBkColor($cBMenuBG, $COLOR_WHITE)
GUICtrlSetState($cBMenuBG, $GUI_DISABLE)
$g_cBtnNext = GUICtrlCreateButton("Next >", 680, 460, 100, 30)
setBtnStyle($g_cBtnNext, 0x767676, 10)
$g_cBtnBack = GUICtrlCreateButton("< Back", 550, 460, 100, 30)
setBtnStyle($g_cBtnBack, 0x767676, 10)
addHorizontalSeparator(210, 450, 590, 0x999999)
GUISetState(@SW_SHOW, $g_hMainFrm)

;Child GUI (SIDE)
$g_aLMenu[0][1] = GUICreate("SIDE", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
createHeading("Which side do you want to attack from?")
createSubHeading("Please select and rank from 1 to 10 the most important thing for you when deciding which side to attack from.")
createSIDEInputs("GoldMine.jpg", "Gold Mine", 60, 130, 0)
createSIDEInputs("ElixirCollector.jpg", "Elixir Collector", 60, 200, 1)
createSIDEInputs("DEDrill.jpg", "Dark Elixir Drill", 60, 270, 2)
createSIDEInputs("GoldStorage.jpg", "Gold Storage", 60, 340, 3)
createSIDEInputs("ElixirStorage.jpg", "Elixir Storage", 340, 130, 4)
createSIDEInputs("DEStorage.jpg", "Dark Elixir Storage", 340, 200, 5)
createSIDEInputs("TownHall.jpg", "Town Hall", 340, 270, 6)
createSIDEInputs("ForceSide.jpg", "Force Side", 340, 340, 7)
;GUICtrlSetBkColor(-1, 0xf4cb42)
GUISetState(@SW_SHOW, $g_aLMenu[0][1])

;Child GUI (MAKE)
$g_aLMenu[1][1] = GUICreate("MAKE", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
createHeading("Making drop points")
createSubHeading("Now we will be create drop points so that MBR knows where it should drop your troops.")
createListView("MAKE", $g_cMAKEListView, 210)
createMAKEInputs("Vector Name", 20, 320, 85, 0, "Input")
createMAKEInputs("Drop Side", 20, 350, 85, 0, "List", "A|B|C|D")
createMAKEInputs("Drop Points", 20, 380, 85, 0, "Input")
createMAKEInputs("Add Tiles", 20, 410, 85, 0, "Input")
createMAKEInputs("Drop Direction", 300, 320, 100, 0, "List", "INT-EXT|EXT-INT")
createMAKEInputs("Random X-Axis", 300, 350, 100, 0, "Input")
createMAKEInputs("Random Y-Axis", 300, 380, 100, 0, "Input")
$g_cMAKEBtnAdd = GUICtrlCreatePic("", 300, 415, 0, 0)
GUICtrlSetImage($g_cMAKEBtnAdd, @ScriptDir & "\Images\BtnAdd_1.jpg")
$g_cMAKEBtnDel = GUICtrlCreatePic("", 420, 415, 0, 0)
GUICtrlSetImage($g_cMAKEBtnDel, @ScriptDir & "\Images\BtnDel_1.jpg")
GUISetState(@SW_SHOW, $g_aLMenu[1][1])

;Child GUI (DROP)
$g_aLMenu[2][1] = GUICreate("DROP", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
createHeading("Where do you want to drop your troops?")
createSubHeading("From all of the vectors we have just created you can use them to drop your troops in.")
createListView("DROP", $g_cMAKEListView, 210)

GUISetState(@SW_SHOW, $g_aLMenu[2][1])

;Child GUI (DROP)
$g_aLMenu[3][1] = GUICreate("CSVGEN", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
GUISetState(@SW_SHOW, $g_aLMenu[3][1])

LMenuCheck(True, 0)
#EndRegion GUI Design

#Region Main Loop
While 1
	$aGUIMsg = GUIGetMsg(1) ; Use advanced parameter to get array
	$aCursorInfo = GUIGetCursorInfo()
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
					BtnNextPressed()

				Case $g_cBtnBack
					BtnBackPressed()
			EndSwitch
		Case $g_aLMenu[0][1] ; Child GUI SIDE
			Switch $aGUIMsg[0]
				Case $g_aSIDEItem[0][1] To $g_aSIDEItem[UBound($g_aSIDEItem, 1) - 1][1]
					For $r = 0 To UBound($g_aSIDEItem, 1) - 1
						If $aGUIMsg[0] = $g_aSIDEItem[$r][1] Then _Enable($g_aSIDEItem[$r][1], $g_aSIDEItem[$r][0])
					Next
			EndSwitch
		Case $g_aLMenu[1][1] ; Child GUI MAKE
			Select
				Case $aCursorInfo[4] = $g_cMAKEBtnAdd And $gBtnAddUnderCursor = False
					GUICtrlSetImage($g_cMAKEBtnAdd, @ScriptDir & "\Images\BtnAdd_2.jpg")
					$gBtnAddUnderCursor = True

				Case $aCursorInfo[4] = $g_cMAKEBtnDel And $gBtnDelUnderCursor = False
					GUICtrlSetImage($g_cMAKEBtnDel, @ScriptDir & "\Images\BtnDel_2.jpg")
					$gBtnDelUnderCursor = True

				Case $aCursorInfo[4] <> $g_cMAKEBtnAdd And $gBtnAddUnderCursor
					GUICtrlSetImage($g_cMAKEBtnAdd, @ScriptDir & "\Images\BtnAdd_1.jpg")
					$gBtnAddUnderCursor = False

				Case $aCursorInfo[4] <> $g_cMAKEBtnDel And $gBtnDelUnderCursor
					GUICtrlSetImage($g_cMAKEBtnDel, @ScriptDir & "\Images\BtnDel_1.jpg")
					$gBtnDelUnderCursor = False
			EndSelect
	EndSwitch
	Sleep(1)
WEnd
#EndRegion Main Loop

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
	ElseIf BitAND(WinGetState($g_aLMenu[UBound($g_aLMenu, 1) - 1][1]), 2) Then
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

Func BtnNextPressed()
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
EndFunc   ;==>BtnNextPressed

Func BtnBackPressed()
	For $i = 0 To UBound($g_aLMenu, 1) - 1
		If BitAND(WinGetState($g_aLMenu[$i][1]), 2) Then
			SwitchChildGUI($i - 1)
			ExitLoop
		EndIf
	Next
EndFunc   ;==>BtnBackPressed

Func setBtnStyle($var, $color, $fontsize, $fontcolor = "")
	GUICtrlSetBkColor($var, $color)
	If $fontcolor = "" Then
		GUICtrlSetColor($var, $COLOR_WHITE)
	Else
		GUICtrlSetColor($var, $fontcolor)
	EndIf
	GUICtrlSetFont($var, $fontsize, 700)
EndFunc   ;==>setBtnStyle
#EndRegion Main GUI Functions

#Region Child GUI Functions
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
	GUICtrlSetFont($g_aSIDEItem[$ar][0], 9, 400)
	$g_aSIDEItem[$ar][1] = GUICtrlCreateCheckbox("", $x + 165, $y + 25, 20, 20)
	GUICtrlSetState($g_aSIDEItem[$ar][0], $GUI_DISABLE)
EndFunc   ;==>createSIDEInputs

Func createListView($name, $var, $h)
	Switch $name
		Case "MAKE"
			$var = GUICtrlCreateListView("Vector|Drop Side|Drop Points|Add Tiles|Direction|Random X|Random Y", 20, 90, 550, $h, $LVS_SORTASCENDING)
			setListViewSize($name, $var)
			ControlDisable($g_aLMenu[1][1], "", HWnd(_GUICtrlListView_GetHeader($var)))
		Case "DROP"
			$var = GUICtrlCreateListView("Vector|Index|Drop Quantity|Troop Name|Delay Drop|Delay Change|Sleep After", 20, 90, 550, $h, $LVS_SORTASCENDING)
			setListViewSize($name, $var)
			ControlDisable($g_aLMenu[2][1], "", HWnd(_GUICtrlListView_GetHeader($var)))
	EndSwitch
EndFunc   ;==>createListView

Func setListViewSize($name, $var)
	For $i = 0 To _GUICtrlListView_GetColumnCount($var) - 1
		Switch $name
			Case "MAKE"
				Switch $i
					Case 0
						_GUICtrlListView_SetColumnWidth($var, $i, 50)
					Case 1
						_GUICtrlListView_SetColumnWidth($var, $i, 90)
					Case 5 To 6
						_GUICtrlListView_SetColumnWidth($var, $i, 86)
					Case Else
						_GUICtrlListView_SetColumnWidth($var, $i, 78)
				EndSwitch
			Case "DROP"
				Switch $i
					Case 0
						_GUICtrlListView_SetColumnWidth($var, $i, 50)
					Case 1
						_GUICtrlListView_SetColumnWidth($var, $i, 60)
					Case 2 To 3
						_GUICtrlListView_SetColumnWidth($var, $i, 90)
					Case 4 To 6
						_GUICtrlListView_SetColumnWidth($var, $i, 85)
				EndSwitch
		EndSwitch
		_GUICtrlListView_JustifyColumn($var, $i, 2)
	Next
EndFunc   ;==>setListViewSize

Func createMAKEInputs($txt, $x, $y, $w, $ar, $field, $list = "")
	GUICtrlCreateLabel($txt & ":", $x, $y, $w, 20)
	GUICtrlSetFont(-1, 10, 400)
	Switch $field
		Case "Input"
			$g_aMAKEInputs[$ar][0] = GUICtrlCreateInput("", $x + $w, $y, 120, 20)
		Case "List"
			Local $aSplit = StringSplit($list, "|")
			$g_aMAKEInputs[$ar][0] = GUICtrlCreateCombo("", $x + $w, $y, 120, 20)
			For $i = 1 To $aSplit[0]
				GUICtrlSetData($g_aMAKEInputs[$ar][0], $aSplit[$i])
			Next
	EndSwitch
EndFunc   ;==>createMAKEInputs

Func createHeading($txt)
	GUICtrlCreateLabel($txt, 20, 20, 300)
	GUICtrlSetColor(-1, 0x3D3A39)
	GUICtrlSetFont(-1, 13, 500)
EndFunc   ;==>createHeading

Func createSubHeading($txt)
	GUICtrlCreateLabel($txt, 30, 50, 550, 35)
	GUICtrlSetColor(-1, 0x3D3A39)
	GUICtrlSetFont(-1, 10, 400)
EndFunc   ;==>createSubHeading
#EndRegion Child GUI Functions
