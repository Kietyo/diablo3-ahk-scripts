#Requires AutoHotkey v2.0


#Include "modules\Main.ahk"
#Include "modules\Blacksmith.ahk"


leftClickInventory(x_index_start := 0, y_index_start := 0) {
    is_initial_run := true
    x_index := x_index_start
    outer:
    while (x_index < INVENTORY_NUM_BOXES_WIDTH)
    {
        y_index := 0
        if (is_initial_run) {
            y_index := y_index_start
        }
        while (y_index < INVENTORY_NUM_BOXES_HEIGHT)
        {
            is_initial_run := false
            is_esc_pressed := GetKeyState("Esc")
            if (is_esc_pressed) {
                break outer
            }

            coords := getInventoryCenterCoord(x_index, y_index)
            if (!isCoordSlotEmpty(coords)) {
                leftClickAtCoord(coords)
            }
            y_index += 1
        }
        x_index += 1

    }
    moveMouseToCenter()
}


F8::
{
    ; coords := getInventoryCenterCoord(0, 0)
    ; MsgBox("isCoordSlotEmpty: " . isCoordSlotEmpty(coords))
    ; MouseMove coords[1], coords[2]

    ; MsgBox("BlacksmithIsPanelActive: " . BlacksmithIsPanelActive())

    if (BlacksmithIsPanelActive()) {
        BlacksmithClickSalvageButton()
        leftClickInventory()
    } else {
        MsgBox("Blacksmith panel is not active.")
    }


    ; mouse_coords := currentMouseCoords()
    ; best_xy_index := getBestMatchingStashSlotXYIndex(mouse_coords[1], mouse_coords[2])

    ; MsgBox "mouse_coords: " toString(mouse_coords) ", best_xy_index: " toString(best_xy_index)
    ; MsgBox "A_ScreenWidth: " A_ScreenWidth ", A_ScreenHeight: " A_ScreenHeight

    ; slot_width := Abs(INVENTORY_TOP_LEFT_MIDDLE_BOX_POS_X - INVENTORY_BOTTOM_RIGHT_MIDDLE_BOX_POS_X) / (INVENTORY_NUM_BOXES_WIDTH - 1)
    ; threshold := calculateItemSlotSquareThreshold()

    ; MsgBox "slot_width: " slot_width ", threshold: " threshold

    ; coords := getInventoryCenterCoord(0, 0)

    ; is_slot_empty := isCoordSlotEmptyDebug(coords)

    ; MsgBox "is_slot_empty: " is_slot_empty

    ; color := PixelGetColor(coords[1], coords[2])

    ; rgb := hexToRGB(color)

    ; sqrtDistance := rgbSqrtDistance(rgb, EMPTY_CENTER_STASH_COLOR)

    ; isCoordSlotEmptyV := isCoordSlotEmpty(coords)

    ; MsgBox "Got color: " . color . ", r: " . rgb[1] . ", g: " . rgb[2] . ", b: " . rgb[3] . ", sqrtDistance: " . sqrtDistance . ", isCoordSlotEmptyV: " . isCoordSlotEmptyV
}

F9::
{
    ; curr_mouse_coords := currentMouseCoords()
    ; xy_index := getBestMatchingStashSlotXYIndex(curr_mouse_coords[1], curr_mouse_coords[2])
    ; if (xy_index[1] != -1) {
    ;     shiftClickStash(xy_index[1], xy_index[2])
    ; }
}

F10::
{
    shiftClickStash()
}

F11::
{
    curr_mouse_coords := currentMouseCoords()
    xy_index := getBestMatchingInventorySlotXYIndex(curr_mouse_coords[1], curr_mouse_coords[2])
    if (xy_index[1] != -1) {
        shiftClickInventory(xy_index[1], xy_index[2])
    }
}

F12::
{
    shiftClickInventory()
}

; l::
; {
;     MsgBox "AutoHotkey version: %A_AhkVersion%"
; }

; Esc::
; {
;     ExitApp()
; }