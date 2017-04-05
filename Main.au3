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
#include <FontConstants.au3>
#include <String.au3>
#include <ProgressConstants.au3>
#include <GuiRichEdit.au3>

;Opt("MustDeclareVars", 1)

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

	$g_aMAKEList[1][7] - This array is an unknown size 2D array (as we don't know how many vector the user will create so the size will increase as the user create more and more vectors) contain all vector's infos created by user in MAKE GUI
	$g_aMAKEList[x][0] - Vector name
	$g_aMAKEList[x][1] - Side
	$g_aMAKEList[x][2] - Drop points
	$g_aMAKEList[x][3] - Add tiles
	$g_aMAKEList[x][4] - Direction
	$g_aMAKEList[x][5] - Random X
	$g_aMAKEList[x][6] - Random Y
#ce

Global $g_sVersion = "v1.0"
Global $g_aLMenu[5][2], $g_aSIDEItem[8][3], $g_aMAKEInputs[7], $g_aDROPInputs[9], $g_aDROPCommand[2] ; All global array
Global $g_hMainFrm, $g_cBtnNext, $g_cBtnBack, $g_cMAKEListView, $g_cMAKEBtnAdd, $g_cMAKEBtnDel, $g_hNoteEdit, $g_hSavePath, $g_hEditSavePath, $g_sSaveLocation, $g_cDROPListView, $g_cDROPBtnAdd, $g_cDROPBtnDel, $g_hDROPCommandCheck, $g_idCSVProgress, $g_hProgressLog, $g_hProgressTxt ; All global Main GUI elements
Global $gBtnAddUnderCursor = False, $gBtnDelUnderCursor = False, $g_iMAKEListItem = 0, $g_iDROPListItem = 0 ; All global variables
Dim $g_aMAKEList[1][7], $g_aDROPList[1][7], $g_aNOTE[1]

Local $cLMenuBG, $cBMenuBG

#Region GUI Design
$g_hMainFrm = GUICreate("CSV Editor - " & $g_sVersion, 800, 500, -1, -1)
GUISetBkColor($COLOR_WHITE, $g_hMainFrm)

;Left Menu
GUICtrlCreatePic(@ScriptDir & "\Images\Logo.jpg", 5, 10, 200, 100)
$g_aLMenu[0][0] = GUICtrlCreateLabel("Welcome", 0, 180, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$g_aLMenu[1][0] = GUICtrlCreateLabel("Deciding Attack Side", 0, 220, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$g_aLMenu[2][0] = GUICtrlCreateLabel("Making Drop Points", 0, 260, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$g_aLMenu[3][0] = GUICtrlCreateLabel("Troops Dropping", 0, 300, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$g_aLMenu[4][0] = GUICtrlCreateLabel("Generating CSV", 0, 340, 210, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
setLMenuFontStyle($g_aLMenu)
addVerticalSeparator(210, 0, 500, "0x999999")

;BottomMenu
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
$g_hSavePath = GUICtrlCreateInput(@ScriptDir & "\Untitled.csv", 85, 150, 380, 20)
$g_sSaveLocation = @ScriptDir & "\Untitled.csv"
$g_hEditSavePath = GUICtrlCreateButton("Edit", 475, 150, 60, 21)
setBtnStyle($g_hEditSavePath, 0x767676, 9)
GUICtrlSetState($g_hSavePath, $GUI_DISABLE)
GUICtrlCreateLabel("NOTE", 145, 195, 50, 20)
GUICtrlSetFont(-1, 12, 500, $GUI_FONTUNDER)
$g_hNoteEdit = GUICtrlCreateEdit("Author: " & @UserName & " - ver. 1.0" & @CRLF & @CRLF & "Troops: " & @CRLF & "Spells: " & @CRLF & "CC: ", 70, 220, 200, 200)
GUICtrlCreatePic(@ScriptDir & "\Images\BarbKing.jpg", 300, 190, 277, 250)
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
createSubHeading("Now we will be creating drop points so that MBR knows where it should drop your troops.")
;createListView("MAKE", $g_cMAKEListView, 210)
$g_cMAKEListView = GUICtrlCreateListView("Vector|Drop Side|Drop Points|Add Tiles|Direction|Random X|Random Y", 20, 90, 550, 210)
setListViewSize("MAKE", $g_cMAKEListView)
ControlDisable($g_aLMenu[1][1], "", HWnd(_GUICtrlListView_GetHeader($g_cMAKEListView)))
createVectorInputs("Vector Name", 40, 320, 85, 0, "Input", "MAKE")
createVectorInputs("Drop Side", 40, 350, 85, 1, "List", "MAKE", "FRONT-RIGHT|FRONT-LEFT|LEFT-FRONT|LEFT-BACK|BACK-LEFT|BACK-RIGHT|RIGHT-BACK|RIGHT-FRONT")
createVectorInputs("Drop Points", 40, 380, 85, 2, "Input", "MAKE")
createVectorInputs("Add Tiles", 40, 410, 85, 3, "Input", "MAKE")
createVectorInputs("Drop Direction", 320, 320, 100, 4, "List", "MAKE", "INT-EXT|EXT-INT")
createVectorInputs("Random X-Axis", 320, 350, 100, 5, "Input", "MAKE")
createVectorInputs("Random Y-Axis", 320, 380, 100, 6, "Input", "MAKE")
$g_cMAKEBtnAdd = GUICtrlCreatePic("", 320, 415, 0, 0)
GUICtrlSetImage($g_cMAKEBtnAdd, @ScriptDir & "\Images\BtnAdd_1.bmp")
$g_cMAKEBtnDel = GUICtrlCreatePic("", 440, 415, 0, 0)
GUICtrlSetImage($g_cMAKEBtnDel, @ScriptDir & "\Images\BtnDel_1.bmp")
GUISetState(@SW_SHOW, $g_aLMenu[2][1])

;Child GUI (DROP)
$g_aLMenu[3][1] = GUICreate("DROP", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
createHeading("Where do you want to drop your troops?")
createSubHeading("From all of the vectors we have just created you can use them to drop your troops in.")
$g_cDROPListView = GUICtrlCreateListView("Vector|Index|Drop Quantity|Troop Name|Delay Drop|Delay Change|Sleep After", 20, 90, 550, 210)
setListViewSize("DROP", $g_cDROPListView)
ControlDisable($g_aLMenu[3][1], "", HWnd(_GUICtrlListView_GetHeader($g_cDROPListView)))
createVectorInputs("Vector Name", 20, 320, 85, 0, "Input", "DROP")
createVectorInputs("Drop Index", 20, 350, 85, 1, "Input", "DROP")
createVectorInputs("Drop Quantity", 20, 380, 85, 2, "Input", "DROP")
createVectorInputs("Troop Name", 20, 410, 85, 3, "List", "DROP", "Barbarian|Archer|Giant|Goblin|Wall Breaker|Balloon|Wizard|Ice Wizard|Healer|Dragon|Pekka|Baby Dragon|Miner|Minion|Hog Rider|Valkyrie|Golem|Witch|Lava Hound|Bowler|Barbarian King|Archer Queen|Grand Warden|Clan Castle|Lightning Spell|Heal Spell|Rage Spell|Jump Spell|Clone Spell|Freeze Spell|Poison Spell|Earthquake Spell|Haste Spell|Skeleton Spell")
createVectorInputs("Delay Drop", 280, 320, 100, 4, "Input", "DROP")
createVectorInputs("Delay Change", 280, 350, 100, 5, "Input", "DROP")
createVectorInputs("Sleep After", 280, 380, 100, 6, "Input", "DROP")
GUICtrlCreateLabel("Command:", 280, 410, 100, 20)
GUICtrlSetFont(-1, 10, 400)
$g_aDROPInputs[7] = GUICtrlCreateCombo("", 380, 410, 60, 20, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_DROPDOWNLIST))
GUICtrlSetData($g_aDROPInputs[7], "WAIT|RECALC")
$g_aDROPInputs[8] = GUICtrlCreateInput("", 450, 410, 50, 20)
$g_hDROPCommandCheck = GUICtrlCreateCheckbox("", 510, 410, 20, 20)
GUICtrlSetState($g_aDROPInputs[7], $GUI_DISABLE)
GUICtrlSetState($g_aDROPInputs[8], $GUI_DISABLE)
$g_cDROPBtnAdd = GUICtrlCreatePic("", 530, 330, 0, 0)
GUICtrlSetImage($g_cDROPBtnAdd, @ScriptDir & "\Images\iconAdd_1.bmp")
$g_cDROPBtnDel = GUICtrlCreatePic("", 530, 370, 0, 0)
GUICtrlSetImage($g_cDROPBtnDel, @ScriptDir & "\Images\iconDelete_1.bmp")
GUISetState(@SW_SHOW, $g_aLMenu[3][1])

;Child GUI (CSV Generating)
$g_aLMenu[4][1] = GUICreate("CSVGEN", 589, 450, 211, 0, $WS_POPUP, $WS_EX_MDICHILD, $g_hMainFrm)
createHeading("Generating CSV")
createSubHeading("Now just sit back and relax. Your CSV will be ready in a moment!")
$g_hProgressTxt = GUICtrlCreateLabel("Writing CSV file...", 30, 100, 160, 20)
GUICtrlSetFont(-1, 9, 400)
$g_idCSVProgress = GUICtrlCreateProgress(30, 130, 530, 25)
$g_hProgressLog = _GUICtrlRichEdit_Create($g_aLMenu[4][1], "", 30, 170, 530, 250, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL))
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
					$iExit = MsgBox(36, "Unsaved csv", "Are you sure you want to quit? Any changes you made without saving will be lost")
					If $iExit = 6 Then
						ExitLoop
					Else
						Sleep(1)
					EndIf

					#cs
						; Checking if user click on one of the Left Menu label --> enable respective child GUI | exclude last label
						Case $g_aLMenu[0][0] To $g_aLMenu[UBound($g_aLMenu, 1) - 1][0]
						For $i = 0 To UBound($g_aLMenu, 1) - 1
						If $aGUIMsg[0] = $g_aLMenu[$i][0] Then SwitchChildGUI($i)
						Next
					#ce

				Case $g_cBtnNext
					BtnNextPressed()

				Case $g_cBtnBack
					BtnBackPressed()
			EndSwitch
		Case $g_aLMenu[0][1]
			Switch $aGUIMsg[0]
				Case $g_hEditSavePath
					SelectSavePath()
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
						GUICtrlSetImage($g_cMAKEBtnAdd, @ScriptDir & "\Images\BtnAdd_2.bmp")
						$gBtnAddUnderCursor = True

					Case $aCursorInfo[4] = $g_cMAKEBtnDel And $gBtnDelUnderCursor = False
						GUICtrlSetImage($g_cMAKEBtnDel, @ScriptDir & "\Images\BtnDel_2.bmp")
						$gBtnDelUnderCursor = True

					Case $aCursorInfo[4] <> $g_cMAKEBtnAdd And $gBtnAddUnderCursor
						GUICtrlSetImage($g_cMAKEBtnAdd, @ScriptDir & "\Images\BtnAdd_1.bmp")
						$gBtnAddUnderCursor = False

					Case $aCursorInfo[4] <> $g_cMAKEBtnDel And $gBtnDelUnderCursor
						GUICtrlSetImage($g_cMAKEBtnDel, @ScriptDir & "\Images\BtnDel_1.bmp")
						$gBtnDelUnderCursor = False

					Case $aGUIMsg[0] = $g_cMAKEBtnAdd
						AddMAKE()

					Case $aGUIMsg[0] = $g_cMAKEBtnDel
						DelMAKE()
				EndSelect
			EndIf
		Case $g_aLMenu[3][1] ; Child GUI DROP
			If Not @error Then
				Select
					Case $aGUIMsg[0] = $g_hDROPCommandCheck
						For $1 = 0 To UBound($g_aDROPInputs) - 1
							If $1 = 7 Or $1 = 8 Then
								_Enable($g_hDROPCommandCheck, $g_aDROPInputs[$1])
							Else
								_Disable($g_hDROPCommandCheck, $g_aDROPInputs[$1])
							EndIf
						Next

					Case $aCursorInfo[4] = $g_cDROPBtnAdd And $gBtnAddUnderCursor = False
						GUICtrlSetImage($g_cDROPBtnAdd, @ScriptDir & "\Images\iconAdd_2.bmp")
						$gBtnAddUnderCursor = True

					Case $aCursorInfo[4] = $g_cDROPBtnDel And $gBtnDelUnderCursor = False
						GUICtrlSetImage($g_cDROPBtnDel, @ScriptDir & "\Images\iconDelete_2.bmp")
						$gBtnDelUnderCursor = True

					Case $aCursorInfo[4] <> $g_cDROPBtnAdd And $gBtnAddUnderCursor
						GUICtrlSetImage($g_cDROPBtnAdd, @ScriptDir & "\Images\iconAdd_1.bmp")
						$gBtnAddUnderCursor = False

					Case $aCursorInfo[4] <> $g_cDROPBtnDel And $gBtnDelUnderCursor
						GUICtrlSetImage($g_cDROPBtnDel, @ScriptDir & "\Images\iconDelete_1.bmp")
						$gBtnDelUnderCursor = False

					Case $aGUIMsg[0] = $g_cDROPBtnAdd
						AddDROP()

					Case $aGUIMsg[0] = $g_cDROPBtnDel
						DelDROP()
				EndSelect
			EndIf
	EndSwitch
	Sleep(1)
WEnd
Exit
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
	Local $nSwitch = 0
	For $i = 0 To UBound($g_aLMenu, 1) - 1
		If BitAND(WinGetState($g_aLMenu[$i][1]), 2) Then
			Switch $i
				Case 0
					$sNOTERead = GUICtrlRead($g_hNoteEdit)
					$aNOTESplit = StringSplit($sNOTERead, @CRLF, 3)
					ReDim $g_aNOTE[UBound($aNOTESplit)]
					$g_aNOTE = $aNOTESplit
					$nSwitch = 1
				Case 1
					For $r = 0 To UBound($g_aSIDEItem, 1) - 1
						If IsChecked($g_aSIDEItem[$r][1]) Then
							$g_aSIDEItem[$r][2] = GUICtrlRead($g_aSIDEItem[$r][0])
						Else
							$g_aSIDEItem[$r][2] = ""
						EndIf
					Next
					If $g_aSIDEItem[0][2] = "" And $g_aSIDEItem[1][2] = "" And $g_aSIDEItem[2][2] = "" And $g_aSIDEItem[3][2] = "" And $g_aSIDEItem[4][2] = "" And $g_aSIDEItem[5][2] = "" And $g_aSIDEItem[6][2] = "" And $g_aSIDEItem[7][2] = "" Then
						MsgBox(16, "Error", "You have to check at least 1 condition so that MBR know which side to attack from.")
					Else
						$nSwitch = 1
					EndIf
				Case 2
					If $g_aMAKEList[0][0] = "" Then
						MsgBox(16, "Error", "You have to create at least 1 vector. Without vectors MBR will not know where to drop your troops.")
					Else
						$nSwitch = 1
					EndIf
				Case 3
					If $g_aDROPList[0][0] = "" Then
						MsgBox(16, "Error", "You have not create any drop informations. Without drop commands MBR will not know which vectors to use and what troops it should drop.")
					Else
						SwitchChildGUI($i + 1)
						CSVGen()
					EndIf
			EndSwitch
			If $nSwitch Then
				SwitchChildGUI($i + 1)
			EndIf
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

Func _Disable($check, $input)
	If GUICtrlRead($check) = 1 Then
		GUICtrlSetState($input, $GUI_DISABLE)
	Else
		GUICtrlSetState($input, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_Disable

Func createSIDEInputs($img, $s, $x, $y, $ar)
	GUICtrlCreatePic(@ScriptDir & "\Images\" & $img, $x, $y, 50, 50)
	GUICtrlCreateLabel($s & ":", $x + 60, $y + 10, 100, 15)
	If $ar = 7 Then
		$g_aSIDEItem[$ar][0] = GUICtrlCreateCombo("", $x + 60, $y + 25, 100, 20, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_DROPDOWNLIST))
		GUICtrlSetData($g_aSIDEItem[$ar][0], "RANDOM|TOP-LEFT|TOP-RIGHT|BOTTOM-LEFT|BOTTOM-RIGHT")
	Else
		$g_aSIDEItem[$ar][0] = GUICtrlCreateInput("", $x + 60, $y + 25, 100, 20)
	EndIf
	GUICtrlSetFont($g_aSIDEItem[$ar][0], 9, 400)
	$g_aSIDEItem[$ar][1] = GUICtrlCreateCheckbox("", $x + 165, $y + 25, 20, 20)
	GUICtrlSetState($g_aSIDEItem[$ar][0], $GUI_DISABLE)
EndFunc   ;==>createSIDEInputs

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

Func createVectorInputs($txt, $x, $y, $w, $ar, $field, $GUIname, $list = "")
	GUICtrlCreateLabel($txt & ":", $x, $y, $w, 20)
	GUICtrlSetFont(-1, 10, 400)
	Switch $field
		Case "Input"
			Switch $GUIname
				Case "MAKE"
					$g_aMAKEInputs[$ar] = GUICtrlCreateInput("", $x + $w, $y, 120, 20, $ES_UPPERCASE)
				Case "DROP"
					$g_aDROPInputs[$ar] = GUICtrlCreateInput("", $x + $w, $y, 120, 20, $ES_UPPERCASE)
			EndSwitch
		Case "List"
			Switch $GUIname
				Case "MAKE"
					$g_aMAKEInputs[$ar] = GUICtrlCreateCombo("", $x + $w, $y, 120, 20, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_DROPDOWNLIST))
					GUICtrlSetData($g_aMAKEInputs[$ar], $list)
					GUICtrlSendMsg($g_aMAKEInputs[$ar], $CB_SETMINVISIBLE, 10, 0)
				Case "DROP"
					$g_aDROPInputs[$ar] = GUICtrlCreateCombo("", $x + $w, $y, 120, 20, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_DROPDOWNLIST))
					GUICtrlSetData($g_aDROPInputs[$ar], $list)
					GUICtrlSendMsg($g_aDROPInputs[$ar], $CB_SETMINVISIBLE, 10, 0)
			EndSwitch
	EndSwitch
EndFunc   ;==>createVectorInputs

Func AddMAKE()
	Local $aTempReadInputs[7]
	For $i = 0 To UBound($aTempReadInputs) - 1
		$aTempReadInputs[$i] = GUICtrlRead($g_aMAKEInputs[$i])
	Next
	Local $iSearchDuplicate = _ArraySearch($g_aMAKEList, $aTempReadInputs[0], 0, 0, 0, 0, 1, 0)
	If $aTempReadInputs[0] = "" Or $aTempReadInputs[1] = "" Or $aTempReadInputs[2] = "" Or $aTempReadInputs[3] = "" Or $aTempReadInputs[4] = "" Or $aTempReadInputs[5] = "" Or $aTempReadInputs[6] = "" Then
		MsgBox(16, "Error", "You cannot leave a field empty!")
	ElseIf Not @error Then
		MsgBox(16, "Error", "Vector's name can not be duplicated!")
	Else
		$g_iMAKEListItem += 1
		ReDim $g_aMAKEList[$g_iMAKEListItem][7]
		For $i = 0 To UBound($g_aMAKEList, 2) - 1
			$g_aMAKEList[$g_iMAKEListItem - 1][$i] = GUICtrlRead($g_aMAKEInputs[$i])
		Next
		ListViewRefresh($g_cMAKEListView, $g_aMAKEList, "MAKE")
	EndIf
EndFunc   ;==>AddMAKE

Func DelMAKE()
	$iIndex = _GUICtrlListView_GetSelectedIndices($g_cMAKEListView)
	If $iIndex = "" Then
		MsgBox(16, "Error", "Please select a vector to delete")
	Else
		_ArrayDelete($g_aMAKEList, $iIndex)
		$g_iMAKEListItem -= 1
		ReDim $g_aMAKEList[$g_iMAKEListItem][7]
		ListViewRefresh($g_cMAKEListView, $g_aMAKEList, "MAKE")
	EndIf
EndFunc   ;==>DelMAKE

Func ListViewRefresh($listviewhwnd, $array, $n)
	If $n = "MAKE" Then
		_ArraySort($array, 0, 0, 0, 0)
	EndIf
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

Func SelectSavePath()
	$sCurrentSaveLocation = GUICtrlRead($g_hSavePath)
	$g_sSaveLocation = FileSaveDialog("Save CSV", @ScriptDir, "CSV files (*.csv)", 16)
	If @error = 1 Then
		$g_sSaveLocation = $sCurrentSaveLocation
	EndIf
	GUICtrlSetData($g_hSavePath, $g_sSaveLocation)
EndFunc   ;==>SelectSavePath

Func AddDROP()
	If IsChecked($g_hDROPCommandCheck) Then
		Local $aTempReadInputs[2]
		$aTempReadInputs[0] = GUICtrlRead($g_aDROPInputs[7])
		$aTempReadInputs[1] = GUICtrlRead($g_aDROPInputs[8])
		If $aTempReadInputs[0] = "" And $aTempReadInputs[1] = "" Then
			MsgBox(16, "Error", "Please select a command you would like to add.")
		ElseIf $aTempReadInputs[0] = "WAIT" Then
			If $aTempReadInputs[1] = "" Then
				MsgBox(16, "Error", "Please enter how long do you want wait in Miliseconds (1s = 1000ms).")
			Else
				$g_iDROPListItem += 1
				ReDim $g_aDROPList[$g_iDROPListItem][7]
				For $1 = 0 To UBound($g_aDROPList, 2) - 1
					If $1 > 1 Then
						$g_aDROPList[$g_iDROPListItem - 1][$1] = ""
					Else
						$g_aDROPList[$g_iDROPListItem - 1][$1] = $aTempReadInputs[$1]
					EndIf
				Next
				ListViewRefresh($g_cDROPListView, $g_aDROPList, "DROP")
			EndIf
		ElseIf $aTempReadInputs[0] = "RECALC" Then
			$g_iDROPListItem += 1
			ReDim $g_aDROPList[$g_iDROPListItem][7]
			For $1 = 0 To UBound($g_aDROPList, 2) - 1
				If $1 = 0 Then
					$g_aDROPList[$g_iDROPListItem - 1][$1] = $aTempReadInputs[$1]
				Else
					$g_aDROPList[$g_iDROPListItem - 1][$1] = ""
				EndIf
			Next
			ListViewRefresh($g_cDROPListView, $g_aDROPList, "DROP")
		EndIf
	Else
		Local $aTempReadInputs[7]
		For $i = 0 To UBound($aTempReadInputs) - 1
			$aTempReadInputs[$i] = GUICtrlRead($g_aDROPInputs[$i])
		Next
		If $aTempReadInputs[0] = "" Or $aTempReadInputs[1] = "" Or $aTempReadInputs[2] = "" Or $aTempReadInputs[3] = "" Or $aTempReadInputs[4] = "" Or $aTempReadInputs[5] = "" Or $aTempReadInputs[6] = "" Then
			MsgBox(16, "Error", "You cannot leave a field empty!")
		Else
			$g_iDROPListItem += 1
			ReDim $g_aDROPList[$g_iDROPListItem][7]
			For $i = 0 To UBound($g_aDROPList, 2) - 1
				$g_aDROPList[$g_iDROPListItem - 1][$i] = $aTempReadInputs[$i]
			Next
			ListViewRefresh($g_cDROPListView, $g_aDROPList, "DROP")
		EndIf
	EndIf
EndFunc   ;==>AddDROP

Func DelDROP()
	$iIndex = _GUICtrlListView_GetSelectedIndices($g_cDROPListView)
	If $iIndex = "" Then
		MsgBox(16, "Error", "Please select a vector to delete")
	Else
		_ArrayDelete($g_aDROPList, $iIndex)
		$g_iDROPListItem -= 1
		ReDim $g_aDROPList[$g_iDROPListItem][7]
		ListViewRefresh($g_cDROPListView, $g_aDROPList, "DROP")
	EndIf
EndFunc   ;==>DelDROP

Func CSVGen()
	Local $iFileExists = FileExists($g_sSaveLocation)
	If $iFileExists Then FileDelete($g_sSaveLocation)
	Local $iSpaces = 11, $iGetLength
	Local $aHeaders[3] = ["      |EXTR. GOLD |EXTR.ELIXIR|EXTR. DARK |DEPO. GOLD |DEPO.ELIXIR|DEPO. DARK |TOWNHALL   |FORCED SIDE|", "      |VECTOR_____|SIDE_______|DROP_POINTS|ADDTILES___|VERSUS_____|RANDOMX_PX_|RANDOMY_PX_|___________|", "      |VECTOR_____|INDEX______|QTY_X_VECT_|TROOPNAME__|DELAY_DROP_|DELAYCHANGE|SLEEPAFTER_|___________|"]

	;Create dictionary to store troops name and troops code to convert normal troops name to MBR troops code (eg: Barbarian = Barb)
	Local $aTroopsName[34] = ["Barbarian", "Archer", "Giant", "Goblin", "Wall Breaker", "Balloon", "Wizard", "Ice Wizard", "Healer", "Dragon", "Pekka", "Baby Dragon", "Miner", "Minion", "Hog Rider", "Valkyrie", "Golem", "Witch", "Lava Hound", "Bowler", "Barbarian King", "Archer Queen", "Grand Warden", "Clan Castle", "Lightning Spell", "Heal Spell", "Rage Spell", "Jump Spell", "Clone Spell", "Freeze Spell", "Poison Spell", "Earthquake Spell", "Haste Spell", "Skeleton Spell"]
	Local $aTroopsCode[34] = ["Barb", "Arch", "Giant", "Gobl", "Wall", "Ball", "Wiza", "IceW", "Heal", "Drag", "Pekk", "BabyD", "Mine", "Mini", "Hogs", "Valk", "Gole", "Witc", "Lava", "Bowl", "King", "Queen", "Warden", "Castle", "LSpell", "HSpell", "RSpell", "JSpell", "CSpell", "FSpell", "PSpell", "ESpell", "HaSpell", "SkSpell"]
	Local $aTroopsDic[34]
	For $1 = 0 To UBound($aTroopsDic) - 1
		$aTroopsDic[$1] = ObjCreate("Scripting.Dictionary")
		$aTroopsDic[$1]($aTroopsName[$1]) = $aTroopsCode[$1]
	Next
	GUICtrlSetData($g_idCSVProgress, 25)
	_GUICtrlRichEdit_AppendText($g_hProgressLog, "Converting troops name into MBR troops code..." & @CRLF)
	;For $1 = 0 To UBound($aTroopsDic) - 1
	;	$aTroopsDic[$1]($aTroopsName[$1]) = $aTroopsCode[$1]
	;Next

	;Write NOTE
	_GUICtrlRichEdit_AppendText($g_hProgressLog, "Writing NOTE section..." & @CRLF)
	For $1 = 0 To UBound($g_aNOTE) - 1
		FileWrite($g_sSaveLocation, "NOTE  |" & $g_aNOTE[$1] & @CRLF)
		GUICtrlSetData($g_idCSVProgress, 1)
	Next
	FileWrite($g_sSaveLocation, @CRLF) ;Create a blank line

	;Write SIDE
	FileWrite($g_sSaveLocation, $aHeaders[0] & @CRLF) ;Write SIDE headers
	FileWrite($g_sSaveLocation, "SIDE  |")
	GUICtrlSetData($g_idCSVProgress, 25)
	_GUICtrlRichEdit_AppendText($g_hProgressLog, "Writing SIDE section..." & @CRLF)
	For $1 = 0 To UBound($g_aSIDEItem, 1) - 1
		If $g_aSIDEItem[$1][2] = "" Then
			FileWrite($g_sSaveLocation, _StringRepeat(" ", $iSpaces) & "|")
		Else
			$iGetLength = StringLen($g_aSIDEItem[$1][2])
			FileWrite($g_sSaveLocation, $g_aSIDEItem[$1][2] & _StringRepeat(" ", ($iSpaces - $iGetLength)) & "|")
		EndIf
	Next
	FileWrite($g_sSaveLocation, @CRLF & @CRLF) ;Create a blank line

	;Write MAKE
	FileWrite($g_sSaveLocation, $aHeaders[1] & @CRLF) ;Write MAKE headers
	GUICtrlSetData($g_idCSVProgress, 25)
	_GUICtrlRichEdit_AppendText($g_hProgressLog, "Writing MAKE section..." & @CRLF)
	For $r = 0 To UBound($g_aMAKEList) - 1
		FileWrite($g_sSaveLocation, "MAKE  |")
		For $c = 0 To UBound($g_aMAKEList, 2) - 1
			$iGetLength = StringLen($g_aMAKEList[$r][$c])
			If $c = (UBound($g_aMAKEList, 2) - 1) Then
				FileWrite($g_sSaveLocation, $g_aMAKEList[$r][$c] & _StringRepeat(" ", ($iSpaces - $iGetLength)) & "|" & _StringRepeat(" ", $iSpaces) & "|")
			Else
				FileWrite($g_sSaveLocation, $g_aMAKEList[$r][$c] & _StringRepeat(" ", ($iSpaces - $iGetLength)) & "|")
			EndIf
		Next
		FileWrite($g_sSaveLocation, @CRLF)
		GUICtrlSetData($g_idCSVProgress, 1)
	Next
	_GUICtrlRichEdit_AppendText($g_hProgressLog, "	" & UBound($g_aMAKEList) & " vectors were created" & @CRLF)
	FileWrite($g_sSaveLocation, @CRLF & @CRLF) ;Create a blank line

	;Write DROP
	FileWrite($g_sSaveLocation, $aHeaders[2] & @CRLF) ;Write DROP headers
	GUICtrlSetData($g_idCSVProgress, 25)
	_GUICtrlRichEdit_AppendText($g_hProgressLog, "Writing DROP section..." & @CRLF)
	For $r = 0 To UBound($g_aDROPList) - 1
		FileWrite($g_sSaveLocation, "DROP  |")
		For $c = 0 To UBound($g_aDROPList, 2) - 1
			$iGetLength = StringLen($g_aDROPList[$r][$c])
			If $c = (UBound($g_aDROPList, 2) - 1) Then
				FileWrite($g_sSaveLocation, $g_aDROPList[$r][$c] & _StringRepeat(" ", ($iSpaces - $iGetLength)) & "|" & _StringRepeat(" ", $iSpaces) & "|")
			ElseIf $c = 3 Then
				If $g_aDROPList[$r][0] = "WAIT" Or $g_aDROPList[$r][0] = "RECALC" Then
					FileWrite($g_sSaveLocation, _StringRepeat(" ", ($iSpaces - $iGetLength)) & "|")
				Else
					$iGetLength = StringLen($aTroopsDic[_ArraySearch($aTroopsName, $g_aDROPList[$r][$c])]($g_aDROPList[$r][$c]))
					FileWrite($g_sSaveLocation, $aTroopsDic[_ArraySearch($aTroopsName, $g_aDROPList[$r][$c])]($g_aDROPList[$r][$c]) & _StringRepeat(" ", ($iSpaces - $iGetLength)) & "|")
				EndIf
			Else
				FileWrite($g_sSaveLocation, $g_aDROPList[$r][$c] & _StringRepeat(" ", ($iSpaces - $iGetLength)) & "|")
			EndIf
		Next
		FileWrite($g_sSaveLocation, @CRLF)
	Next

	GUICtrlSetData($g_idCSVProgress, 100)
	_GUICtrlRichEdit_AppendText($g_hProgressLog, "Finished" & @CRLF)
	GUICtrlSetData($g_hProgressTxt, "CSV ready to be used!")
EndFunc   ;==>CSVGen
#EndRegion Child GUI Functions

#cs
	For $r = 0 To UBound($g_aMAKEList) - 1
	ConsoleWrite("Row " & $r & ": ")
	For $c = 0 To UBound($g_aMAKEList, 2) - 1
	ConsoleWrite(" " & $g_aMAKEList[$r][$c] & " ")
	Next
	ConsoleWrite(@CRLF)
	Next
#ce
