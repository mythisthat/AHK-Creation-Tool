GenerateCode() {
    Local Item

    If (!WinExist("ahk_id" . hChildWnd)) {
        GoSub NewGUI
    }

    Header := ""
    Code := ""

    If (g_Script.NoEnv) {
        Header .= "#NoEnv" . CRLF
    }
    If (g_Script.Warn != "") {
        Header .= (g_Script.Warn == "MsgBox") ? "#Warn" . CRLF : "#Warn,, " . g_Script.Warn . CRLF
    }
    If (g_Script.SingleInstance != "") {
        Header .= "#SingleInstance " . g_Script.SingleInstance . CRLF
    }
    If (g_Script.NoTrayIcon) {
        Header .= "#NoTrayIcon" . CRLF
    }
    If (g_Script.Persistent) {
        Header .= "#Persistent" . CRLF
    }
    If (g_Script.WorkingDir != "") {
        Header .= "SetWorkingDir " . g_Script.WorkingDir . CRLF
    }
    If (g_Script.SendMode != "") {
        Header .= "SendMode " . g_Script.SendMode . CRLF
    }
    If (g_Script.NoSleep) {
        Header .= "SetBatchLines -1" . CRLF
    }
    If (g_Script.ListLinesOff) {
        Header .= "ListLines Off" . CRLF
    }
    If (g_Script.IgnoreMenuErrors) {
        Header .= "Menu Tray, UseErrorLevel" . CRLF
    }

    Includes := ""
    If (g.Anchor) {
        Includes .= "#Include %A_ScriptDir%\AutoXYWH.ahk" . CRLF
    }
    If (TB := ToolbarExist()) {
        Includes .= "#Include %A_ScriptDir%\Toolbar.ahk" . CRLF
    }
    If (Includes != "") {
        Header .= CRLF . Includes
    }

    If (Header != "") {
        Header .= CRLF
    }

    If (g.Window.Icon != "") {
        Code .= "Menu Tray, Icon, " . g.Window.Icon . ((g.Window.IconIndex > 1) ? ", " . g.Window.IconIndex : "") . CRLF . CRLF
    }

    GuiOptions := "", ows := False, owxs := False
    GuiOptions .= (g.Window.Label != "") ? " +Label" . g.Window.Label : ""
    GuiOptions .= (g.Window.hWndVar != "") ? " +hWnd" . g.Window.hWndVar : ""
    GuiOptions .= (g.Window.Options != "") ? " " . g.Window.Options : ""
    GuiOptions .= (g.Window.Extra != "") ? " " . g.Window.Extra : ""

    If (SubStr(g.Window.Style, 1, 1) == "0") {
        ows := True
    } Else {
        GuiOptions .= (g.Window.Style != "") ? " " . g.Window.Style : ""
    }
    If (SubStr(g.Window.ExStyle, 1, 1) == "E") {
        owxs := True
    } Else {
        GuiOptions .= (g.Window.ExStyle != "") ? " " . g.Window.ExStyle : ""
    }

    GuiName := (g.Window.Name != "") ? " " . g.Window.Name . ": New," : ""

    If (GuiOptions != "") {
        Code .= "Gui" . GuiName . GuiOptions . CRLF
    }

    Spc := Space(g.Window.FontOptions)
    Sep := (g.Window.FontName != "") ? ", " : ""
    If (g.Window.FontOptions != "" || g.Window.FontName != "") {
        GuiFont := "Gui Font," . Spc . g.Window.FontOptions . Sep . g.Window.FontName . CRLF
        Code .= GuiFont
    } Else {
        GuiFont := ""
    }

    If (g.Window.Color != "") {
        Code .= "Gui Color, " . g.Window.Color . CRLF
    }

    ; Menu
    If (m.Code != "") {
        Code .= m.Code . CRLF
    }

    OrderTabItems()
    fTab := False

    For Each, Item in g.ControlList {
        If (g[Item].Deleted == False) {
            If (g[Item].Text == "" && g[Item].Type != "DateTime") {
                ControlGetText Text,, ahk_id %Item%
            } Else {
                Text := g[Item].Text
            }

            Gui %Child%: Default

            GuiControlGet c, %Child%: Pos, %Item%

            If (g[Item].Tab[1] != "") {
                fTab := True
                If (g[Item].Tab[1] != PreviousTab[1] || g[Item].Tab[2] != PreviousTab[2]) {
                    If (g[Item].Tab[2] == 1) {
                        Code .= "Gui Tab, " . g[Item].Tab[1] . CRLF
                    } Else {
                        Code .= "Gui Tab, " . g[Item].Tab[1] . ", " . g[Item].Tab[2] . CRLF
                    }
                }
            }

            PreviousTab := g[Item].Tab

            fFont := False
            Spc := Space(g[Item].FontOptions)
            Sep := (g[Item].FontName != "") ? ", " : ""
            If (g[Item].FontOptions != "" || g[Item].FontName != "") {
                fFont := True
                If (GuiFont != "") {
                    Code .= "Gui Font" . CRLF
                }
                Code .= "Gui Font," . Spc . g[Item].FontOptions . Sep . g[Item].FontName . CRLF
            }

            ControlType := (g[Item].Type == "Tab2") ? "Tab3" : g[Item].Type
            Code .= "Gui Add, " . ControlType . ", "

            If (g[Item].hWndVar != "") {
                Code .= "hWnd" . g[Item].hWndVar . " "
            }

            If (g[Item].vVar != "") {
                Code .= "v" . g[Item].vVar . " "
            }

            If (g[Item].gLabel != "") {
                Code .= "g" . g[Item].gLabel . " "
            }

            If (ControlType == "ComboBox" || ControlType == "DropDownList") {
                Code .= "x" . cX . " y" . cY . " w" . cW
            } Else If (ControlType == "StatusBar") {
                Code := RTrim(Code, " ")
            } Else {
                Code .= "x" . cX . " y" . cY . " w" . cW . " h" . cH
            }

            If (g[Item].Style != "") {
                Code .= " " . g[Item].Style
            }

            If (g[Item].ExStyle != "") {
                Code .= " " . g[Item].ExStyle
            }

            If (g[Item].Options) {
                Code .= " " . Trim(g[Item].Options)
            }

            If (Text != "") {
                Code .= ", " . Text
            }

            Code .= CRLF

            If (fFont) {
                Code .= "Gui Font" . CRLF
                If (GuiFont != "" && A_Index != g.ControlList.MaxIndex()) {
                    Code .= GuiFont
                }
            }

            If (g[Item].Extra == "Explorer") {
                Code .= "DllCall(""UxTheme.dll\SetWindowTheme"", ""Ptr"", "
                     . g[Item].hWndVar . ", ""WStr"", ""Explorer"", ""Ptr"", 0)" . CRLF
            }

            If (g[Item].HintText != "") {
                If (g[Item].Type == "Edit") {
                    Code .= "DllCall(""SendMessage"", ""Ptr"", " . g[Item].hWndVar . ", ""UInt"", 0x1501, ""Ptr"", 1, ""WStr"", """ . g[Item].HintText . """) `; Hint text" . CRLF
                } Else { ; ComboBox
                    Code .= "hCbxEdit := DllCall(""GetWindow"", ""Ptr"", " . g[Item].hWndVar . ", ""UInt"", 5, ""Ptr"") `; GW_CHILD" . CRLF
                    Code .= "DllCall(""SendMessage"", ""Ptr"", hCbxEdit, ""UInt"", 0x1501, ""Ptr"", 1, ""WStr"", """ . g[Item].HintText . """) `; Hint Text" . CRLF
                }
            }
        }
    }

    If (fTab && TB) {
        Code .= "Gui Tab" . CRLF
    }

    If (g.ControlList.Length() && !(g.ControlList.Length() == 1 && g[g.ControlList[1]].Deleted)) {
        Code .= CRLF
    }

    WI := GetWindowInfo(hChildWnd)
    Position := (g.Window.Center) ? "" : "x" . WI.ClientX . " y" . WI.ClientY . " "
    Code .= "Gui Show, " . Position . "w" . WI.ClientW . " h" . WI.ClientH

    If (g.Window.Title != "") {
        Code .= ", " . g.Window.Title
    }
    Code .= CRLF

    If (ows) {
        Code .= "WinSet Style, " . g.Window.Style . ", " . g.Window.Title . CRLF
        Code .= "WinSet Redraw,, " . g.Window.Title . CRLF
    }
    If (owxs) {
        Code .= "WinSet ExStyle, " . SubStr(g.Window.ExStyle, 2) . ", " . g.Window.Title . CRLF
        Code .= "WinSet Redraw,, " . g.Window.Title . CRLF
    }

    If (TB) {
        Code .= CRLF . "hToolbar := CreateToolBar()" . CRLF
    }

    If (NoReturn == False) {
        Code .= "Return" . CRLF
    }

    If (m.Code != "" && !NoReturn) {
        Code .= CRLF . "MenuHandler:`nReturn" . CRLF
    }

    If (g.Window.Label == "") {
        Label := (g.Window.Name != "") ? g.Window.Name . "Gui" : "Gui"
    } Else {
        Label := g.Window.Label
    }

    Minimized := CRLF . "    If (A_EventInfo == 1) {" . CRLF . "        Return" . CRLF . "    }" . CRLF

    If (g.Window.GuiSize) {
        Code .= CRLF . Label . "Size:" . Minimized

        If (g.Anchor) {
            For Each, hCtrl In g.ControlList {
                If (g[hCtrl].Anchor != "" && !g[hCtrl].Deleted) {
                    Code .= CRLF . Indent . "AutoXYWH(""" . g[hCtrl].Anchor . """, " . g[hCtrl].hWndVar . ")"
                }
            }
        }

        If (TB && !InStr(Toolbar.Options, "Vertical")) {
            Code .= CRLF . Indent . "GuiControl Move, %hToolBar%, w%A_GuiWidth%"
        }

        Code .= CRLF . "Return" . CRLF
    }

    If (g.Window.GuiContextMenu) {
        Code .= CRLF . Label . "ContextMenu:" . CRLF
            If (m.Context != "") {
                Code .= "`tMenu " . m[ContextMenuId].Command . ", Show" . CRLF
            }
        Code .= "Return" . CRLF
    }

    If (g.Window.GuiDropFiles) {
        Code .= CRLF . Label . "DropFiles:" . CRLF . "Return" . CRLF
    }

    If (g.Window.OnClipboardChange) {
        Code .= CRLF . "OnClipboardChange:" . CRLF . "Return" . CRLF
    }

    If (g.Window.GuiEscape) {
        Code .= CRLF . Label . "Escape:"
    }

    If (g.Window.GuiClose) {
        Code .= CRLF . Label . "Close:" . CRLF . Indent . "ExitApp" . CRLF
    }

    If (g.Window.GuiEscape && !g.Window.GuiClose) {
        Code .= CRLF . "Return" . CRLF
    }

    If (TB) {
        Code .= CRLF . "CreateToolbar() {" . CRLF

        If (!InStr(Toolbar.Options, "TextOnly")) {
            TBIL := " ImageList"

            Code .= Indent . "ImageList := IL_Create(" . Toolbar.Buttons.Length() . ")" . CRLF

            For Each, Item in Toolbar.Buttons {
                If (Item.Text == "") {
                    Continue
                }
                Code .= Indent . "IL_Add(ImageList, """ . Item.Icon . """, " . Item.IconIndex . ")" . CRLF
            }

            Code .= CRLF
        } Else {
            TBIL := ""
        }

        ToolbarButtons := ""
        For Each, Item in Toolbar.Buttons {
            ButtonText := (Item.Text == "") ? "-" : Item.Text

            If (Item.State != "" && Item.Style != "") {
                ButtonOptions := ",," . Item.State . "," . Item.Style
            } Else If (Item.Style != "") {
                ButtonOptions := ",,," . Item.Style
            } Else If (Item.State != "") {
                ButtonOptions := ",," . Item.State
            } Else {
                ButtonOptions := ""
            }

            ToolbarButtons .= Indent . Indent . ButtonText . ButtonOptions . CRLF
        }

        Code .= Indent . "Buttons = " . CRLF . Indent . "(LTrim" . CRLF . ToolbarButtons . Indent . ")" . CRLF . CRLF

        Code .= Indent . "Return ToolbarCreate(""OnToolbar"", Buttons," . TBIL . ", """ . Toolbar.Options . """)" . CRLF

        Code .= "}" . CRLF . CRLF . "OnToolbar(hWnd, Event, Text, Pos, Id) {" . CRLF
        Code .= Indent . "If (Event != ""Click"") {" . CRLF . Indent . Indent . "Return" . CRLF . Indent . "}" . CRLF . CRLF

        For Each, Item in Toolbar.Buttons {
            If (Item.Text == "") {
                Continue
            }

            If (A_Index == 1) {
                Code .= Indent . "If (Text == """ . Item.Text . """) {" . CRLF . CRLF
            } Else {
                Code .= Indent . "} Else If (Text == """ . Item.Text . """) {" . CRLF . CRLF
            }
        }

        Code .= Indent . "}" . CRLF . "}"
    }

    Code .= CRLF . g_Delimiter

    Sci[g_GuiTab].GetText(Sci[g_GuiTab].GetLength() + 1, SciText)
    If (StartingPos := InStr(SciText, g_Delimiter)) {
        Code .= SubStr(SciText, StartingPos + StrLen(g_Delimiter))
    }

    Sci[g_GuiTab].BeginUndoAction()
    Sci[g_GuiTab].ClearAll()
    Sci[g_GuiTab].SetText("", g_Signature . Header . Code, 2)
    Sci[g_GuiTab].EndUndoAction()

    If (TabEx.GetSel() != g_GuiTab) {
        TabEx.SetSel(g_GuiTab)
    }

    Header := ""
    Code := ""
    SciText := ""
}

SetIndent() {
    Indent := g_IndentWithSpaces ? Format("{1: " . g_TabSize . "}", "") : "`t"
}
