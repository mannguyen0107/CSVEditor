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
#include <ComboConstants.au3>
#include <EditConstants.au3>

#cs
	All array elements detail:
	$g_aLMenu[4][2] - This array contain the left menu labels and child GUI that go with it
	$g_aLMenu[x][0] - Labels
	$g_aLMenu[x][1] - Child GUIs

	g_aSIDEItem[8][3] - This array contain inputbox, checkbox and data read from inputbox
	g_aSIDEItem[x][0] - InputBoxes
	g_aSIDEItem[x][1] - CheckBoxes
	g_aSIDEItem[x][2] - Data read from Input if Checkboxes are checked

	$g_aMAKEInputs[7] - This array contain inputbox and combobox GUI elements of MAKE GUI

	$aMAKEList[1][7] - This array unknown size 2D array contain all vector's infos created by user in MAKE GUI
	$aMAKEList[x][0] - Vector name
	$aMAKEList[x][1] - Side
	$aMAKEList[x][2] - Drop points
	$aMAKEList[x][3] - Add tiles
	$aMAKEList[x][4] - Direction
	$aMAKEList[x][5] - Random X
	$aMAKEList[x][6] - Random Y
#ce

Global $g_sVersion = "v1.0"
Global $g_aLMenu[5][2], $g_aSIDEItem[8][3], $g_aMAKEInputs[7] ; All global array
Global $g_hMainFrm, $g_cBtnNext, $g_cBtnBack, $g_cMAKEListView, $g_cMAKEBtnAdd, $g_cMAKEBtnDel, $g_hNoteEdit, $g_hSavePath ; All global GUI elements
Global $gBtnAddUnderCursor = False, $gBtnDelUnderCursor = False, $g_iMAKEListItem = 0 ; All global variables
Dim $aMAKEList[1][7]

#Region GUI Design
$g_hMainFrm = GUICreate("CSV Editor - " & $g_sVersion, 800, 500, -1, -1)

;Left Menu
$cLMenuBG = GUICtrlCreateLabel("", 0, 0, 210, 500)
GUICtrlSetBkColor($cLMenuBG, $COLOR_WHITE)
GUICtrlSetState($cLMenuBG, $GUI_DISABLE)
$hLogo = GUICtrlCreatePic(@ScriptDir & "\Images\Logo.jpg", 5, 10, 200, 100)
$g_aLMenu[0][0] = GUICtrlCreateLabel("Welcome", 0, 180, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$g_aLMenu[1][0] = GUICtrlCreateLabel("Deciding Attack Side", 0, 220, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$g_aLMenu[2][0] = GUICtrlCreateLabel("Making Drop Points", 0, 260, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$g_aLMenu[3][0] = GUICtrlCreateLabel("Troops Dropping", 0, 300, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$g_aLMenu[4][0] = GUICtrlCreateLabel("Generating CSV", 0, 340, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
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

;Child GUI (Welcome)
$g_aLMenu[0][1] = GUICreate("CSVGEN", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
createHeading("Let's make botting great again!")
createSubHeading("Before get started please select where you want to save your CSV and make some note about your CSV. For example, putting in your name, your CSV's version or troops, spells and CC troops required.")
GUICtrlCreatePic(@ScriptDir & "\Images\SaveIcon.jpg", 50, 150, 20, 20)
$g_hSavePath = GUICtrlCreateInput(@ScriptDir & "Untitled.csv", 85, 150, 380, 20)
$hEditSavePath = GUICtrlCreateButton("Edit", 475, 150, 60, 21)
setBtnStyle($hEditSavePath, 0x767676, 9)
GUICtrlSetState($g_hSavePath, $GUI_DISABLE)
$g_hNoteEdit = GUICtrlCreateEdit("", 50, 200, 200, 220)
GUISetState(@SW_SHOW, $g_aLMenu[0][1])

;Child GUI (SIDE)
$g_aLMenu[1][1] = GUICreate("SIDE", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
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
GUISetState(@SW_SHOW, $g_aLMenu[1][1])

;Child GUI (MAKE)
$g_aLMenu[2][1] = GUICreate("MAKE", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
createHeading("Making drop points")
createSubHeading("Now we will be create drop points so that MBR knows where it should drop your troops.")
;createListView("MAKE", $g_cMAKEListView, 210)
$g_cMAKEListView = GUICtrlCreateListView("Vector|Drop Side|Drop Points|Add Tiles|Direction|Random X|Random Y", 20, 90, 550, 210)
setListViewSize("MAKE", $g_cMAKEListView)
ControlDisable($g_aLMenu[1][1], "", HWnd(_GUICtrlListView_GetHeader($g_cMAKEListView)))
createMAKEInputs("Vector Name", 40, 320, 85, 0, "Input")
createMAKEInputs("Drop Side", 40, 350, 85, 1, "List", "FRONT-RIGHT|FRONT-LEFT|LEFT-FRONT|LEFT-BACK|BACK-LEFT|BACK-RIGHT|RIGHT-BACK|RIGHT-FRONT")
createMAKEInputs("Drop Points", 40, 380, 85, 2, "Input")
createMAKEInputs("Add Tiles", 40, 410, 85, 3, "Input")
createMAKEInputs("Drop Direction", 320, 320, 100, 4, "List", "INT-EXT|EXT-INT")
createMAKEInputs("Random X-Axis", 320, 350, 100, 5, "Input")
createMAKEInputs("Random Y-Axis", 320, 380, 100, 6, "Input")
$g_cMAKEBtnAdd = GUICtrlCreatePic("", 320, 415, 0, 0)
GUICtrlSetImage($g_cMAKEBtnAdd, @ScriptDir & "\Images\BtnAdd_1.jpg")
$g_cMAKEBtnDel = GUICtrlCreatePic("", 440, 415, 0, 0)
GUICtrlSetImage($g_cMAKEBtnDel, @ScriptDir & "\Images\BtnDel_1.jpg")
GUISetState(@SW_SHOW, $g_aLMenu[2][1])

;Child GUI (DROP)
$g_aLMenu[3][1] = GUICreate("DROP", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
createHeading("Where do you want to drop your troops?")
createSubHeading("From all of the vectors we have just created you can use them to drop your troops in.")
createListView("DROP", $g_cMAKEListView, 210)

GUISetState(@SW_SHOW, $g_aLMenu[3][1])

;Child GUI (CSV Generating)
$g_aLMenu[4][1] = GUICreate("CSVGEN", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
GUISetState(@SW_SHOW, $g_aLMenu[4][1])

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

				; Checking if user click on one of the Left Menu label --> enable respective child GUI | exclude last label
				Case $g_aLMenu[0][0] To $g_aLMenu[UBound($g_aLMenu, 1) - 2][0]
					For $i = 0 To UBound($g_aLMenu, 1) - 2
						If $aGUIMsg[0] = $g_aLMenu[$i][0] Then SwitchChildGUI($i)
					Next

				Case $g_cBtnNext
					BtnNextPressed()

				Case $g_cBtnBack
					BtnBackPressed()
			EndSwitch
		Case $g_aLMenu[1][1] ; Child GUI SIDE
			Switch $aGUIMsg[0]
				; Checking if user click on one of the checkbox in SIDE GUI --> enable respective inputbox
				Case $g_aSIDEItem[0][1] To $g_aSIDEItem[UBound($g_aSIDEItem, 1) - 1][1]
					For $r = 0 To UBound($g_aSIDEItem, 1) - 1
						If $aGUIMsg[0] = $g_aSIDEItem[$r][1] Then _Enable($g_aSIDEItem[$r][1], $g_aSIDEItem[$r][0])
					Next
			EndSwitch
		Case $g_aLMenu[2][1] ; Child GUI MAKE
			If Not @error Then
				Select
					; These $aCursorInfo[4] cases are to check if the user hover on one of the buttons in MAKE GUI --> change button img
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

					Case $aGUIMsg[0] = $g_cMAKEBtnAdd
						AddMAKE()

					Case $aGUIMsg[0] = $g_cMAKEBtnDel
						DelMAKE()
				EndSelect
			EndIf
	EndSwitch
	Sleep(1)
WEnd
#EndRegion Main Loop

#Region Main GUI Functions
Func setLMenuLblColor($n, $c) ;This function is for setting the Left Menu labels BG color
	Switch $c
		Case "Default"
			GUICtrlSetBkColor($n, $COLOR_WHITE)
		Case "Selected"
			GUICtrlSetBkColor($n, 0xf4cb42)
	EndSwitch
EndFunc   ;==>setLMenuLblColor

Func setLMenuFontStyle($n) ;This function is for setting the Left Menu labels font styles (size and color)
	For $i = 0 To UBound($g_aLMenu, 1) - 1
		GUICtrlSetColor($n[$i][0], 0x454242)
		GUICtrlSetFont($n[$i][0], 12, 600)
	Next
EndFunc   ;==>setLMenuFontStyle

Func LMenuCheck($default, $menuN) ;This function is for setting Left Menu default GUI when user 1st open the program. Also use to HIDE child GUI that is not selected
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

Func SwitchChildGUI($i) ;This function is for switching between child GUI and to check which GUI suppose to have Next or Back button
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
	If $ar = 7 Then
		$g_aSIDEItem[$ar][0] = GUICtrlCreateCombo("", $x + 60, $y + 25, 100, 20, $CBS_DROPDOWNLIST)
		GUICtrlSetData($g_aSIDEItem[$ar][0], "RANDOM|TOP-LEFT|TOP-RIGHT|BOTTOM-LEFT|BOTTOM-RIGHT")
	Else
		$g_aSIDEItem[$ar][0] = GUICtrlCreateInput("", $x + 60, $y + 25, 100, 20)
	EndIf
	GUICtrlSetFont($g_aSIDEItem[$ar][0], 9, 400)
	$g_aSIDEItem[$ar][1] = GUICtrlCreateCheckbox("", $x + 165, $y + 25, 20, 20)
	GUICtrlSetState($g_aSIDEItem[$ar][0], $GUI_DISABLE)
EndFunc   ;==>createSIDEInputs

Func createListView($name, $var, $h)
	Switch $name
		Case "MAKE"
			Local $sHeaders = "Vector|Drop Side|Drop Points|Add Tiles|Direction|Random X|Random Y", $iArrayPos = 1
		Case "DROP"
			Local $sHeaders = "Vector|Index|Drop Quantity|Troop Name|Delay Drop|Delay Change|Sleep After", $iArrayPos = 2
	EndSwitch
	$var = GUICtrlCreateListView("Vector|Index|Drop Quantity|Troop Name|Delay Drop|Delay Change|Sleep After", 20, 90, 550, 210, $LVS_SORTASCENDING)
	setListViewSize($name, $var)
	ControlDisable($g_aLMenu[$iArrayPos][1], "", HWnd(_GUICtrlListView_GetHeader($var)))
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
			$g_aMAKEInputs[$ar] = GUICtrlCreateInput("", $x + $w, $y, 120, 20)
		Case "List"
			Local $aSplit = StringSplit($list, "|")
			$g_aMAKEInputs[$ar] = GUICtrlCreateCombo("", $x + $w, $y, 120, 20, $CBS_DROPDOWNLIST)
			For $i = 1 To $aSplit[0]
				GUICtrlSetData($g_aMAKEInputs[$ar], $aSplit[$i])
			Next
	EndSwitch
EndFunc   ;==>createMAKEInputs

Func AddMAKE()
	Local $aTempReadInputs[7]
	For $i = 0 To UBound($aTempReadInputs) - 1
		$aTempReadInputs[$i] = GUICtrlRead($g_aMAKEInputs[$i])
	Next
	If $aTempReadInputs[0] = "" Or $aTempReadInputs[1] = "" Or $aTempReadInputs[2] = "" Or $aTempReadInputs[3] = "" Or $aTempReadInputs[4] = "" Or $aTempReadInputs[5] = "" Or $aTempReadInputs[6] = "" Then
		MsgBox(0, "Error", "You cannot leave a field empty!")
	Else
		$g_iMAKEListItem += 1
		ReDim $aMAKEList[$g_iMAKEListItem][7]
		For $i = 0 To UBound($aMAKEList, 2) - 1
			$aMAKEList[$g_iMAKEListItem - 1][$i] = GUICtrlRead($g_aMAKEInputs[$i])
		Next
		ListViewRefresh($g_cMAKEListView, $aMAKEList)
	EndIf
EndFunc   ;==>AddMAKE

Func DelMAKE()
	$iIndex = _GUICtrlListView_GetSelectedIndices($g_cMAKEListView)
	If $iIndex = "" Then
		MsgBox(0, "Error", "Please select a vector to delete")
	Else
		_ArrayDelete($aMAKEList, $iIndex)
		$g_iMAKEListItem -= 1
		ReDim $aMAKEList[$g_iMAKEListItem][7]
		ListViewRefresh($g_cMAKEListView, $aMAKEList)
	EndIf
EndFunc   ;==>DelMAKE

Func ListViewRefresh($listviewhwnd, $array)
	_ArraySort($array, 0, 0, 0, 0)
	_GUICtrlListView_DeleteAllItems($listviewhwnd)
	_GUICtrlListView_AddArray($listviewhwnd, $array)
EndFunc   ;==>ListViewRefresh

Func createHeading($txt)
	GUICtrlCreateLabel($txt, 20, 20, 300)
	GUICtrlSetColor(-1, 0x3D3A39)
	GUICtrlSetFont(-1, 13, 500)
EndFunc   ;==>createHeading

Func createSubHeading($txt)
	GUICtrlCreateLabel($txt, 30, 50, 540, 50)
	GUICtrlSetColor(-1, 0x3D3A39)
	GUICtrlSetFont(-1, 10, 400)
EndFunc   ;==>createSubHeading
#EndRegion Child GUI Functions

#cs
	For $r = 0 To UBound($aMAKEList) - 1
		ConsoleWrite("Row " & $r & ": ")
		For $c = 0 To UBound($aMAKEList, 2) - 1
			ConsoleWrite(" " & $aMAKEList[$r][$c] & " ")
		Next
		ConsoleWrite(@CRLF)
	Next
#ce
