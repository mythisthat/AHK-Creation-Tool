﻿; Generated by AutoGUI 1.3.3a
#NoEnv
#Warn
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

Gui Font, s20 Bold
Gui Add, Text, x129 y13 w222 h42 +0x200, The useless GUI
Gui Font
Gui Add, Edit, x36 y238 w418 h21, Type Stuff
Gui Add, Link, x316 y268 w26 h23, <a href="https://autohotkey.com">AHK</a>
Gui Add, CheckBox, x41 y267 w120 h23, CheckBox
Gui Add, CheckBox, x175 y267 w120 h23, CheckBox
Gui Add, Tab3, x32 y69 w424 h160, Utilities|Stuff|TreeView
Gui Tab, 1
Gui Add, Button, x59 y109 w118 h23, Internet Explorer
Gui Add, Button, x59 y143 w118 h23, CMD
Gui Add, Button, x59 y174 w117 h23, Notepad
Gui Add, Picture, x325 y102 w104 h108, C:\Users\Ryzen5\Downloads\GUI.JPG
Gui Tab, 2
Gui Add, ListView, x39 y93 w409 h127, ListView
Gui Tab, 3
Gui Add, TreeView, x42 y97 w400 h124
P1 := TV_Add("First parent")
P1C1 := TV_Add("Parent 1's first child", P1)  ; Specify P1 to be this item's parent.
P2 := TV_Add("Second parent")
P2C1 := TV_Add("Parent 2's first child", P2)
P2C2 := TV_Add("Parent 2's second child", P2)
P2C2C1 := TV_Add("Child 2's first child", P2C2)
Gui Show, w487 h313, Window
Return

GuiEscape:
GuiClose:
ExitApp

ButtonInternetExplorer:
run, iexplore.exe
return

ButtonCMD:
run, cmd.exe
run, %comspec% /k ipconfig /all, , max
return

ButtonNotepad:
run, notepad.exe
return


; Do not edit above this line