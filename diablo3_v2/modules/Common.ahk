#Requires AutoHotkey v2.0

class Point {
    __New(x, y) {
        this.x := x
        this.y := y
    }
}

class Color {
    __New(r, g, b) {
        this.r := r
        this.g := g
        this.b := b
    }
}

class PointColor {
    ; point: Point
    ; color: Color
    __New(point, color) {
        this.point := point
        this.color := color
    }
}

class Rect {
    __New(topLeftX, topLeftY, bottomRightX, bottomRightY) {
        this.topLeftX := topLeftX
        this.topLeftY := topLeftY
        this.bottomRightX := bottomRightX
        this.bottomRightY := bottomRightY
    }
}


global EMPTY_CENTER_STASH_COLOR := Color(43, 38, 28)

; R G B
global PIXEL_DIFF_TOLERANCE := 8.8

hexToRGB(hexColor) {
    ; Ensure it's a number, not a quoted string
    colorNum := hexColor + 0  ; Coerce string to number if needed

    r := (colorNum >> 16) & 0xFF
    g := (colorNum >> 8) & 0xFF
    b := colorNum & 0xFF
    return Color(r, g, b)
}

rgbSqrtDistance(rgb1, rgb2) {
    rDiff := rgb1.r - rgb2.r
    gDiff := rgb1.g - rgb2.g
    bDiff := rgb1.b - rgb2.b
    return Sqrt(rDiff * rDiff + gDiff * gDiff + bDiff * bDiff)
}

rgbString(rgb) {
    return "(r: " rgb.r ", g: " rgb.g ", b: " rgb.b ")"
}

isSimilarColor(color1, color2, tolerance := PIXEL_DIFF_TOLERANCE) {
    sqrtDistance := rgbSqrtDistance(color1, color2)
    return sqrtDistance <= tolerance
}

getPixelColorAt(x, y) {
    colorHex := PixelGetColor(x, y)
    return hexToRGB(colorHex)
}

class MonitorSettings {
    __New(screenWidth, screenHeight, inventoryRect, stashRect, blacksmithPanelActiveColors, blacksmithPanelWarningPanelOpenColors, blacksmithPanelSalvageButtonPoint) {
        this.screenWidth := screenWidth
        this.screenHeight := screenHeight
        this.inventoryRect := inventoryRect
        this.stashRect := stashRect

        this.blacksmithPanelActiveColors := blacksmithPanelActiveColors
        this.blacksmithPanelWarningPanelOpenColors := blacksmithPanelWarningPanelOpenColors
        this.blacksmithPanelSalvageButtonPoint := blacksmithPanelSalvageButtonPoint
    }

    slotWidth() {
        return (this.inventoryRect.bottomRightX - this.inventoryRect.topLeftX) / (INVENTORY_NUM_BOXES_WIDTH - 1)
    }
}

; For new users, implement your monitor settings similar to this and add your settings to the
; `MONITOR_SETTINGS` array.
global MONITOR_SETTINGS_2560_1600 := 
    MonitorSettings(2560, 1600,
                    ; Inventory positions
                    ; first x,y is the top left center of the first inventory slot
                    ; second x,y is the bottom right center of the last inventory slot
                    Rect(1831, 866, 2503, 1234),
                    ; Stash positions
                    Rect(144, 275, 957, 1456),

                    ; Blacksmith panel active colors
                    [
                        PointColor(Point(392, 120), Color(216, 213, 130))
                    ],
                    ; Blacksmith panel warning panel open colors
                    [
                        PointColor(Point(966, 280), Color(15, 18, 15))
                    ],
                    ; Blacksmith panel salvage button point
                    Point(247, 432)
                    )

global MONITOR_SETTINGS := [MONITOR_SETTINGS_2560_1600]

getBestMatchingMonitorSetting() {
    monitor_width := A_ScreenWidth
    monitor_height := A_ScreenHeight
    for (setting in MONITOR_SETTINGS) {
        if (setting.screenWidth == monitor_width && setting.screenHeight == monitor_height) {
            return setting
        }
    }
    monitor_dim := [monitor_width, monitor_height]
    throw Error("Monitor settings not found for dimensions: " toString(monitor_dim)
                "`nPlease create your own monitor settings."
    )
}

global CURRENT_MONITOR_SETTINGS := getBestMatchingMonitorSetting()

checkAllMatchingColors(expectedPointColors) {
    for index, expectedPointColor in expectedPointColors {
        actualColor := getPixelColorAt(expectedPointColor.point.x, expectedPointColor.point.y)
        ; MsgBox "Checking point: (" expectedPointColor.point.x ", " expectedPointColor.point.y "), expected color: " rgbString(expectedPointColor.color) ", actual color: " rgbString(actualColor)
        if (!isSimilarColor(actualColor, expectedPointColor.color)) {
            return false
        }
    }
    return true
}