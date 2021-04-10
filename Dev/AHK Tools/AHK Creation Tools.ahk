
#NoEnv
#Warn
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

Gui Font, s15 Bold cBlack, Lucida Console
Gui Add, Text, x84 y10 w327 h23 +0x200, AutoHotkey Creation Tools
Gui Font
Gui Add, Button, x144 y86 w80 h23, AutoGUI
Gui Add, Button, x32 y85 w80 h23, Studio
Gui Font, Bold, Arial
Gui Add, GroupBox, x14 y54 w226 h76, DevApps
Gui Font
Gui Add, Text, x8 y43 w462 h2 0x10
Gui Add, Text, x19 y43 w444 h2 0x10
Gui Font, Bold, Arial
Gui Add, GroupBox, x247 y54 w218 h146, Tools / Resources
Gui Font
Gui Add, Button, gWrapper x263 y76 w120 h23, File Include Wrapper
Gui Add, Button, g2Exe x263 y104 w120 h23, AHK 2 exe
Gui Add, Link, x264 y135 w120 h23, <a href="http://www.iconarchive.com/">Icon Archive</a>
Gui Add, Button, gSpy x264 y165 w120 h23, Window Spy
Gui Add, Button, x14 y142 w225 h42, Project Files Folder
Gui Show, w479 h214, AHK Creation Tools
Return

GuiEscape:
GuiClose:
ExitApp

Spy:
{
	run "C:\Program Files (x86)\AutoHotkey\AU3_Spy.exe"
	return
}

2Exe:
{
	run "C:\Program Files (x86)\AutoHotkey\Compiler\Ahk2Exe.exe"
	return
}


Wrapper:
{
	run %A_ScriptDir%\Tools\File Include Wrapper.exe
	return
}

ButtonAutoGUI:
{
	run %A_ScriptDir%\AutoGUI\AutoGUI.ahk
	return
}
ButtonStudio:
{
	run %A_ScriptDir%\AHK-Studio-master\AHK-Studio.ahk
	return
}

ButtonProjectFilesFolder:
{ 
	Run %A_ScriptDir%\Projects\
	return
}

FileAppend, 

; Do not edit above this line