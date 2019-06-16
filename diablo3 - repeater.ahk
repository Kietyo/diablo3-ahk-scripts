#NoEnv
#SingleInstance Force
#IfWinActive ahk_exe Diablo III64.exe

INI_ERROR_MSG := "ERROR"

DEFAULT_INI_FILENAME := "settings.ini"
DEFAULT_INITIAL_KEYS := "Q"
DEFAULT_REPEATED_KEYS := "WE"
DEFAULT_MAX_RADIUS := 1000
DEFAULT_TOGGLE_RADIAL_CLICKS := 1

; Defines x and y coordinates for the center point of the character.
; Currently set for a 1440p monitor.
CHARACTER_CENTER_X := 1250
CHARACTER_CENTER_Y := 600

TOGGLE_RADIAL_CLICKS := DEFAULT_TOGGLE_RADIAL_CLICKS
MAX_RADIUS := DEFAULT_MAX_RADIUS
MAX_INTERVAL := 125
COUNTER := 0

INITIAL_KEYS := DEFAULT_INITIAL_KEYS
REPEATED_KEYS := DEFAULT_REPEATED_KEYS

MOUSE_LOCK := False

; Read in data from last saved file
Gosub, ReadSettings

; Window
Gui, Show, w300 h200, Choose Keys
; Left
Gui, Add, Text, x10 y10 w130 Center, Initial key presses:
Gui, Add, Edit, x10 y25 w130 h20 vINITIAL_KEYS Center, %INITIAL_KEYS%
Gui, Add, Text, x10 y50 w130 Center, Keys to repeat:
Gui, Add, Edit, x10 y65 w130 h20 vREPEATED_KEYS Center, %REPEATED_KEYS%

; Right
Gui, Add, Text, x160 y10 w100 Left, Enable radial clicks:
Gui, Add, Checkbox, x260 y10 Checked vToggleRadialClicks,

Gui, Add, Text, x160 y25 w100 Left, Max radius:
Gui, Add, Edit, x215 y25 w75 h15 vMAX_RADIUS Center, %MAX_RADIUS%


Gui, Add, Text, x160 y45 w100 Left, Toggle when inactive:
Gui, Add, CheckBox, x160 y60 vToggleQ, Q
Gui, Add, CheckBox, x190 y60 vToggleW, W
Gui, Add, CheckBox, x220 y60 vToggleE, E
Gui, Add, CheckBox, x250 y60 vToggleR, R

Gui, Add, Button, x10 y90 w130 h100 gSaveSettings, Save


q_not_active_color = 0x2C2B2A
w_not_active_color = 0x2D2B2A
e_not_active_color = 0x2E2D2C
r_not_active_color = 0x2E2D2C

AutoSend:
{
  if (GetKeyState("Alt", "P") || GetKeyState("t", "P") || GetKeyState("m", "P") || GetKeyState("Alt", "P")) {
    Return
  }
  MouseGetPos X, Y
  abs_x := Abs(CHARACTER_CENTER_X - X)
  abs_y := Abs(CHARACTER_CENTER_Y - Y)
  if (is_good_click_region(X, Y)) {
    if (Sqrt(abs_x*abs_x + abs_y*abs_y) <= MAX_RADIUS And TOGGLE_RADIAL_CLICKS) {
      Send, {Click}
    }
  }
  GuiControlGet, toggleQ,, ToggleQ
  GuiControlGet, toggleW,, ToggleW
  GuiControlGet, toggleE,, ToggleE
  GuiControlGet, toggleR,, ToggleR

  if (toggleQ) {
    PixelGetColor, ActiveColor, 940, 1330
    if (ActiveColor = q_not_active_color) {
      Send, "q"
    }
  }
  if (toggleW) {
    PixelGetColor, ActiveColor, 940, 1330
    if (ActiveColor = w_not_active_color) {
      Send, "w"
    }
  }
  if (toggleE) {
    PixelGetColor, ActiveColor, 1030, 1330
    if (ActiveColor = e_not_active_color) {
      Send, "e"
    }
  }
  if (toggleR) {
    PixelGetColor, ActiveColor, 1120, 1330
    if (ActiveColor = r_not_active_color) {
      Send, "r"
    }
  }

  Send, %REPEATED_KEYS%
  COUNTER := COUNTER + 1
  Return
}

; Reads in settings from a setting.ini file.
; If the file does not exist, then settings are set to defaults.
ReadSettings:
{
  IniRead, read_initial_keys, %DEFAULT_INI_FILENAME%, KEY_SETTINGS, INITIAL_KEYS
  IniRead, read_repeated_keys, %DEFAULT_INI_FILENAME%, KEY_SETTINGS, REPEATED_KEYS
  IniRead, read_max_radius, %DEFAULT_INI_FILENAME%, CLICK_SETTINGS, MAX_RADIUS
  IniRead, read_toggle_radial_clicks, %DEFAULT_INI_FILENAME%, CLICK_SETTINGS, TOGGLE_RADIAL_CLICKS

  if (read_initial_keys == INI_ERROR_MSG || read_repeated_keys == INI_ERROR_MSG || read_max_radius == INI_ERROR_MSG || read_toggle_radial_clicks == INI_ERROR_MSG) {
    MsgBox,, Information, Couldn't find %DEFAULT_INI_FILENAME%. Resorting to defaults.
    Gosub, SaveSettings
  } else {
    INITIAL_KEYS := read_initial_keys
    REPEATED_KEYS := read_repeated_keys
    MAX_RADIUS := read_max_radius
    TOGGLE_RADIAL_CLICKS := read_toggle_radial_clicks
  }
  return
}

; Save current settings to the DEFAULT_INI_FILENAME.
SaveSettings:
{
  GuiControlGet, toggleRadialClicks,, ToggleRadialClicks
  Gui, Submit, NoHide
  IniWrite, %INITIAL_KEYS%, %DEFAULT_INI_FILENAME%, KEY_SETTINGS, INITIAL_KEYS
  IniWrite, %REPEATED_KEYS%, %DEFAULT_INI_FILENAME%, KEY_SETTINGS, REPEATED_KEYS
  IniWrite, %MAX_RADIUS%, %DEFAULT_INI_FILENAME%, CLICK_SETTINGS, MAX_RADIUS
  IniWrite, %toggleRadialClicks%, %DEFAULT_INI_FILENAME%, CLICK_SETTINGS, toggleRadialClicks
  MsgBox,, Saved, Settings Saved!
  return
}

ToggleCheckbox:
{
  TOGGLE_RADIAL_CLICKS := !TOGGLE_RADIAL_CLICKS
}

; Does not work well.
cluster_click(x, y) {
  MOUSE_LOCK := False
  num_rows := 2
  num_cols := 2
  box_width := 50
  box_height := 50

  top_left_x := x - box_width/2
  top_left_y := y - box_height/2
  
  i := 0
  j := 0
  while (i < num_cols) {
    while (j < num_rows) {
      curr_x := top_left_x + box_width/num_cols*i
      curr_y := top_left_y + box_height/num_rows*j
      Send, {Click %curr_x%, %curr_y%}
      j := j + 1
    }
    i := i + 1
  }
  Send, {Click %x%, %y%}
  MOUSE_LOCK := True
  return
}

; Checks if the given x and y coordinates are in a good clickable region.
; Currently set for a 1440p monitor.
is_good_click_region(x, y) {
  ; Character portraits
  if (x <= 140 && y <= 800) {
    return false
  }

  ; Follower portraits
  if (x <= 260 && y <= 125) {
    return false
  }

  ; Skill Bar
  if (x >= 825 && x <= 1725 && y <= 1440 && y >= 1300) {
    return false
  }
  return true
}

CloseInventory() {
  active_inventory_color = 0x349ADB
  PixelGetColor, inventoryOpenColor, 2200, 100
  if (inventoryOpenColor = active_inventory_color) {
    Send, "i"
  }
}

F3::
Click, 360, 740 Left, Down
Click, 360, 740 Left, Up
Sleep, 2000
Click, 360, 740 Left, Down
Click, 360, 740 Left, Up
Sleep, 2000
Click, 360, 740 Left, Down
Click, 360, 740 Left, Up
Sleep, 2000
Click, 360, 740 Left, Down
Click, 360, 740 Left, Up
Sleep, 2000
Click, 360, 740 Left, Down
Click, 360, 740 Left, Up
Send, "t"
Click, 2000, 700, 0
Sleep, 8000
CloseInventory()
Click, 2000, 700 Left, Down
Click, 2000, 700 Left, Up
Sleep, 1500
Click, 1800, 1000 Left, Down
Click, 1800, 1000 Left, Up
Sleep, 1500
Click, 1655, 905 Left, Down
Click, 1655, 905 Left, Up
Sleep, 1000
Send, {Space}
Sleep, 50
Send, {Space}
Sleep, 50
Send, {Space}
Sleep, 50
Send, {Space}
Return



F4::
AutoSend := !AutoSend
If AutoSend {
  Send, %INITIAL_KEYS%
  SetTimer AutoSend, %MAX_INTERVAL%
} Else {
  SetTimer AutoSend, Off
}
Return

m::
if (AutoSend) {
  SetTimer AutoSend, Off
  keywait, m
  SetTimer AutoSend, %MAX_INTERVAL%
}
Send, m
Return

Escape::
ExitApp
Return