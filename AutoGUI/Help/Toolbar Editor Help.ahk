HTML =
(
<html>

<style>
BODY {
    margin-top: 6px;
    font-family: Segoe UI, MS Shell Dlg;
}

H3 {
    margin: 0px;
}

DL {
    margin: 5px;
    padding-bottom: 20px;
}

DT {
    color: #003399;
}

DD {
    font-size: 10pt;
    padding-bottom: 8px;
}
</style>

<body>
    <h3>Toolbar Options</h1>
    <hr>
    <dl>
        <dt>Adjustable</dt>
        <dd>Allows users to change a toolbar button's position by dragging it while holding down the SHIFT key and to open customization dialog by double clicking Toolbar empty area, or separator.</dd>

		<dt>Border</dt>
		<dd>Creates a Toolbar that has a thin-line border.</dd>

        <dt>Bottom</dt>
        <dd>Causes the control to position itself at the bottom of the parent window's client area.</dd>

        <dt>Flat</dt>
        <dd>Creates a flat toolbar. In a flat toolbar, both the toolbar and the buttons are transparent and hot-tracking is enabled. Button text appears under button icons.</dd>

        <dt>List</dt>
        <dd>Creates a flat toolbar with button text to the right of the icon. Otherwise, this style is identical to FLAT style, where text appears under the icon.</dd>

		<dt>Tooltips</dt>
		<dd>Creates a ToolTip control that an application can use to display descriptive text for the buttons in the toolbar.</dd>

		<dt>No Divider</dt>
		<dd>Prevents a two-pixel highlight from being drawn at the top of the control.</dd>

		<dt>Tabstop</dt>
		<dd>Specifies that a control can receive the keyboard focus when the user presses the TAB key.</dd>

		<dt>Wrappable (WRAPABLE)</dt>
		<dd>Creates a toolbar that can have multiple lines of buttons. Toolbar buttons can "wrap" to the next line when the toolbar becomes too narrow to include all buttons on the same line.</dd>

		<dt>Vertical</dt>
		<dd>Creates a vertical toolbar.</dd>

		<dt>Text Only (MENU)</dt>
		<dd>Creates a toolbar that resembles a window menu.</dd>
    </dl>

    <h3>Toolbar Button Styles</h3>
    <hr>
    <dl>
        <dt>AUTOSIZE</dt>
        <dd>Specifies that the toolbar control should not assign the standard width to the button. Instead, the button's width will be calculated based on the width of the text plus the image of the button.</dd>
        
        <dt>Stay Pressed (CHECK)</dt>
        <dd>Creates a dual-state push button that toggles between the pressed and non-pressed states each time the user clicks it.</dd>

        <dt>Grouped (CHECKGROUP)</dt>
        <dd>Creates a button that stays pressed until another button in the group is pressed, similar to radio buttons.</dd>

        <dt>Drop-Down (DROPDOWN)</dt>
        <dd>Creates a drop-down style button that can display a list when the button is clicked.</dd>

        <dt>No Prefix (NOPREFIX)</dt>
        <dd>Specifies that the button text will not have an accelerator prefix associated with it.</dd>

        <dt>Show Text (SHOWTEXT)</dt>
        <dd>Specifies that button text should be displayed. All buttons can have text, but only those buttons with the SHOWTEXT button style will display it. This button style must be used with the LIST style. If you set text for buttons that do not have the SHOWTEXT style, the toolbar control will automatically display it as a ToolTip when the cursor hovers over the button. For this to work you must create the toolbar with TOOLTIPS style. You can create multiline tooltips by using ``r in the tooltip caption. Each ``r will be replaced with new line.</dd>
    </dl>

    <h3>Toolbar Button States</h3>
    <hr>
    <dl>
        <dt>Start Pressed (CHECKED)</dt>
<dd>The button has the CHECK style and is being clicked/pressed.</dd>
        <dt>Disabled</dt>
<dd>The button does not accept user input. The button icon and/or text is grayed out.</dd>
        <dt>Hidden</dt>
<dd>The button is not visible and cannot receive user input.</dd>
        <dt>Break Row (WRAP)</dt>
<dd>The button is followed by a line break. Toolbar must not have WRAPPABLE style.</dd>
    </dl>

</body>
<html>
)

#NoEnv
#Warn
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

#Include %A_ScriptDir%\..\Lib\AutoXYWH.ahk

Menu Tray, Icon, shell32.dll, 24
Gui +Resize
Gui Add, ActiveX, hWndhDoc vDoc x0 y0 w703 h447, HTMLFile
Doc.write(HTML)
Gui Show, w703 h447, Toolbar Editor Help
Return

GuiSize:
    If (A_EventInfo == 1) {
        Return
    }

    AutoXYWH("wh", hDoc)
Return

GuiEscape:
GuiClose:
    ExitApp
