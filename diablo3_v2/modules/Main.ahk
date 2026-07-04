

#Requires AutoHotkey v2.0
#Include "Common.ahk"

global INVENTORY_NUM_BOXES_WIDTH := 10
global INVENTORY_NUM_BOXES_HEIGHT := 6




calculateItemSlotSquareThreshold() {
    return (CURRENT_MONITOR_SETTINGS.slotWidth() / 2) - 1
}

; Imagine a square centered around a point.
; This threshold is the orthogonal distance from the center point to a side of the square.
global ITEM_SLOT_SQUARE_THRESHOLD := calculateItemSlotSquareThreshold()

global INVENTORY_TOP_LEFT_MIDDLE_BOX_POS_X := CURRENT_MONITOR_SETTINGS.inventoryRect.topLeftX
global INVENTORY_TOP_LEFT_MIDDLE_BOX_POS_Y := CURRENT_MONITOR_SETTINGS.inventoryRect.topLeftY

global INVENTORY_BOTTOM_RIGHT_MIDDLE_BOX_POS_X := CURRENT_MONITOR_SETTINGS.inventoryRect.bottomRightX
global INVENTORY_BOTTOM_RIGHT_MIDDLE_BOX_POS_Y := CURRENT_MONITOR_SETTINGS.inventoryRect.bottomRightY

global INVENTORY_X_DELTA := (INVENTORY_BOTTOM_RIGHT_MIDDLE_BOX_POS_X - INVENTORY_TOP_LEFT_MIDDLE_BOX_POS_X) / (INVENTORY_NUM_BOXES_WIDTH - 1)
global INVENTORY_Y_DELTA := (INVENTORY_BOTTOM_RIGHT_MIDDLE_BOX_POS_Y - INVENTORY_TOP_LEFT_MIDDLE_BOX_POS_Y) / (INVENTORY_NUM_BOXES_HEIGHT - 1)

getInventoryCenterCoordX(x_index) {
    global INVENTORY_TOP_LEFT_MIDDLE_BOX_POS_X
    global INVENTORY_X_DELTA
    return INVENTORY_TOP_LEFT_MIDDLE_BOX_POS_X + (x_index * INVENTORY_X_DELTA)
}

getInventoryCenterCoordY(y_index) {
    global INVENTORY_TOP_LEFT_MIDDLE_BOX_POS_Y
    global INVENTORY_Y_DELTA
    return INVENTORY_TOP_LEFT_MIDDLE_BOX_POS_Y + (y_index * INVENTORY_Y_DELTA)
}

; Returns the coordinates to the center of an inventory slot for a given
; x_index, y_index.
; We expect indexes to be 0-indexed
getInventoryCenterCoord(x_index, y_index) {
    x := getInventoryCenterCoordX(x_index)
    y := getInventoryCenterCoordY(y_index)
    return [x, y]
}

; Returns the x index for the inventory slot that best matches the given x_coord.
; If none is found, -1 is returned.
getBestMatchingInventorySlotXIndex(x_coord) {
    x_index := 0
    Loop INVENTORY_NUM_BOXES_WIDTH {
        inventory_x_coord := getInventoryCenterCoordX(x_index)
        if (Abs(inventory_x_coord - x_coord) <= ITEM_SLOT_SQUARE_THRESHOLD) {
            return x_index
        }
        x_index += 1
    }
    return -1
}

; Returns the y index for the inventory slot that best matches the given y_coord.
; If none is found, -1 is returned.
getBestMatchingInventorySlotYIndex(y_coord) {
    y_index := 0
    Loop INVENTORY_NUM_BOXES_HEIGHT {
        inventory_y_coord := getInventoryCenterCoordY(y_index)
        if (Abs(inventory_y_coord - y_coord) <= ITEM_SLOT_SQUARE_THRESHOLD) {
            return y_index
        }
        y_index += 1
    }
    return -1
}

; Returns the xy index for the inventory slot that best matches the given coords.
; If none is found or if either x or y index cannot be found, returns [-1, -1]
getBestMatchingInventorySlotXYIndex(x_coord, y_coord) {
    x_index := getBestMatchingInventorySlotXIndex(x_coord)
    y_index := getBestMatchingInventorySlotYIndex(y_coord)
    if (x_index == -1 || y_index == -1) {
        return [-1, -1]
    }
    return [x_index, y_index]
}

global STASH_TOP_LEFT_MIDDLE_BOX_POS_X := CURRENT_MONITOR_SETTINGS.stashRect.topLeftX
global STASH_TOP_LEFT_MIDDLE_BOX_POS_Y := CURRENT_MONITOR_SETTINGS.stashRect.topLeftY

global STASH_BOTTOM_RIGHT_MIDDLE_BOX_POS_X := CURRENT_MONITOR_SETTINGS.stashRect.bottomRightX
global STASH_BOTTOM_RIGHT_MIDDLE_BOX_POS_Y := CURRENT_MONITOR_SETTINGS.stashRect.bottomRightY

global STASH_NUM_BOXES_WIDTH := 12
global STASH_NUM_BOXES_HEIGHT := 17

global STASH_X_DELTA := (STASH_BOTTOM_RIGHT_MIDDLE_BOX_POS_X - STASH_TOP_LEFT_MIDDLE_BOX_POS_X) / (STASH_NUM_BOXES_WIDTH - 1)
global STASH_Y_DELTA := (STASH_BOTTOM_RIGHT_MIDDLE_BOX_POS_Y - STASH_TOP_LEFT_MIDDLE_BOX_POS_Y) / (STASH_NUM_BOXES_HEIGHT - 1)

global SCREEN_MIDDLE_POS_X := 1270
global SCREEN_MIDDLE_POS_Y := 800

getStashCenterCoordX(x_index) {
    global STASH_TOP_LEFT_MIDDLE_BOX_POS_X
    global STASH_X_DELTA
    return STASH_TOP_LEFT_MIDDLE_BOX_POS_X + (x_index * STASH_X_DELTA)
}

getStashCenterCoordY(y_index) {
    global STASH_TOP_LEFT_MIDDLE_BOX_POS_Y
    global STASH_Y_DELTA
    return STASH_TOP_LEFT_MIDDLE_BOX_POS_Y + (y_index * STASH_Y_DELTA)
}

; Returns the coordinates to the center of an inventory slot for a given
; x_index, y_index.
; We expect indexes to be 0-indexed
getStashCenterCoord(x_index, y_index) {
    x := getStashCenterCoordX(x_index)
    y := getStashCenterCoordY(y_index)
    return [x, y]
}

; Returns the x index for the inventory slot that best matches the given x_coord.
; If none is found, -1 is returned.
getBestMatchingStashSlotXIndex(x_coord) {
    x_index := 0
    Loop STASH_NUM_BOXES_WIDTH {
        stash_x_coord := getStashCenterCoordX(x_index)
        if (Abs(stash_x_coord - x_coord) <= ITEM_SLOT_SQUARE_THRESHOLD) {
            return x_index
        }
        x_index += 1
    }
    return -1
}

; Returns the y index for the inventory slot that best matches the given y_coord.
; If none is found, -1 is returned.
getBestMatchingStashSlotYIndex(y_coord) {
    y_index := 0
    Loop STASH_NUM_BOXES_HEIGHT {
        stash_y_coord := getStashCenterCoordY(y_index)
        if (Abs(stash_y_coord - y_coord) <= ITEM_SLOT_SQUARE_THRESHOLD) {
            return y_index
        }
        y_index += 1
    }
    return -1
}

; Returns the xy index for the inventory slot that best matches the given coords.
; If none is found or if either x or y index cannot be found, returns [-1, -1]
getBestMatchingStashSlotXYIndex(x_coord, y_coord) {
    x_index := getBestMatchingStashSlotXIndex(x_coord)
    y_index := getBestMatchingStashSlotYIndex(y_coord)
    if (x_index == -1 || y_index == -1) {
        return [-1, -1]
    }
    return [x_index, y_index]
}


isCoordSlotEmpty(coords) {
    rgb1 := getPixelColorAt(coords[1], coords[2])
    ; Sample another pixel to reduce false positives
    yOffset := (CURRENT_MONITOR_SETTINGS.slotWidth() / 2) - 14
    rgb2 := getPixelColorAt(coords[1], coords[2] - yOffset)

    return isSimilarColor(rgb1, EMPTY_CENTER_STASH_COLOR) and isSimilarColor(rgb2, EMPTY_CENTER_STASH_COLOR)
}

leftClickAtCoord(coords) {
    MouseMove coords[1], coords[2]
    Sleep 55
    Send "{Click Right}"
}

shiftClickAtCoord(coords) {
    MouseMove coords[1], coords[2]
    Send "{Shift Down}{Click Right}"
    Sleep 55
    Send "{Shift up}"
}

currentMouseCoords() {
    MouseGetPos &x_coord, &y_coord
    return [x_coord, y_coord]
}

moveMouseToCenter() {
    MouseMove SCREEN_MIDDLE_POS_X, SCREEN_MIDDLE_POS_Y
}

toString(var) {
    type_var := Type(var)
    if (type_var = "Array") {
        str := "["
        for i, val in var {
            str .= (i > 1 ? ", " : "") . val
        }
        str .= "]"
        return str
    }
    return "asdfasdf"
}


shiftClickStash(x_index_start := 0, y_index_start := 0) {
    is_initial_run := true
    x_index := x_index_start
    outer:
    while (x_index < STASH_NUM_BOXES_WIDTH)
    {
        y_index := 0
        if (is_initial_run) {
            y_index := y_index_start
        }
        while (y_index < STASH_NUM_BOXES_HEIGHT)
        {
            is_initial_run := false
            is_esc_pressed := GetKeyState("Esc")
            if (is_esc_pressed) {
                break outer
            }

            coords := getStashCenterCoord(x_index, y_index)
            if (!isCoordSlotEmpty(coords)) {
                shiftClickAtCoord(coords)
            }
            y_index += 1
        }
        x_index += 1

    }
    moveMouseToCenter()
}

shiftClickInventory(x_index_start := 0, y_index_start := 0) {
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
                shiftClickAtCoord(coords)
            }
            y_index += 1
        }
        x_index += 1

    }
    moveMouseToCenter()
}
