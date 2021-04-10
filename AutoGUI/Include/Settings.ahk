LoadSettings() {
    IniRead OpenDir, %IniFile%, Options, OpenDir, %A_MyDocuments%
    IniRead SaveDir, %IniFile%, Options, SaveDir, %A_MyDocuments%
    IniRead CodePage, %IniFile%, Options, CodePage, UTF-8
    FileEncoding % (CodePage = "ANSI") ? "CP1252" : CodePage

    IniRead DesignMode, %IniFile%, Options, DesignMode, 0
    IniRead ShowGrid, %IniFile%, Options, ShowGrid, 1
    IniRead SnapToGrid, %IniFile%, Options, SnapToGrid, 0
    IniRead GridSize, %IniFile%, Options, GridSize, 8
    IniRead NoResizers, %IniFile%, Options, NoResizers, 0

    IniRead g_TabBarPos, %IniFile%, Options, TabBarPos, 1
    IniRead g_TabBarStyle, %IniFile%, Options, TabBarStyle, 1

    IniRead g_AskToSaveOnExit, %IniFile%, Options, AskToSaveOnExit, 1

    IniRead g_AltAhkPath, %IniFile%, Options, AltRun, Undefined

    IniRead SysTrayIcon, %IniFile%, Options, TrayIcon, 0
    If (SysTrayIcon) {
        Menu Tray, Tip, % AppName . " v" . Version
    } Else {
        Menu Tray, NoIcon
    }

    IniRead g_SciFontName, %IniFile%, Editor, FontName, Lucida Console
    IniRead g_SciFontSize, %IniFile%, Editor, FontSize, 10
    IniRead g_DarkTheme, %IniFile%, Editor, DarkTheme, 0
    IniRead g_TabSize, %IniFile%, Editor, TabSize, 4
    IniRead g_LineNumbers, %IniFile%, Editor, LineNumbers, 1
    IniRead g_SymbolMargin, %IniFile%, Editor, SymbolMargin, 1
    IniRead g_CodeFolding, %IniFile%, Editor, CodeFolding, 0
    IniRead g_WordWrap, %IniFile%, Editor, WordWrap, 1
    IniRead g_SyntaxHighlighting, %IniFile%, Editor, SyntaxHighlighting, 1
    IniRead g_AutoBrackets, %IniFile%, Editor, AutoBrackets, 1
    IniRead g_HighlightActiveLine, %IniFile%, Editor, HighlightActiveLine, 1
    IniRead g_HighlightIdenticalText, %IniFile%, Editor, HighlightIdenticalText, 1
    IniRead g_IndentWithSpaces, %IniFile%, Editor, IndentWithSpaces, 1
    IniRead g_AutoIndent, %IniFile%, Editor, AutoIndent, 1
    IniRead g_IndentGuides, %IniFile%, Editor, IndentGuides, 0
    IniRead g_CheckTimestamp, %IniFile%, Editor, CheckTimestamp, 1

    IniRead g_DbgPort, %IniFile%, Debug, Port, 9001

    IniRead g_AutoCEnabled, %IniFile%, Autocomplete, Enabled, 0
    IniRead g_AutoCMinLength, %IniFile%, Autocomplete, MinLength, 3
    IniRead g_AutoCMaxItems, %IniFile%, Autocomplete, MaxItems, 7

    IniRead g_Calltips, %IniFile%, Calltips, Enabled, 1

    IniRead g_BackupOnSave, %IniFile%, Backup, Enabled, 1
    IniRead g_BackupDir, %IniFile%, Backup, Dir, %A_Temp%\AutoGUI
    IniRead g_BackupDays, %IniFile%, Backup, Days, 30

    IniRead g_AutoSaveInterval, %IniFile%, AutoSave, SaveInterval, 2
    IniRead g_AutoSaveInLoco, %IniFile%, AutoSave, SaveInLoco, 0
    IniRead g_AutoSaveInBkpDir, %IniFile%, AutoSave, SaveInBkpDir, 0

    IniRead g_SessionsDir, %IniFile%, Sessions, Dir
    IniRead g_LoadLastSession, %IniFile%, Sessions, AutoLoadLast, 0
    IniRead g_RememberSession, %IniFile%, Sessions, SaveOnExit, 0

    IniRead g_HelpFile, %IniFile%, Options, HelpFile, %A_ScriptDir%\Help\AutoHotkey.chm

    SetIndent()
}

ApplyToolbarSettings() {
    If (g_CodeFolding) {
        SendMessage TB_CHECKBUTTON, 2150, 1,, ahk_id %hMainToolbar%
    }

    If (g_WordWrap) {
        SendMessage TB_CHECKBUTTON, 2160, 1,, ahk_id %hMainToolbar%
    }

    If (g_SyntaxHighlighting) {
        SendMessage TB_CHECKBUTTON, 2180, 1,, ahk_id %hMainToolbar%
    }

    If (DesignMode) {
        SendMessage TB_CHECKBUTTON, 1060, %DesignMode%,, ahk_id %hGUIToolbar%
    }

    If (ShowGrid) {
        SendMessage TB_CHECKBUTTON, 1080, 1,, ahk_id %hGUIToolbar%
    }

    If (SnapToGrid) {
        SendMessage TB_CHECKBUTTON, 1090, 1,, ahk_id %hGUIToolbar%
    }

}

ApplyMenuSettings() {
    If (g_CodeFolding) {
        Menu AutoViewMenu, Check, &Fold Margin
    }

    If (g_WordWrap) {
        Menu AutoViewMenu, Check, &Wrap Long Lines
    }

    If (g_DarkTheme) {
        Menu AutoViewMenu, Check, Enable Dark Theme
    }

    If (g_SyntaxHighlighting) {
        Menu AutoViewMenu, Check, Syntax &Highlighting
    }

    If (ShowGrid) {
        Menu AutoOptionsMenu, Check, Show &Grid
    }

    If (SnapToGrid) {
        Menu AutoOptionsMenu, Check, S&nap to Grid
    }

    If (g_LineNumbers) {
        Menu AutoViewMenu, Check, &Line Numbers
    }

    If (g_SymbolMargin) {
        Menu AutoViewMenu, Check, Symbol Margin
    }

    If (g_AutoCEnabled) {
        Menu AutoOptionsMenu, Check, &Code Completion
    }

    If (g_Calltips) {
        Menu AutoOptionsMenu, Check, Code &ToolTips
    }

    If (g_AutoBrackets) {
        Menu AutoOptionsMenu, Check, Autoclose &Brackets
    }

    If (g_HighlightActiveLine) {
        Menu AutoViewMenu, Check, Highlight &Active Line
    }

    If (g_HighlightIdenticalText) {
        Menu AutoViewMenu, Check, Highlight Identical Te&xt
    }

    If (DesignMode) {
        Menu AutoViewMenu, Check, &Design Mode
    } Else {
        Menu AutoViewMenu, Check, &Editor Mode
    }

    Menu AutoViewTabBarMenu, Check, % (g_TabBarPos == 1 ? "Top" : "Bottom")
    Menu AutoViewTabBarMenu, Check, % (g_TabBarStyle == 1 ? "Standard" : "Buttons")

    If (g_RememberSession) {
        Menu AutoOptionsMenu, Check, Remember Session
    }

    If (g_AskToSaveOnExit) {
        Menu AutoOptionsMenu, Check, Ask to Save on Exit
    }
}

SaveSettings() {
    If (!FileExist(IniFile)) {
        Sections := "[Options]`n`n[Auto]`n`n[Properties]`n`n[Editor]`n`n[Debug]`n`n[Autocomplete]`n`n[Calltips]`n`n[Find]`n`n[FindHistory]`n`n[Sessions]`n`n[Backup]`n`n[AutoSave]`n`n[Recent]`n"
        FileAppend %Sections%, %IniFile%, UTF-16
        If (ErrorLevel) {
            FileCreateDir %A_AppData%\AutoGUI
            IniFile := A_AppData . "\AutoGUI\AutoGUI.ini"
            FileDelete %IniFile%
            FileAppend %Sections%, %IniFile%, UTF-16
        }
    }

    IniWrite %OpenDir%, %IniFile%, Options, OpenDir
    IniWrite %SaveDir%, %IniFile%, Options, SaveDir
    ;IniWrite %CodePage%, %IniFile%, Options, CodePage
    ;IniWrite %SysTrayIcon%, %IniFile%, Options, TrayIcon

    ; GUI designer options
    IniWrite %DesignMode%, %IniFile%, Options, DesignMode
    IniWrite %ShowGrid%, %IniFile%, Options, ShowGrid
    IniWrite %SnapToGrid%, %IniFile%, Options, SnapToGrid
    IniWrite %GridSize%, %IniFile%, Options, GridSize
    ;IniWrite %NoResizers%, %IniFile%, Options, NoResizers

    ; Tab Bar
    IniWrite %g_TabBarPos%, %IniFile%, Options, TabBarPos
    IniWrite %g_TabBarStyle%, %IniFile%, Options, TabBarStyle

    IniWrite %g_AskToSaveOnExit%, %IniFile%, Options, AskToSaveOnExit
    IniWrite %g_AltAhkPath%, %IniFile%, Options, AltRun
    IniWrite %g_HelpFile%, %IniFile%, Options, HelpFile

    ; Main window position and size
    Pos := GetWindowPlacement(hAutoWnd)
    IniWrite % Pos.x, %IniFile%, Auto, x
    IniWrite % Pos.y, %IniFile%, Auto, y
    IniWrite % Pos.w, %IniFile%, Auto, w
    IniWrite % Pos.h, %IniFile%, Auto, h
    IniWrite % Pos.showCmd, %IniFile%, Auto, Show

    ; Properties dialog position
    If (WinExist("ahk_id " . hPropWnd)) {
        WinGetPos px, py,,, ahk_id %hPropWnd%
        IniWrite %px%, %IniFile%, Properties, x
        IniWrite %py%, %IniFile%, Properties, y
    }

    ; Editor options
    IniWrite %g_SciFontName%, %IniFile%, Editor, FontName
    IniWrite %g_SciFontSize%, %IniFile%, Editor, FontSize
    IniWrite %g_DarkTheme%, %IniFile%, Editor, DarkTheme
    IniWrite %g_TabSize%, %IniFile%, Editor, TabSize
    IniWrite %g_LineNumbers%, %IniFile%, Editor, LineNumbers
    IniWrite %g_CodeFolding%, %IniFile%, Editor, CodeFolding
    IniWrite %g_SymbolMargin%, %IniFile%, Editor, SymbolMargin
    IniWrite %g_WordWrap%, %IniFile%, Editor, WordWrap
    IniWrite %g_SyntaxHighlighting%, %IniFile%, Editor, SyntaxHighlighting
    IniWrite %g_AutoBrackets%, %IniFile%, Editor, AutoBrackets
    IniWrite %g_HighlightActiveLine%, %IniFile%, Editor, HighlightActiveLine
    IniWrite %g_HighlightIdenticalText%, %IniFile%, Editor, HighlightIdenticalText
    IniWrite %g_IndentWithSpaces%, %IniFile%, Editor, IndentWithSpaces
    IniWrite %g_AutoIndent%, %IniFile%, Editor, AutoIndent
    IniWrite %g_IndentGuides%, %IniFile%, Editor, IndentGuides
    IniWrite %g_CheckTimestamp%, %IniFile%, Editor, CheckTimestamp

    ; Debug
    IniWrite %g_DbgPort%, %IniFile%, Debug, Port

    ; Autocomplete
    IniWrite %g_AutoCEnabled%, %IniFile%, Autocomplete, Enabled
    IniWrite %g_AutoCMinLength%, %IniFile%, Autocomplete, MinLength
    IniWrite %g_AutoCMaxItems%, %IniFile%, Autocomplete, MaxItems

    ; Calltips
    IniWrite %g_Calltips%, %IniFile%, Calltips, Enabled

    ; Backup
    IniWrite %g_BackupOnSave%, %IniFile%, Backup, Enabled
    IniWrite %g_BackupDir%, %IniFile%, Backup, Dir
    IniWrite %g_BackupDays%, %IniFile%, Backup, Days

    ; Auto-save
    IniWrite %g_AutoSaveInterval%, %IniFile%, AutoSave, SaveInterval
    IniWrite %g_AutoSaveInLoco%, %IniFile%, AutoSave, SaveInLoco
    IniWrite %g_AutoSaveInBkpDir%, %IniFile%, AutoSave, SaveInBkpDir

    ; Sessions
    IniWrite %g_SessionsDir%, %IniFile%, Sessions, Dir
    IniWrite %g_LoadLastSession%, %IniFile%, Sessions, AutoLoadLast
    IniWrite %g_RememberSession%, %IniFile%, Sessions, SaveOnExit

    ; Recent files
    If (RecentFiles.MaxIndex() > 0) {
        For Index, Filename In RecentFiles {
            IniWrite %Filename%, %IniFile%, Recent, %Index%
        }
    }

    ; Find/Replace
    If (WinExist("ahk_id " . hFindReplaceDlg)) {
        WinGetPos px, py,,, ahk_id %hFindReplaceDlg%
        IniWrite %px%, %IniFile%, Find, x
        IniWrite %py%, %IniFile%, Find, y
        Gui FindReplaceDlg: Submit, NoHide
        IniWrite %g_MatchCase%, %IniFile%, Find, MatchCase
        IniWrite %g_WholeWord%, %IniFile%, Find, WholeWord
        IniWrite %g_RegExFind%, %IniFile%, Find, RegExFind
        IniWrite %g_Backslash%, %IniFile%, Find, Backslash

        ; Find/Replace history
        Items := ""

        ControlGet FindItems, List,,, ahk_id %hFindCbx%
        If (FindItems != "") {
            Loop Parse, FindItems, `n
            {
                Items .= "What" . A_Index . "=" . A_LoopField . "`n"
            }
        }

        ControlGet ReplaceItems, List,,, ahk_id %hReplaceCbx%
        If (replaceItems != "") {
            Loop Parse, ReplaceItems, `n
            {
                Items .= "With" . A_Index . "=" . A_LoopField . "`n"
            }
        }

        If (Items != "") {
            IniWrite %Items%, %IniFile%, FindHistory
        }
    }
}
