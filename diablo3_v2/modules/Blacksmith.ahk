#Requires AutoHotkey v2.0

#Include "Common.ahk"

BlacksmithIsPanelActive() {
    return checkAllMatchingColors(CURRENT_MONITOR_SETTINGS.blacksmithPanelActiveColors)
}

BlacksmithClickSalvageButton() {
    salvageButtonCoords := CURRENT_MONITOR_SETTINGS.blacksmithPanelSalvageButtonPoint
    MouseMove salvageButtonCoords.x, salvageButtonCoords.y
    Sleep 50
    Click
}

BlacksmithIsWarningPanelOpen() {
  return checkAllMatchingColors(CURRENT_MONITOR_SETTINGS.blacksmithPanelWarningPanelOpenColors)
}