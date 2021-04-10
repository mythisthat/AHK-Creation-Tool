ShowSearchDialog:
ShowReplaceDialog:
    If (WinExist("ahk_id " . hFindReplaceDlg)) {
        Gui FindReplaceDlg: Show

        GuiControlGet CurrentTab,, %hFindReplaceTab%
        If (CurrentTab != 1 && A_ThisLabel == "ShowSearchDialog") {
            GuiControl Choose, %hFindReplaceTab%, 1
            GoSub FindReplaceTabHandler
        }

        GuiControl Focus, % (CurrentTab == 1) ? hFindCbx : hFindCbx2
    } Else {
        WhatItems := ""
        WithItems := ""
        IniRead FindHistory, %IniFile%, FindHistory
        If (FindHistory != "ERROR") {
            Loop Parse, FindHistory, `n
            {
                Item := StrSplit(A_LoopField, "=")
                If (InStr(Item[1], "What")) {
                    WhatItems .= Item[2] . "`n"
                } Else If (InStr(Item[1], "With")) {
                    WithItems .= Item[2] . "`n"
                }
            }
        }

        IniRead g_MatchCase, %IniFile%, Find, MatchCase, 0
        IniRead g_WholeWord, %IniFile%, Find, WholeWord, 0
        IniRead g_RegExFind, %IniFile%, Find, RegExFind, 0
        IniRead g_Backslash, %IniFile%, Find, Backslash, 0

        Gui FindReplaceDlg: New, LabelFindReplaceDlg hWndhFindReplaceDlg -MinimizeBox OwnerAuto Delimiter`n
        Gui Font, s9, Segoe UI

        Gui Add, Tab3
        , hWndhFindReplaceTab vFindReplaceTab gFindReplaceTabHandler x8 y8 w466 h182 AltSubmit %g_ThemeFix%
        , Find`nReplace

        Gui Tab, 1
            Gui Add, Text, x31 y45 w42 h23 +0x200, What:
            Gui Add, ComboBox, hWndhFindCbx vSearchString x84 y46 w272, %WhatItems%
            GuiControl Choose, %hFindCbx%, 1

            Gui Add, Button, hWndhFindNextBtn1 gFindNext x371 y45 w88 h25 Default, Find &Next
            Gui Add, Button, gFindPrev x371 y79 w88 h25, Find &Previous
            Gui Add, Button, gMarkAll x371 y113 w88 h25, Mark &All
            Gui Add, Button, gFindReplaceDlgClose x371 y148 w88 h25, &Cancel

            Gui Add, CheckBox, vg_MatchCase gSyncSearchOptions x24 y81 w160 h23 Checked%g_MatchCase%
            , &Case sensitive
            Gui Add, CheckBox, vg_WholeWord gSyncSearchOptions x24 y105 w160 h23 Checked%g_WholeWord%
            , &Match whole word only
            Gui Add, CheckBox, vg_RegExFind gSyncSearchOptions x24 y129 w160 h23 Checked%g_RegExFind%
            , &Regular expression
            Gui Add, CheckBox, vg_Backslash gSyncSearchOptions x24 y153 w160 h23 Checked%g_Backslash%
            , &Backslashed characters

        Gui Tab, 2
            Gui Add, Text, x31 y45 w42 h23 +0x200, What:
            Gui Add, ComboBox, hWndhFindCbx2 vReplaceWhat x84 y46 w272, %WhatItems%
            GuiControl Choose, %hFindCbx2%, 1
            Gui Add, Text, x31 y75 w42 h23 +0x200, With:
            Gui Add, ComboBox, hWndhReplaceCbx vReplaceWith x84 y76 w272, %WithItems%
            GuiControl Choose, %hReplaceCbx%, 1

            Gui Add, Button, hWndhFindNextBtn2 gFindNext x371 y45 w88 h25, Find &Next
            Gui Add, Button, gFindPrev x371 y79 w88 h25, Find &Previous
            Gui Add, Button, gReplace x371 y113 w88 h25, &Replace
            Gui Add, Button, gReplaceAll x371 y148 w88 h25, Replace &All
            Gui Add, Button, gFindReplaceDlgClose x371 y182 w88 h25, &Cancel

            Gui Add, CheckBox, vMatchCase gSyncSearchOptions x24 y111 w160 h23, &Case sensitive
            Gui Add, CheckBox, vWholeWord gSyncSearchOptions x24 y135 w160 h23, &Match whole word only
            Gui Add, CheckBox, vRegExFind gSyncSearchOptions x24 y159 w160 h23, &Regular expression
            Gui Add, CheckBox, vBackslash gSyncSearchOptions x24 y183 w160 h23, &Backslashed characters

        IniRead px, %IniFile%, Find, x, Center
        IniRead py, %IniFile%, Find, y, Center

        SetWindowIcon(hFindReplaceDlg, IconLib, 21)
        Gui FindReplaceDlg: Show, x%px% y%py% w481 h198, Find

        NOTFOUND := -1
    }

    NotFoundMsgType := 1

    GoSub SyncSearchOptions

    If (A_ThisLabel == "ShowReplaceDialog") {
        GuiControl Choose, %hFindReplaceTab%, 2
        GoSub FindReplaceTabHandler
    }

    If ((SelText := GetSelectedText()) != "") {
        GuiControl Text, % (A_ThisLabel == "ShowSearchDialog") ? hFindCbx : hFindCbx2, %SelText%
    }

    Send +{End}
Return

FindReplaceDlgEscape:
FindReplaceDlgClose:
    Gui FindReplaceDlg: Hide
Return

FindReplaceTabHandler:
    Gui FindReplaceDlg: Submit, NoHide

    If (FindReplaceTab == 2) {
        GuiControl Move, %hFindReplaceTab%, h214
        WinMove ahk_id %hFindReplaceDlg%,,,,, 257
        WinSetTitle ahk_id %hFindReplaceDlg%,, Replace
        SetWindowIcon(hFindReplaceDlg, IconLib, 22)
        GuiControl Text, %hFindCbx2%, %SearchString%
        WinSet Redraw,, ahk_id %hFindCbx2%
        GuiControl +Default, %hFindNextBtn2%
    } Else If (FindReplaceTab == 1) {
        GuiControl Move, %hFindReplaceTab%, h182
        WinMove ahk_id %hFindReplaceDlg%,,,,, 226
        WinSetTitle ahk_id %hFindReplaceDlg%,, Find
        SetWindowIcon(hFindReplaceDlg, IconLib, 21)
        GuiControl Text, %hFindCbx%, %ReplaceWhat%
        WinSet Redraw,, ahk_id %hFindCbx%
        GuiControl +Default, %hFindNextBtn1%
    }
Return

FindNext:
FindPrev:
Replace:
    Gui FindReplaceDlg: Submit, NoHide
    GuiControlGet SearchString,, % (FindReplaceTab == 1) ? hFindCbx : hFindCbx2, Text

    n := TabEx.GetSel()

    SearchFlags := GetSearchFlags()

    OldSearchString := SearchString
    OldReplaceWith := ReplaceWith
    If (g_Backslash) {
        TransformBackslashes(SearchString)
        TransformBackslashes(ReplaceWith)
    }

    Length := StrPut(SearchString, "UTF-8") - 1 ; Length of the search string in bytes

    If (A_ThisLabel == "FindNext") {
        If (g_RegExFind) {
            SciText := GetText(n)
            TempText := GetTextRange(n, [0, Sci[n].GetCurrentPos()])
            Pos := RegExMatch(SciText, SearchString, Match, StrLen(TempText) + 1)
            If (Pos > 0) {
                Length := StrPut(SubStr(SciText, Pos, StrLen(Match)), "UTF-8") - 1
                FoundPos := StrPut(SubStr(SciText, 1, Pos - 1), "UTF-8") - 1
            } Else {
                FoundPos := NOTFOUND
            }
        } Else {
            ;FoundPos := Sci[n].SearchNext(SearchFlags, SearchString)
            Sci[n].SetSearchFlags(SearchFlags)
            Sci[n].SetTargetStart(Sci[n].GetCurrentPos())
            Sci[n].SetTargetEnd(Sci[n].GetLength())
            FoundPos := Sci[n].SearchInTarget(Length, "" . SearchString, 2)
        }

        If (FoundPos != NOTFOUND) {
            LastVisibleLine := Sci[n].GetFirstVisibleLine() + Sci[n].LinesOnScreen()
            If (Sci[n].LineFromPosition(FoundPos) > LastVisibleLine) {
                Sci[n].GoToPos(FoundPos)
                Sci[n].VerticalCentreCaret()
            }

            Sci[n].SetSel(FoundPos, FoundPos + Length)

            NotFoundMsgType := 2
        }
    } Else If (A_ThisLabel == "FindPrev") {
        If (g_RegExFind) {
            SciText := GetText(n)
            TempText := GetTextRange(n, [0, Sci[n].GetAnchor()])
            LimitPos := StrLen(TempText)
            StartPos := 1
            FoundPos := 0
            Loop  {
                StartPos := RegExMatch(SciText, SearchString, Match, StartPos)
                If ((StartPos > 0) && StartPos <= LimitPos) {
                    FoundPos := StartPos
                    Length := StrLen(Match)
                    StartPos++
                    Continue
                }
                Break
            }

            FoundPos--
            If (FoundPos != NOTFOUND) {
                Length := StrPut(SubStr(SciText, FoundPos + 1, Length), "UTF-8") - 1
                FoundPos := StrPut(SubStr(SciText, 1, FoundPos), "UTF-8") - 1

                If (Sci[n].LineFromPosition(FoundPos) < Sci[n].GetFirstVisibleLine()) {
                    Sci[n].GoToPos(FoundPos)
                    Sci[n].VerticalCentreCaret()
                }

                Sci[n].SetSel(FoundPos, FoundPos + Length)
            }
        } Else {
            Sci[n].SearchAnchor()
            VarSetCapacity(s, StrPut(SearchString, "UTF-8"))
            StrPut(SearchString, &s, "UTF-8")
            FoundPos := Sci[n].SearchPrev(SearchFlags, &s)
            If (FoundPos != NOTFOUND) {
                SelStart := Sci[n].GetSelectionStart()
                SelEnd := Sci[n].GetSelectionEnd()

                If (Sci[n].LineFromPosition(FoundPos) < Sci[n].GetFirstVisibleLine()) {
                    Sci[n].GoToPos(FoundPos)
                    Sci[n].VerticalCentreCaret()
                } Else {
                    Sci[n].GoToPos(FoundPos)
                }

                Sci[n].SetAnchor(SelStart)
                Sci[n].SetCurrentPos(SelEnd)
            }
        }
    } Else { ; Replace
        If (g_RegExFind) {
            SciText := GetText(n)
            TempText := GetTextRange(n, [0, Sci[n].GetAnchor()])
            FoundPos := RegExMatch(SciText, SearchString, Match, StrLen(TempText) + 1)
            If (FoundPos > 0) {
                Length := StrPut(SubStr(SciText, FoundPos, StrLen(Match)), "UTF-8") - 1
                FoundPos := StrPut(SubStr(SciText, 1, FoundPos - 1), "UTF-8") - 1
                ReplaceWith := RegExReplace(Match, SearchString, ReplaceWith)
            } Else {
                FoundPos := NOTFOUND
            }
        } Else {
            Sci[n].SetSearchFlags(SearchFlags)
            Sci[n].SetTargetStart(Sci[n].GetAnchor())
            Sci[n].SetTargetEnd(Sci[n].GetLength())
            FoundPos := Sci[n].SearchInTarget(Length, s := SearchString, 2)
        }

        If (FoundPos != NOTFOUND) {
            If (Sci[n].GetSelText(0, 0) > 1) {
                SelStart := Sci[n].GetSelectionStart()
                SelEnd := Sci[n].GetSelectionEnd()

                If (SelStart == FoundPos && (FoundPos + Length) == SelEnd) {
                    Sci[n].ReplaceSel(SearchFlags, ReplaceWith, 2)
                }
            }

            NotFoundMsgType := 2
        }

        GoSub FindNext
    }

    If (FoundPos == -1 && A_ThisLabel != "Replace") {
        FR_ShowBalloon((NotFoundMsgType == 1)
        ? "Search string not found: """ . SearchString . """"
        : "No further occurrence of """ . SearchString . """")
/*
        MsgBox 0x2040, AutoGUI, % (NotFoundMsgType == 1)
        ? "Search string not found: """ . SearchString . """"
        : "No further occurrence of """ . SearchString . """"
*/
    }

    NotFoundMsgType := (FoundPos != -1) ? 2 : 1

    AddToFindHistory(hFindCbx, OldSearchString)
    AddToFindHistory(hFindCbx2, OldSearchString)
    If (A_ThisLabel == "Replace") {
        AddToFindHistory(hReplaceCbx, OldReplaceWith)
    }

    SciText := TempText := ""
Return

ReplaceAll:
    Gui FindReplaceDlg: Submit, NoHide
    GuiControlGet ReplaceWhat,, %hFindCbx2%, Text
    GuiControlGet ReplaceWith,, %hReplaceCbx%, Text

    Counter := ReplaceAll(ReplaceWhat, ReplaceWith, GetSearchFlags(), g_RegExFind, g_Backslash)
    FR_ShowBalloon(Counter . " occurrence(s) replaced.")
    ;MsgBox 0x2040, %AppName%, % Counter . " occurrence(s) replaced."

    AddToFindHistory(hFindCbx2, ReplaceWhat)
    AddToFindHistory(hReplaceCbx, ReplaceWith)
    AddToFindHistory(hFindCbx, ReplaceWhat)
Return

ReplaceAll(ReplaceWhat, ReplaceWith := "", Flags := 0, RegEx := False, Backslash := False) {
    n := TabEx.GetSel()
    Sci[n].BeginUndoAction()

    Counter := 0

    If (Backslash) {
        TransformBackslashes(ReplaceWhat)
        TransformBackslashes(ReplaceWith)
    }

    If (RegEx) {
        TempText := GetTextRange(n, [0, Sci[n].GetCurrentPos()])
        StartPos := StrLen(TempText) + 1

        Loop {
            SciText := GetText(n)
            FoundPos := RegExMatch(SciText, ReplaceWhat, Match, StartPos)
            If (FoundPos < 1) {
                Break
            }

            StartPos := FoundPos + StrLen(ReplaceWith)
            ByteLength := StrPut(Match := SubStr(SciText, FoundPos, StrLen(Match)), "UTF-8") - 1
            BytePos := StrPut(SubStr(SciText, 1, FoundPos - 1), "UTF-8") - 1
            NewStr := RegExReplace(Match, ReplaceWhat, ReplaceWith)

            VarSetCapacity(String, StrPut(NewStr, "UTF-8") + 1)
            StrPut(NewStr, &String, "UTF-8")

            Sci[n].SetTargetStart(BytePos)
            Sci[n].SetTargetEnd(BytePos + ByteLength)
            Sci[n].ReplaceTarget(StrPut(NewStr, "UTF-8") - 1, &String)

            Counter++
        }

        SciText := TempText := ""
    } Else {
        WhatLength := StrPut(ReplaceWhat, "UTF-8") - 1
        WithLength := StrPut(ReplaceWith, "UTF-8") - 1

        Sci[n].SetSearchFlags(Flags)
        Sci[n].SetTargetStart(Sci[n].GetCurrentPos())
        Sci[n].SetTargetEnd(Sci[n].GetLength() + 1)

        While (Sci[n].SearchInTarget(WhatLength, "" . ReplaceWhat, 2) != -1) {
            Sci[n].ReplaceTarget(WithLength, r := ReplaceWith, 2)
            Sci[n].SetTargetStart(Sci[n].GetTargetStart() + WithLength)
            Sci[n].SetTargetEnd(Sci[n].GetLength() + 1)
            Counter++
        }
    }

    Sci[n].EndUndoAction()

    Return Counter
}

MarkAll:
    Gui FindReplaceDlg: Submit, NoHide
    GuiControlGet SearchString,, %hFindCbx%, Text
    n := TabEx.GetSel()

    OldSearchString := SearchString
    If (g_Backslash) {
        TransformBackslashes(SearchString)
    }

    ; SCI_SETINDICATORCURRENT(int indicator): Set the indicator that will be affected by calls to
    ; SCI_INDICATORFILLRANGE(int start, int lengthFill) and SCI_INDICATORCLEARRANGE(int start, int lengthClear).
    Sci[n].SetIndicatorCurrent(1)

    Sci[n].IndicSetStyle(1, INDIC_ROUNDBOX)
    Sci[n].IndicSetFore(1, CvtClr(0x3FBBE3))
    Sci[n].IndicSetOutlineAlpha(1, 255) ; Opaque border
    Sci[n].IndicSetAlpha(1, 80)

    If (!StringLength := StrPut(SearchString, "UTF-8") - 1) {
        Sci[n].IndicatorClearRange(0, Sci[n].GetLength())
        Return
    }

    Counter := 0

    If (g_RegExFind) {
        Sci[n].GetText(Sci[n].GetLength() + 1, SciText)
        Sci[n].GetText(Sci[n].GetLength() + 1, SciText)
        StartPos := 1
        While ((FoundPos := RegExMatch(SciText, SearchString, Match, StartPos)) > 0) {
            StartPos := FoundPos + 1
            Length := StrPut(SubStr(SciText, FoundPos, StrLen(Match)), "UTF-8") - 1
            FoundPos := StrPut(SubStr(SciText, 1, FoundPos - 1), "UTF-8") - 1
            Sci[n].IndicatorFillRange(FoundPos, Length)
            Counter++
        }
    } Else {
        TextLength := Sci[n].GetLength()

        Sci[n].SetSearchFlags(GetSearchFlags())
        Sci[n].SetTargetStart(0)
        Sci[n].SetTargetEnd(TextLength)

        While (Sci[n].SearchInTarget(StringLength, "" . SearchString, 1) != -1) {
            TargetStart := Sci[n].GetTargetStart()
            TargetEnd := Sci[n].GetTargetEnd()

            Sci[n].IndicatorFillRange(TargetStart, TargetEnd - TargetStart)
            Counter++

            Sci[n].SetTargetStart(TargetEnd)
            Sci[n].SetTargetEnd(TextLength)
        }
    }

    If (Counter) {
        GoToNextMark()
    }

    FR_ShowBalloon((Counter ? Counter : "No") . " " . ((Counter > 1) ? "matches" : "match") . " found.")
    ;MsgBox 0, %AppName%, % (Counter ? Counter : "No") . " " . ((Counter > 1) ? "matches" : "match") . " found."

    AddToFindHistory(hFindCbx, OldSearchString)
Return

AddToFindHistory(hCbx, String) {
    ControlGet ComboItems, List,,, ahk_id %hCbx%
    History := String . "`n`n"

    Counter := 0
    Loop Parse, ComboItems, `n
    {
        If (A_LoopField == String || A_LoopField == "") {
            Continue
        }

        History .= A_LoopField . "`n"

        Counter++
        If (Counter > 8) {
            Break
        }
    }

    Loop 10 {
        Control Delete, 1,, ahk_id %hCbx%
    }

    GuiControl,, %hCbx%, %History%
}

GetSearchFlags() {
    Local SearchFlags := 0

    If (g_MatchCase) {
        SearchFlags := 4
    }

    If (g_WholeWord) {
        SearchFlags += 2
    }

    Return SearchFlags
}

; Convert some escape sequences
TransformBackslashes(ByRef String) {
    n := TabEx.GetSel()
    IsCRLF := Sci[n].GetCharAt(Sci[n].GetLineEndPosition(0)) == 0xD

    StringReplace String, String, \\, ☺, All
    StringReplace String, String, \n, % IsCRLF ? "`r`n" : "`n", All
    ;StringReplace String, String, \r, `r, All
    StringReplace String, String, \t, %A_Tab%, All
    StringReplace String, String, ☺, \, All
}

SyncSearchOptions:
    Gui FindReplaceDlg: Submit, NoHide

    ; Set exclusive options
    If (A_GuiControl != "") {
        VarPrefix := (FindReplaceTab == 1) ? "g_" : ""

        If (InStr(A_GuiControl, "Re")) {
            GuiControl,, % VarPrefix . "MatchCase", 0
            GuiControl,, % VarPrefix . "WholeWord", 0
            GuiControl,, % VarPrefix . "Backslash", 0
        } Else {
            GuiControl,, % VarPrefix . "RegExFind", 0
        }
    }

    Gui FindReplaceDlg: Submit, NoHide

    ; Synchronize options
    If (FindReplaceTab == 1) {
        GuiControl,, MatchCase, %g_MatchCase%
        GuiControl,, WholeWord, %g_WholeWord%
        GuiControl,, RegExFind, %g_RegExFind%
        GuiControl,, Backslash, %g_Backslash%
    } Else {
        GuiControl,, g_MatchCase, %MatchCase%
        GuiControl,, g_WholeWord, %WholeWord%
        GuiControl,, g_RegExFind, %RegExFind%
        GuiControl,, g_Backslash, %Backslash%
    }


Return

VerticalCentreCaret(n, FoundPos) {
    LastVisibleLine := Sci[n].GetFirstVisibleLine() + Sci[n].LinesOnScreen()
    If (Sci[n].LineFromPosition(FoundPos) > LastVisibleLine) {
        Sci[n].GoToPos(FoundPos)
        Sci[n].VerticalCentreCaret()
    }
}

FR_ShowBalloon(Text, Title := "", Icon := 0) {
    Global ; ?
    Gui FindReplaceDlg: Submit, NoHide
    If (IsWindowVisible(hFindReplaceDlg)) {
        hEdit := DllCall("GetWindow", "Ptr", FindReplaceTab == 1 ? hFindCbx : hFindCbx2, "UInt", 5, "Ptr") ; GW_CHILD
        Edit_ShowBalloonTip(hEdit, Text, Title, Icon)
    } Else {
        Gui Auto: +OwnDialogs
        MsgBox 0, % Title != "" ? Title : AppName, %Text%
    }
}

FindInFiles() {
    Run %A_ScriptDir%\Tools\Find in Files.ahk /AutoGUI
}
