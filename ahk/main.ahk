#Requires AutoHotkey v2.0
#SingleInstance Force

; Initialize keyboard states on script start
SetInitialStates() {
    SetNumLockState "AlwaysOn"
    SetCapsLockState "AlwaysOff"
    SetScrollLockState "AlwaysOff"
}

; Date/time formatting functions
SendDateTime(format) {
    SendText FormatTime(, format)
}

; System hibernation function (updated parameter handling)
HibernatePC(*) {  ; Add variadic parameter
    try {
        DllCall("PowrProf\SetSuspendState", "Int", 1, "Int", 0, "Int", 0)
    } catch Error as e {
        MsgBox "Hibernation failed: " e.Message
    }
}

; Set initial keyboard states
SetInitialStates()

; Configure hotkeys using modern syntax
Hotkey("^+u", (*) => SendDateTime("yyyy-MM-dd"))      ; Short date
Hotkey("^+i", (*) => SendDateTime("yyyy-MM-dd HH:mm:ss"))  ; Long datetime
Hotkey("^+_", (*) => SendDateTime("yyyy_MM_dd_HH_mm_ss"))  ; Filename format

; Configure hibernation hotkey
Hotkey "#h", HibernatePC

; Specify the path to your Greenshot image editor executable
ProgPath := "C:\Program Files\Greenshot\Greenshot.exe"
; Specify the directory in which to look for screenshots
ScreenshotDir := "C:\Users\e-prwk\Screenshots"

; Define a hotkey to open the latest screenshot in Greenshot
Hotkey("^+e", OpenLatestScreenshot)  ; Ctrl+Shift+E

OpenLatestScreenshot() {
    global ProgPath, ScreenshotDir
    ; Look for the most recent PNG file; adjust the pattern if needed (e.g. "*.jpg")
    latestFile := GetLatestFile(ScreenshotDir, "*.png")
    if (latestFile != "") {
        ; Run Greenshot and pass the file path as a parameter.
        ; The parameter is wrapped in double quotes to handle any spaces.
        Run(ProgPath, ` "" . latestFile . ` "")
    } else {
        MsgBox "No latest screenshot found in " . ScreenshotDir
    }
}

; Helper function: loops over files matching the pattern and returns the full path
; of the file that was most recently modified.
GetLatestFile(dir, pattern := "*.*") {
    latestFile := ""
    latestTime := ""
    dummy := Files  ; Dummy assignment to suppress warning
    for file in Files(dir . "\\" . pattern) {
        ; Compare TimeModified strings (which are zero-padded) directly.
        if (latestTime = "" || file.TimeModified > latestTime) {
            latestTime := file.TimeModified
            latestFile := file.FullName
        }
    }
    return latestFile
}
