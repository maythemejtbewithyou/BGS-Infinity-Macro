#Include Image.ahk
#Include GUI.ahk
#Include FindText.ahk
#Include webhooksettings.ahk
#Include OCR-main\Lib\OCR.ahk

global settingsFile := ""
global confirmClicked := false

setupFilePath() {
    global settingsFile

    if !DirExist(A_ScriptDir "\Settings") {
        DirCreate(A_ScriptDir "\Settings")
    }

    settingsFile := A_ScriptDir "\Settings\Configuration.txt"
    return settingsFile
}

SavePsSettings(*) {
    ProcessLog("Saving Private Server")

    if FileExist("Settings\PrivateServer.txt")
        FileDelete("Settings\PrivateServer.txt")

    FileAppend(PsLinkBox.Value, "Settings\PrivateServer.txt", "UTF-8")
}

SaveUINavSettings(*) {
    ProcessLog("Saving UI Navigation Key")

    if FileExist("Settings\UINavigation.txt")
        FileDelete("Settings\UINavigation.txt")

    FileAppend(UINavBox.Value, "Settings\UINavigation.txt", "UTF-8")
}

;Opens discord Link
OpenDiscordLink() {
    Run("https://discord.gg/mistdomain")
}

;Minimizes the UI
minimizeUI(*) {
    aaMainUI.Minimize()
}

Destroy(*) {
    aaMainUI.Destroy()
    ExitApp
}
;Login Text
setupOutputFile() {
    content := "`n==" aaTitle "" version "==`n  Start Time: [" currentTime "]`n"
    FileAppend(content, currentOutputFile)
}

;Gets the current time
getCurrentTime() {
    currentHour := A_Hour
    currentMinute := A_Min
    currentSecond := A_Sec

    return Format("{:d}h.{:02}m.{:02}s", currentHour, currentMinute, currentSecond)
}

OnModeChange(*) {
    global mode
    selected := ModeDropdown.Text

    ; Hide all dropdowns first
    StoryDropdown.Visible := false
    LegendDropDown.Visible := false
    RaidDropdown.Visible := false
    RaidActDropdown.Visible := false
    InfinityCastleDropdown.Visible := false
    MatchMaking.Visible := false
    ReturnLobbyBox.Visible := false
    ContractPageDropdown.Visible := false
    ContractJoinDropdown.Visible := false

    if (selected = "Hatch Eggs") {
        StoryDropdown.Visible := true
        LegendDropDown.Visible := false
        EnchantModeDropdown.Visible := false
        EnchantsDropdown.Visible := false
        mode := "Hatch Eggs"
    } else if (selected = "Farm") {
        LegendDropDown.Visible := true
        AutoAbilityBox.Visible := true
        EnchantModeDropdown.Visible := false
        EnchantsDropdown.Visible := false
        StoryDropdown.Visible := false
        mode := "Legend"
    } else if (selected = "Reroll Enchants") {
        EnchantModeDropdown.Visible := true
        EnchantsDropdown.Visible := true
        StoryDropdown.Visible := false
        LegendDropDown.Visible := false

        mode := "Reroll Enchants"
    } else if (selected = "Infinity Castle") {
        InfinityCastleDropdown.Visible := true
        mode := "Infinity Castle"
    } else if (selected = "Contract") {
        ContractPageDropdown.Visible := true
        ContractJoinDropdown.Visible := true
        mode := "Contract"
    } else if (selected = "Dungeon") {
        mode := "Dungeon"
    }
}

OnRaidChange(*) {
    if (RaidDropdown.Text != "") {
        RaidActDropdown.Visible := true
    } else {
        RaidActDropdown.Visible := false
    }
}

OnConfirmClick(*) {
    if (ModeDropdown.Text = "") {
        ProcessLog("Please select a gamemode before confirming")
        return
    }

    ; For Story mode, check if both Story and Act are selected
    if (ModeDropdown.Text = "Story") {
        if (StoryDropdown.Text = "") {
            ProcessLog("Please select the egg before confirming")
            return
        }
        ProcessLog("Selected " StoryDropdown.Text)
    }
    ; For Legend mode, check if both Legend and Act are selected
    else if (ModeDropdown.Text = "Legend") {
        if (LegendDropDown.Text = "") {
            ProcessLog("Please select what to farm before starting.")
            return
        }
        ProcessLog("Selected " LegendDropDown.Text)
        MatchMaking.Visible := true
        ReturnLobbyBox.Visible := true
    }
    ; For Raid mode, check if both Raid and RaidAct are selected
    else if (ModeDropdown.Text = "Raid") {
        if (RaidDropdown.Text = "" || RaidActDropdown.Text = "") {
            ProcessLog("Please select both Raid and Act before confirming")
            return
        }
        ProcessLog("Selected " RaidDropdown.Text " - " RaidActDropdown.Text)
        MatchMaking.Visible := true
        ReturnLobbyBox.Visible := true
    }
    ; For Infinity Castle, check if mode is selected
    else if (ModeDropdown.Text = "Infinity Castle") {
        if (InfinityCastleDropdown.Text = "") {
            ProcessLog("Please select an Infinity Castle difficulty before confirming")
            return
        }
        ProcessLog("Selected Infinity Castle - " InfinityCastleDropdown.Text)
        MatchMaking.Visible := false
        ReturnLobbyBox.Visible := false
    }
    ; For Contract mode
    else if (ModeDropdown.Text = "Contract") {
        if (ContractPageDropdown.Text = "" || ContractJoinDropdown.Text = "") {
            ProcessLog("Please select both Contract Page and Join Type before confirming")
            return
        }
        ProcessLog("Selected Contract Page " ContractPageDropdown.Text " - " ContractJoinDropdown.Text)
        MatchMaking.Visible := false
        ReturnLobbyBox.Visible := true
    }
    else if (ModeDropdown.Text = "Dungeon") {
        ProcessLog("Selected Dungeon mode")
        SaveChestsBox.Visible := true  ; Show the save chests option for Dungeon mode
    }
    else {
        ProcessLog("Selected " ModeDropdown.Text " mode")
        MatchMaking.Visible := false
        ReturnLobbyBox.Visible := false
    }

    ; Hide all controls if validation passes
    ModeDropdown.Visible := false
    StoryDropdown.Visible := false
    LegendDropDown.Visible := false
    RaidDropdown.Visible := false
    RaidActDropdown.Visible := false
    InfinityCastleDropdown.Visible := false
    ConfirmButton.Visible := false
    modeSelectionGroup.Visible := false
    ContractPageDropdown.Visible := false
    ContractJoinDropdown.Visible := false
    EnchantModeDropdown.Visible := false
    EnchantsDropdown.Visible := false
    Hotkeytext.Visible := true
    Hotkeytext2.Visible := true
    global confirmClicked := true
}

FixClick(x, y, LR := "Left") {
    MouseMove(x, y)
    MouseMove(1, 0, , "R")
    MouseClick(LR, -1, 0, , , , "R")
    Sleep(50)
}

CaptchaDetect(x, y, w, h, inputX, inputY) {
    detectionCount := 0
    ProcessLog("Checking for numbers...")
    loop 10 {
        try {
            result := OCR.FromRect(x, y, w, h, "FirstFromAvailableLanguages", {
                grayscale: true,
                scale: 2.0
            })

            if result {
                ; Get text before any linebreak
                number := StrSplit(result.Text, "`n")[1]

                ; Clean to just get numbers
                number := RegExReplace(number, "[^\d]")

                if (StrLen(number) >= 5 && StrLen(number) <= 7) {
                    detectionCount++

                    if (detectionCount >= 1) {
                        ; Send exactly what we detected in the green text
                        FixClick(inputX, inputY)
                        Sleep(300)

                        ProcessLog("Sending number: " number)
                        for digit in StrSplit(number) {
                            Send(digit)
                            Sleep(120)
                        }
                        Sleep(200)
                        return true
                    }
                }
            }
        }
        Sleep(200)
    }
    ProcessLog("Could not detect valid captcha")
    return false
}

SaveKeybindSettings(*) {
    ProcessLog("Saving Keybind Configuration")

    if FileExist("Settings\Keybinds.txt")
        FileDelete("Settings\Keybinds.txt")

    FileAppend(Format("F1={}`nF2={}`nF3={}`nF4={}", F1Box.Value, F2Box.Value, F3Box.Value, F4Box.Value, F5Box.Value),
    "Settings\Keybinds.txt", "UTF-8")

    ; Update globals
    global F1Key := F1Box.Value
    global F2Key := F2Box.Value
    global F3Key := F3Box.Value
    global F4Key := F4Box.Value
    global F5Key := F5Box.Value

    ; Update hotkeys
    Hotkey(F1Key, (*) => moveRobloxWindow())
    Hotkey(F2Key, (*) => StartMacro())
    Hotkey(F3Key, (*) => Reload())
    Hotkey(F4Key, (*) => TogglePause())
    Hotkey(F5Key, (*) => GotoEggs())
}

LoadKeybindSettings() {
    if FileExist("Settings\Keybinds.txt") {
        fileContent := FileRead("Settings\Keybinds.txt", "UTF-8")
        loop parse, fileContent, "`n" {
            parts := StrSplit(A_LoopField, "=")
            if (parts[1] = "F1")
                global F1Key := parts[2]
            else if (parts[1] = "F2")
                global F2Key := parts[2]
            else if (parts[1] = "F3")
                global F3Key := parts[2]
            else if (parts[1] = "F4")
                global F4Key := parts[2]
            else if (parts[1] = "F5")
                global F5Key := parts[2]
        }
    }
}

ToggleSaveChestsForBoss(*) {
    global SaveChestsForBoss
    SaveChestsForBoss := !SaveChestsForBoss
    ProcessLog("Save chests for boss room: " (SaveChestsForBoss ? "Enabled" : "Disabled"))
}
