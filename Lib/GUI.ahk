#Requires AutoHotkey v2.0
#SingleInstance Force
#Include Image.ahk
#Include GameMango.ahk
#Include Functions.ahk
#Include webhooksettings.ahk

; Basic Application Info
global aaTitle := "Mejt's BGS Infinity "
global version := "v0"
global rblxID := "ahk_exe RobloxPlayerBeta.exe"
;Coordinate and Positioning Variables
global targetWidth := 816
global targetHeight := 638
global offsetX := -5
global offsetY := 1
global WM_SIZING := 0x0214
global WM_SIZE := 0x0005
global centerX := 408
global centerY := 320
global successfulCoordinates := []
;State Variables
global enabledUnits := Map()  
;Hotkeys
global F1Key := "F1"
global F2Key := "F2"
global F3Key := "F3"
global F4Key := "F4"
global F5Key := "F5"
;Statistics Tracking
global Wins := 0
global loss := 0
global mode := ""
global StartTime := A_TickCount
global currentTime := GetCurrentTime()
;Gui creation
global uiBorders := []
global uiBackgrounds := []
global uiTheme := []
global UnitData := []
global aaMainUI := Gui("+AlwaysOnTop -Caption")
global lastlog := ""
global aaMainUIHwnd := aaMainUI.Hwnd
;Theme colors
uiTheme.Push("0xffffff")  ; Header color
uiTheme.Push("0x1a1a1a")  ; Background color
uiTheme.Push("0x5b5b5b")    ; Border color
uiTheme.Push("0x3d3c35")  ; Accent color
uiTheme.Push("0x3d3c36")   ; Trans color
uiTheme.Push("000000")    ; Textbox color
uiTheme.Push("00ffb3") ; HighLight
;Logs/Save settings
global settingsGuiOpen := false
global SettingsGUI := ""
global currentOutputFile := A_ScriptDir "\Logs\LogFile.txt"
global WebhookURLFile := "Settings\WebhookURL.txt"
global DiscordUserIDFile := "Settings\DiscordUSERID.txt"
global SendActivityLogsFile := "Settings\SendActivityLogs.txt"

if !DirExist(A_ScriptDir "\Logs") {
    DirCreate(A_ScriptDir "\Logs")
}
if !DirExist(A_ScriptDir "\Settings") {
    DirCreate(A_ScriptDir "\Settings")
}

setupOutputFile()

;------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------
aaMainUI.BackColor := uiTheme[2]
global Webhookdiverter := aaMainUI.Add("Edit", "x0 y0 w1 h1 +Hidden", "") ; diversion
uiBorders.Push(aaMainUI.Add("Text", "x0 y0 w1364 h1 +Background" uiTheme[3]))  ;Top line
uiBorders.Push(aaMainUI.Add("Text", "x0 y0 w1 h630 +Background" uiTheme[3]))   ;Left line
uiBorders.Push(aaMainUI.Add("Text", "x1363 y0 w1 h630 +Background" uiTheme[3])) ;Right line
uiBackgrounds.Push(aaMainUI.Add("Text", "x3 y3 w1360 h27 +Background" uiTheme[2])) ;Title Top
uiBorders.Push(aaMainUI.Add("Text", "x0 y30 w1363 h1 +Background" uiTheme[3])) ;Title bottom
uiBorders.Push(aaMainUI.Add("Text", "x802 y30 w1 h600 +Background" uiTheme[3])) ;Roblox Right
uiBorders.Push(aaMainUI.Add("Text", "x803 y433 w560 h1 +Background" uiTheme[3])) ;Process Top
uiBorders.Push(aaMainUI.Add("Text", "x803 y461 w560 h1 +Background" uiTheme[3])) ;Process bottom
uiBorders.Push(aaMainUI.Add("Text", "x0 y630 w1364 h1 +Background" uiTheme[3], "")) ;Roblox bottom

global robloxHolder := aaMainUI.Add("Text", "x3 y33 w797 h597 +Background" uiTheme[5], "") ;Roblox window box
Global Discord := aaMainUI.Add("Picture", "x1255 y-4 w45 h42 +BackgroundTrans", Discord) ;Discord logo

Global reze := aaMainUI.Add("Picture", "x1013 y83 w350 h350 +BackgroundTrans", rezepic)

Discord.OnEvent("Click", (*) => OpenDiscordLink()) ;Open discord
global exitButton := aaMainUI.Add("Picture", "x1330 y1 w32 h32 +BackgroundTrans", Exitbutton) ;Exit image
exitButton.OnEvent("Click", (*) => Destroy()) ;Exit button
global minimizeButton := aaMainUI.Add("Picture", "x1300 y3 w27 h27 +Background" uiTheme[2], Minimize) ;Minimize gui
minimizeButton.OnEvent("Click", (*) => minimizeUI()) ;Minimize gui
aaMainUI.SetFont("Bold s16 c" uiTheme[1], "Verdana") ;Font
global windowTitle := aaMainUI.Add("Text", "x10 y3 w1200 h29 +BackgroundTrans", aaTitle "" . "" version) ;Title
aaMainUI.Add("Text", "x805 y435 w558 h25 +Center +BackgroundTrans", "Process") ;Process header
aaMainUI.SetFont("norm s11 c" uiTheme[1]) ;Font
global process1 := aaMainUI.Add("Text", "x810 y470 w538 h18 +BackgroundTrans c" uiTheme[7], "➤ Created by Mejt_t using Mist_Yuu's Macro (discord.gg/mistdomain)") ;Processes
global process2 := aaMainUI.Add("Text", "xp yp+22 w538 h18 +BackgroundTrans", "") 
global process3 := aaMainUI.Add("Text", "xp yp+22 w538 h18 +BackgroundTrans", "") 
global process4 := aaMainUI.Add("Text", "xp yp+22 w538 h18 +BackgroundTrans", "") 
global process5 := aaMainUI.Add("Text", "xp yp+22 w538 h18 +BackgroundTrans", "") 
global process6 := aaMainUI.Add("Text", "xp yp+22 w538 h18 +BackgroundTrans", "") 
global process7 := aaMainUI.Add("Text", "xp yp+22 w538 h18 +BackgroundTrans", "") 
WinSetTransColor(uiTheme[5], aaMainUI) ;Roblox window box

;--------------SETTINGS;--------------SETTINGS;--------------SETTINGS;--------------SETTINGS;--------------SETTINGS;--------------SETTINGS;--------------SETTINGS
ShowSettingsGUI(*) {
    global settingsGuiOpen, SettingsGUI
    
    ; Check if settings window already exists
    if (SettingsGUI && WinExist("ahk_id " . SettingsGUI.Hwnd)) {
        WinActivate("ahk_id " . SettingsGUI.Hwnd)
        return
    }
    
    if (settingsGuiOpen) {
        return
    }
    
    settingsGuiOpen := true
    SettingsGUI := Gui("-MinimizeBox +Owner" aaMainUIHwnd)  
    SettingsGui.Title := "Settings"
    SettingsGUI.OnEvent("Close", OnSettingsGuiClose)
    SettingsGUI.BackColor := uiTheme[2]
    
    ; Window border
    SettingsGUI.Add("Text", "x0 y0 w1 h600 +Background" uiTheme[3])     ; Left
    SettingsGUI.Add("Text", "x599 y0 w1 h600 +Background" uiTheme[3])   ; Right
    SettingsGUI.Add("Text", "x0 y399 w600 h1 +Background" uiTheme[3])   ; Bottom
    
    ; Right side sections
    SettingsGUI.SetFont("s10", "Verdana")
    SettingsGUI.Add("GroupBox", "x310 y5 w280 h160 c" uiTheme[1], "Discord Webhook")  ; Box
    
    ; Webhook
    SettingsGUI.SetFont("s9", "Verdana")
    SettingsGUI.Add("Text", "x320 y30 c" uiTheme[1], "Webhook URL")     ; Webhook Text
    global WebhookURLBox := SettingsGUI.Add("Edit", "x320 y50 w260 h20 c" uiTheme[6])  ; Store webhook
    global DiscordUserIDBox := SettingsGUI.Add("Edit", "x320 y103 w260 h20 c" uiTheme[6])  ; Store Discord ID
    DiscordUserIDBox.Visible := false
    global SendActivityLogsBox := SettingsGUI.Add("Checkbox", "x320 y135 c" uiTheme[1], "Send Process")  ; Enable Activity
    SendActivityLogsBox.Visible := false

    ; HotKeys
    SettingsGUI.Add("GroupBox", "x10 y90 w160 h160 c" uiTheme[1], "Keybinds")
    SettingsGUI.Add("Text", "x20 y110 c" uiTheme[1], "Position Roblox:")
    global F1Box := SettingsGUI.Add("Edit", "x125 y110 w30 h20 c" uiTheme[6], F1Key)
    SettingsGUI.Add("Text", "x20 y140 c" uiTheme[1], "Start Macro:")
    global F2Box := SettingsGUI.Add("Edit", "x100 y140 w30 h20 c" uiTheme[6], F2Key)
    SettingsGUI.Add("Text", "x20 y170 c" uiTheme[1], "Stop Macro:")
    global F3Box := SettingsGUI.Add("Edit", "x100 y170 w30 h20 c" uiTheme[6], F3Key)
    SettingsGUI.Add("Text", "x20 y200 c" uiTheme[1], "Pause Macro:")
    global F4Box := SettingsGUI.Add("Edit", "x110 y200 w30 h20 c" uiTheme[6], F4Key)
    global F5Box := SettingsGUI.Add("Edit", "x110 y200 w30 h20 c" uiTheme[6], F5Key)

    global PsLinkBox := SettingsGUI.Add("Edit", "x320 y320 w260 h20 c" uiTheme[6])  ;  ecit box
    PsLinkBox.Visible := false

    SettingsGUI.Add("GroupBox", "x10 y10 w115 h70 c" uiTheme[1], "UI Navigation")
    SettingsGUI.Add("Text", "x20 y30 c" uiTheme[1], "Navigation Key")
    global UINavBox := SettingsGUI.Add("Edit", "x20 y50 w20 h20 c" uiTheme[6], "\")

    ; Save buttons
    webhookSaveBtn := SettingsGUI.Add("Button", "x460 y135 w120 h25", "Save Webhook")
    webhookSaveBtn.OnEvent("Click", (*) => SaveWebhookSettings())
    
    keybindSaveBtn := SettingsGUI.Add("Button", "x20 y220 w50 h20", "Save")
    keybindSaveBtn.OnEvent("Click", SaveKeybindSettings)

    PsSaveBtn := SettingsGUI.Add("Button", "x460 y345 w120 h25", "Save PsLink")
    PsSaveBtn.Visible := false
    PsSaveBtn.OnEvent("Click", (*) => SavePsSettings())

    UINavSaveBtn := SettingsGUI.Add("Button", "x50 y50 w60 h20", "Save")
    UINavSaveBtn.OnEvent("Click", (*) => SaveUINavSettings())

    ; Loadsettings
    if FileExist(WebhookURLFile)
        WebhookURLBox.Value := FileRead(WebhookURLFile, "UTF-8")
    if FileExist(DiscordUserIDFile)
        DiscordUserIDBox.Value := FileRead(DiscordUserIDFile, "UTF-8")
    if FileExist(SendActivityLogsFile)
        SendActivityLogsBox.Value := (FileRead(SendActivityLogsFile, "UTF-8") = "1")   
    if FileExist("Settings\PrivateServer.txt")
        PsLinkBox.Value := FileRead("Settings\PrivateServer.txt", "UTF-8")
    if FileExist("Settings\UINavigation.txt")
        UINavBox.Value := FileRead("Settings\UINavigation.txt", "UTF-8")

    ; Show the settings window
    SettingsGUI.Show("w600 h400")
    Webhookdiverter.Focus()
}

OpenGuide(*) {
    GuideGUI := Gui("+AlwaysOnTop")
    GuideGUI.SetFont("s10 bold", "Segoe UI")
    GuideGUI.Title := "Anime adventures settings (Thank you faxi)"

    GuideGUI.BackColor := "0c000a"
    GuideGUI.MarginX := 20
    GuideGUI.MarginY := 20

    ; Add Guide content
    GuideGUI.SetFont("s16 bold", "Segoe UI")

    GuideGUI.Add("Text", "x0 w800 cWhite +Center", "1 - In your AA settings make sure you have these 2 settings set to this")
    GuideGUI.Add("Picture", "x100 w600 h160 cWhite +Center", "Images\aasettings.png")

    GuideGUI.Add("Text", "x0 w800 cWhite +Center", "2 - In your ROBLOX settings, make sure your keyboard is set to click to move and your graphics are set to 1 and enable UI navigation")
    GuideGUI.Add("Picture", "x50 w700   cWhite +Center", "Images\Clicktomove.png")
    GuideGUI.Add("Picture", "x50 w700   cWhite +Center", "Images\graphics1.png")
    GuideGUI.Add("Text", "x0 w800 cWhite +Center", "3 - Set up the unit setup however you want, however I'd avoid hill only units       if you can since it might break")

    GuideGUI.Add("Text", "x0 w800 cWhite +Center", "4 - Rejoin Anime Adventures, dont move your camera at all and press F2 to start the macro. Good luck!" )

    GuideGUI.Show("w800")
}

aaMainUI.SetFont("s12 Bold c" uiTheme[1])
global settingsBtn := aaMainUI.Add("Button", "x1160 y0 w90 h30", "Settings")
settingsBtn.OnEvent("Click", ShowSettingsGUI)
global guideBtn := aaMainUI.Add("Button", "x1060 y0 w90 h30", "Guide")
guideBtn.Visible := false

guideBtn.OnEvent("Click", OpenGuide)
aaMainUI.SetFont("s9")
global NextLevelBox := aaMainUI.Add("Checkbox", "x900 y385 cffffff Checked", "Placeholder4")
global MatchMaking := aaMainUI.Add("Checkbox", "x1035 y385 cffffff Hidden Checked", "Placeholder3")
global ReturnLobbyBox := aaMainUI.Add("Checkbox", "x900 y385 cffffff Checked", "Placeholder2")
global PriorityUpgrade := aaMainUI.Add("CheckBox", "x1005 y410 cffffff", "Placeholder6")
PriorityUpgrade.Visible := false
global SaveChestsBox := aaMainUI.Add("CheckBox", "x900 y385 cffffff Checked", "Placeholder5")
Hotkeytext := aaMainUI.Add("Text", "x807 y35 w530 h30", "To change keybinds click top right settings, Below are default hotkey settings ")
Hotkeytext2 := aaMainUI.Add("Text", "x807 y50 w530 h30", "F1:Reposition roblox window|F2:Start Macro|F3:Stop Macro|F4:Pause Macro")
;--------------SETTINGS;--------------SETTINGS;--------------SETTINGS;--------------SETTINGS;--------------SETTINGS;--------------SETTINGS;--------------SETTINGS
;--------------MODE SELECT;--------------MODE SELECT;--------------MODE SELECT;--------------MODE SELECT;--------------MODE SELECT;--------------MODE SELECT
global modeSelectionGroup := aaMainUI.Add("GroupBox", "x808 y38 w500 h45 Background" uiTheme[2], "Mode Select")
aaMainUI.SetFont("s10 c" uiTheme[6])
global ModeDropdown := aaMainUI.Add("DropDownList", "x818 y53 w140 h180 Choose0 +Center", ["Hatch Eggs", "Farm", "Reroll Enchants"])
global StoryDropdown := aaMainUI.Add("DropDownList", "x968 y53 w150 h180 Choose0 +Center", ["Common Egg", "Spotted Egg", "Iceshard Egg", "Spikey Egg", "Magma Egg", "Crystal Egg", "Lunar Egg", "Void Egg", "Hell Egg", "Nightmare Egg", "Rainbow Egg"])
global LegendDropDown := aaMainUI.Add("DropDownlist", "x968 y53 w150 h180 Choose0 +Center", ["Coins, Gems", "Eggs", "Bubbles"] )

global EnchantsDropdown := aaMainUI.Add("DropDownlist", "x960 y53 w100 h180 Choose0 +Center", ["Teamup IV", "Team up V", "Looter IV", "Looter V", "Bubbler IV", "Bubbler V", "Gleaming III"] )
global EnchantModeDropdown := aaMainUI.Add("DropDownList", "x1062 y53 w70 h180 Choose0 +Center", ["Gems", "Rerolls"])

global AutoAbilityBox := aaMainUI.Add("CheckBox", "x805 y410 cffffff Checked", "Auto-claim Chest and ticket (Only for Coins and Gems)")
global VIPChestBox := aaMainUI.Add("CheckBox", "x805 y390 cffffff Checked", "Auto-claim VIP chest (Autoclaim chest enabled required)")
global EnchantTierBox := aaMainUI.Add("CheckBox", "x805 y370 cffffff Checked", "Stops at 1 tier lower? (Not for Gleaming III)")

global RaidDropdown := aaMainUI.Add("DropDownList", "x968 y53 w150 h180 Choose0 +Center", ["Sacred Planet", "Strange Town", "Ruined City"])
global RaidActDropdown := aaMainUI.Add("DropDownList", "x1128 y53 w80 h180 Choose0 +Center", ["Act 1", "Act 2", "Act 3", "Act 4", "Act 5"])
global InfinityCastleDropdown := aaMainUI.Add("DropDownList", "x968 y53 w80 h180 Choose0 +Center", ["Normal", "Hard"])
global ContractPageDropdown := aaMainUI.Add("DropDownList", "x968 y53 w80 h180 Choose0 +Center", ["Page 1", "Page 2","Page 3","Page 4","Page 5","Page 6", "Page 4-5"])
global ContractJoinDropdown := aaMainUI.Add("DropDownList", "x1057 y53 w120 h180 Choose0 +Center", ["Creating", "Joining","Matchmaking"])
global ConfirmButton := aaMainUI.Add("Button", "x1218 y53 w80 h25", "Confirm")

EnchantModeDropdown.Visible := false
EnchantsDropdown.Visible := false
StoryDropdown.Visible := false
LegendDropDown.Visible := false
RaidDropdown.Visible := false
RaidActDropdown.Visible := false
InfinityCastleDropdown.Visible := false
ContractPageDropdown.Visible := false
ContractJoinDropdown.Visible := false
MatchMaking.Visible := false
ReturnLobbyBox.Visible := false
NextLevelBox.Visible := false
Hotkeytext.Visible := false
Hotkeytext2.Visible := false
SaveChestsBox.Visible := false
ModeDropdown.OnEvent("Change", OnModeChange)
RaidDropdown.OnEvent("Change", OnRaidChange)
ConfirmButton.OnEvent("Click", OnConfirmClick)
SaveChestsBox.OnEvent("Click", ToggleSaveChestsForBoss)
;------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI
;------UNIT CONFIGURATION------UNIT CONFIGURATION------UNIT CONFIGURATION/------UNIT CONFIGURATION/------UNIT CONFIGURATION/------UNIT CONFIGURATION/

;Create Unit slot
y_start := 85
y_spacing := 50

aaMainUI.SetFont("s8 c" uiTheme[6])

aaMainUI.Show("w1366 h633")
WinMove(0, 0,,, "ahk_id " aaMainUIHwnd)
forceRobloxSize()  ; Initial force size and position
;------UNIT CONFIGURATION ;------UNIT CONFIGURATION ;------UNIT CONFIGURATION ;------UNIT CONFIGURATION ;------UNIT CONFIGURATION ;------UNIT CONFIGURATION ;------UNIT CONFIGURATION
;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS

;Process text
ProcessLog(current) { 
    global process1, process2, process3, process4, process5, process6, process7, currentOutputFile, lastlog

    ; Remove arrow from all lines first
    process7.Value := StrReplace(process6.Value, "➤ ", "")
    process6.Value := StrReplace(process5.Value, "➤ ", "")
    process5.Value := StrReplace(process4.Value, "➤ ", "")
    process4.Value := StrReplace(process3.Value, "➤ ", "")
    process3.Value := StrReplace(process2.Value, "➤ ", "")
    process2.Value := StrReplace(process1.Value, "➤ ", "")
    
    ; Add arrow only to newest process
    process1.Value := "➤ " . current
    
    Sleep(50)
    FileAppend(current . " " . "`n", currentOutputFile)

    ; Add webhook logging
    lastlog := current
    if FileExist("Settings\SendActivityLogs.txt") {
        SendActivityLogsStatus := FileRead("Settings\SendActivityLogs.txt", "UTF-8")
    }
}

;Basically the code to move roblox, below

sizeDown() {
    global rblxID
    
    if !WinExist(rblxID)
        return

    WinGetPos(&X, &Y, &OutWidth, &OutHeight, rblxID)
    
    ; Exit fullscreen if needed
    if (OutWidth >= A_ScreenWidth && OutHeight >= A_ScreenHeight) {
        Send "{F11}"
        Sleep(100)
    }

    ; Force the window size and retry if needed
    Loop 3 {
        WinMove(X, Y, targetWidth, targetHeight, rblxID)
        Sleep(100)
        WinGetPos(&X, &Y, &OutWidth, &OutHeight, rblxID)
        if (OutWidth == targetWidth && OutHeight == targetHeight)
            break
    }
}

moveRobloxWindow() {
    global aaMainUIHwnd, offsetX, offsetY, rblxID
    
    if !WinExist(rblxID) {
        ProcessLog("Waiting for Roblox window...")
        return
    }

    ; First ensure correct size
    sizeDown()
    
    ; Then move relative to main UI
    WinGetPos(&x, &y, &w, &h, aaMainUIHwnd)
    WinMove(x + offsetX, y + offsetY,,, rblxID)
    WinActivate(rblxID)
}

forceRobloxSize() {
    global rblxID
    
    if !WinExist(rblxID) {
        checkCount := 0
        While !WinExist(rblxID) {
            Sleep(5000)
            if(checkCount >= 5) {
                ProcessLog("Attempting to locate the Roblox window")
            } 
            checkCount += 1
            if (checkCount > 12) { ; Give up after 1 minute
                ProcessLog("Could not find Roblox window")
                return
            }
        }
        ProcessLog("Found Roblox window")
    }

    WinActivate(rblxID)
    sizeDown()
    moveRobloxWindow()
}
;Basically the code to move roblox, Above
OnSettingsGuiClose(*) {
    global settingsGuiOpen, SettingsGUI
    settingsGuiOpen := false
    if SettingsGUI {
        SettingsGUI.Destroy()
        SettingsGUI := ""  ; Clear the GUI reference
    }
}

checkSizeTimer() {
    if (WinExist("ahk_exe RobloxPlayerBeta.exe")) {
        WinGetPos(&X, &Y, &OutWidth, &OutHeight, "ahk_exe RobloxPlayerBeta.exe")
        if (OutWidth != 816 || OutHeight != 638) {
            ProcessLog("Fixing Roblox window size")
            moveRobloxWindow()
        }
    }
}

