#Requires AutoHotkey v2.0
#Include Image.ahk
#Include GUI.ahk
#Include FindText.ahk
#Include Functions.ahk
#Include Functions.ahk
#Include webhooksettings.ahk

; Enchants
LooterV :=
    "|<>*134$65.0000000000000000000000E0000000E41s000w001sw6E0038004F4AUC3aMsyAqMN1zTszzy8cUm63UUMA4Fl1YM200UM8F438X0laAHkW86F71nA1Y0UUAz4F6Qz8110M21UQ86E140k67VgsAU3M0zztyDTz03U000000000000000000000000000000000U"
GleamingIII :=
    "|<>*136$84.000000000000000000000000000000000000000000000000000000000CD00003k0014E0zz00007k003zw1zz00007k007zw3zzD1hgrqkT7zw7zzTrzzzzxzbzw7zzzzzzzzzzbzw7zzzzzzzzzzbzw7zzzzzzzzzzbzw7zzzzzzzzzzbzw3zzzzzzzzzzbzw3zzzzzzzzzzbzw1zzzzzzzzzzbzw0zjzrzzzzTzXzw0000000003z0000000000003z0000000000001y000U"
LooterIV :=
    "|<>*133$71.000000000000000000000000000000000000000000000U80w000S000zls38001Y0038W86E71nAQT6NgkAUzjwTzzAlF0N31kEA62NXW0mA100EA4nW81YFUMn69tZ4E38XUta0m39106TW8XCTY6G20A10kC438AW80M33kqQ6EN6k0Tzwz7jzUS70000000000000000000000000000000000001"
BubblerV :=
    "|<>*128$71.0000000000000000000000007U0sC3U00410zk3MqAU00SD30k6FYN001YH60wQnAmCBXBaAtxtyTZzzWP8NnCEQ7C316Qkm6QUM6M624t1aAtAH4nAwAa3CNmQb9UN0886Ql4F4HDm0MkA1U861W1Y0F0M7mGQba380q0Tszzjtzzk0s000000000000000000000000000000000000U"
BubblerIV :=
    "|<>*126$70.00000000000000000000000000000000000000000000000000000000003U0Q71k00082zk38mAU00Tsy1UAX8m003AWM3lnAn8sqAmNbDjDnwjzwnB6QnY71nUkHCQt3CEA3A31AtmaAtAH4n4wmmOQHYtCH0m3919n4F4FAz8AaAUA10kAEAUm8W1wY71tUm38qDwTzrwzzs7Vk00000000000000000000000000000000000U"
TeamupIV :=
    "|<>*130$84.000000000000003z00000000010EDzk0000DD00zls80E0000N9U1aFAA0z1BckN8u1aPA7bzrzzsN8zVaO80akQ22AN8UlbCM0bUM204N8UNbCE0ba9WNaN9a9ZYk0bUNWNaNta9YUU0bbs2Na8lUNYlU0aUM2NaA3UFYF00YkQKNa67ZlYP00wTrzzw3xb0wC0000000001Y0000000000001Y0000000000000w000000000000000000U"
TeamupV :=
    "|<>*133$81.00000000000000000000000000000000000000000000000000000000000000000001zk00002100820zz00000wy03ls4080000AYk0m9Uk3w6qn1Ybc6PA3nzvzzwAYzkHN02P1k88lYa33CM0HkA102AYkA9m02SNa9aNYaMVYk0HkAlAnAwn44402STW9aMX61UlU0HEA1An61k82802P1lNaMMSL0P00SDvzzy1ynU1k0000000006E000000000000m0000000000003k00000000000000000U"

global macroStartTime := A_TickCount
global stageStartTime := A_TickCount
global contractPageCounter := 0
global contractSwitchPattern := 0
global BossRoomCompleted := false
global SaveChestsForBoss := true

;HotKeys
F1:: moveRobloxWindow()
F2:: StartMacro()
F3:: Reload()
F4:: TogglePause()
F5:: stuff()

Teleport() {
    SendInput("{m}")
    Sleep 1000
    loop 20 {
        Send "{WheelDown}"
        Sleep 50
    }
    Sleep 600
    FixClick(400, 560)
    Sleep 1500
}

MiniZoom() {
    MouseMove(400, 300)
    Sleep 100

    ; Zoom in smoothly
    loop 20 {
        Send "{WheelUp}"
        Sleep 50
    }

    ; Look down
    Click
    MouseMove(400, 400)  ; Move mouse down to angle camera down

    ; Zoom back out smoothly
    loop 50 {
        Send "{WheelDown}"
        Sleep 50
    }

    ; Move mouse back to center
    MouseMove(400, 300)
}

ResetCharacter() {
    SendInput("{Esc}")
    Sleep 600
    SendInput("{r}")
    Sleep 600
    SendInput("{Enter}")
    Sleep 4500
}

EnableClickToMove() {
    ProcessLog("Enabling click to move.")
    SendInput("{Esc}")
    Sleep 1000
    FixClick(250, 91)
    Sleep 500
    loop {
        if (ok := FindText(&X, &Y, 558 - 150000, 284 - 150000, 558 + 150000, 284 + 150000, 0, 0, ClickToMove)) {
            ProcessLog("Successfully enabled.")
            break
        }
        FixClick(777, 255)
        Sleep 800
    }
    Sleep 500
    SendInput("{Esc}")
    Sleep 1000
}

GotoEggs() {
    SendInput("{Tab}")

    SendInput("{w down}")
    Sleep 100
    SendInput("{w up}")
    Sleep 200
    SendInput("{a down}")
    Sleep 3600
    SendInput("{a up}")
    Sleep 1000
}

EggMovement() {
    if (StoryDropdown.Text = "Common Egg") {
        ProcessLog("Walking Common Egg route.")
        SendInput ("{d down}")
        Sleep 500
        SendInput ("{d up}")
        Sleep 700
        SendInput ("{s down}")
        Sleep 700
        SendInput ("{s up}")
    }
    if (StoryDropdown.Text = "Spotted Egg") {
        ProcessLog("Walking Spotted Egg route.")
        SendInput ("{s down}")
        Sleep 1000
        SendInput ("{s up}")
    }
    if (StoryDropdown.Text = "Iceshard Egg") {
        ProcessLog("Walking Iceshard Egg route.")
        SendInput ("{s down}")
        Sleep 1000
        SendInput ("{s up}")
        Sleep 600
        SendInput ("{a down}")
        Sleep 670
        SendInput ("{a up}")
    }
    if (StoryDropdown.Text = "Spikey Egg") {
        ProcessLog("Walking Spikey Egg route.")
        SendInput ("{s down}")
        Sleep 1000
        SendInput ("{s up}")
        Sleep 600
        SendInput ("{a down}")
        Sleep 1000
        SendInput ("{a up}")
    }
    if (StoryDropdown.Text = "Magma Egg") {
        ProcessLog("Walking Magma Egg route.")
        SendInput ("{s down}")
        Sleep 1000
        SendInput ("{s up}")
        Sleep 600
        SendInput ("{a down}")
        Sleep 1650
        SendInput ("{a up}")
    }
    if (StoryDropdown.Text = "Crystal Egg") {
        ProcessLog("Walking Crystal Egg route.")
        SendInput ("{s down}")
        Sleep 1000
        SendInput ("{s up}")
        Sleep 600
        SendInput ("{a down}")
        Sleep 1650
        SendInput ("{a up}")
        Sleep 600
        SendInput ("{w down}")
        Sleep 250
        SendInput ("{w up}")
    }
    if (StoryDropdown.Text = "Lunar Egg") {
        ProcessLog("Walking Lunar Egg route.")
        SendInput ("{s down}")
        Sleep 1000
        SendInput ("{s up}")
        Sleep 600
        SendInput ("{a down}")
        Sleep 1650
        SendInput ("{a up}")
        Sleep 600
        SendInput ("{w down}")
        Sleep 800
        SendInput ("{w up}")
    }
    if (StoryDropdown.Text = "Void Egg") {
        ProcessLog("Walking Void Egg route.")
        SendInput ("{s down}")
        Sleep 1000
        SendInput ("{s up}")
        Sleep 600
        SendInput ("{a down}")
        Sleep 1650
        SendInput ("{a up}")
        Sleep 600
        SendInput ("{w down}")
        Sleep 1100
        SendInput ("{w up}")
    }
    if (StoryDropdown.Text = "Hell Egg") {
        ProcessLog("Walking Hell Egg route.")
        SendInput ("{s down}")
        Sleep 1000
        SendInput ("{s up}")
        Sleep 600
        SendInput ("{a down}")
        Sleep 1650
        SendInput ("{a up}")
        Sleep 600
        SendInput ("{w down}")
        Sleep 1400
        SendInput ("{w up}")
    }
    if (StoryDropdown.Text = "Nightmare Egg") {
        ProcessLog("Walking Nightmare Egg route.")
        SendInput ("{s down}")
        Sleep 1000
        SendInput ("{s up}")
        Sleep 600
        SendInput ("{a down}")
        Sleep 1650
        SendInput ("{a up}")
        Sleep 600
        SendInput ("{w down}")
        Sleep 1750
        SendInput ("{w up}")
    }
    if (StoryDropdown.Text = "Rainbow Egg") {
        ProcessLog("Walking Rainbow Egg route.")
        SendInput ("{s down}")
        Sleep 1000
        SendInput ("{s up}")
        Sleep 600
        SendInput ("{a down}")
        Sleep 1650
        SendInput ("{a up}")
        Sleep 600
        SendInput ("{w down}")
        Sleep 2000
        SendInput ("{w up}")
    }
    if (StoryDropdown.Text = "Infinity Egg") {
        ProcessLog("No route needed.")
    }
    if (StoryDropdown.Text = "") {
        ProcessLog("No egg found, rerouting to common egg.")
        ProcessLog("Walking Common Egg route.")
        SendInput ("{d down}")
        Sleep 500
        SendInput ("{d up}")
        Sleep 700
        SendInput ("{s down}")
        Sleep 700
        SendInput ("{s up}")
    }
}

StartHatching() {
    SendInput ("{r}")
    loop {
        FixClick(638, 564)
        Sleep 1500
        FixClick(165, 569)
        Sleep 1500
    }
}

EggHatching() {
    if (ok := FindText(&X, &Y, 142 - 150000, 65 - 150000, 142 + 150000, 65 + 150000, 0, 0, ChatOpenCheck)) {
        FixClick(137, 32)
    }

    global StoryDropdown

    ; Get current map and act
    currentStoryMap := StoryDropdown.Text

    ; Execute the movement pattern
    ProcessLog("Starting..")
    loop {
        ProcessLog("loop")
        ResetCharacter()
        Teleport()
        Zoom()
        Sleep 2000
        GotoEggs()
        Sleep 1500
        if (ok := FindText(&X, &Y, 327 - 150000, 122 - 150000, 327 + 150000, 122 + 150000, 0, 0, InfinityEggPrice)) {
            ProcessLog("break")
            break
        }

        if (ok := FindText(&X, &Y, 329 - 150000, 443 - 150000, 329 + 150000, 443 + 150000, 0, 0, EggsAngle2)) {
            SendInput ("{Right down}")
            Sleep 750
            SendInput ("{Right up}")
            Zoom()
            Teleport()
            GotoEggs()
        }
    }
    ; EnableClickToMove()
    Sleep 1000
    EggMovement()
    StartHatching()

    ; Start stage
    ;while !(ok := FindText(&X, &Y, 325, 520, 489, 587, 0, 0, ModeCancel)) {
    ;   StoryMovement()
    ;}

    ;StartHatching(currentStoryMap)
    ;RestartStage()
}

TeleportTopMap() {
    SendInput("{m}")
    Sleep 2000
    loop 20 {
        FixClick(648, 130)
        Sleep 50
    }

    Sleep 600
    FixClick(400, 560)
    Sleep 1500
}

TeleportVoid() {
    SendInput("{m}")
    Sleep 2500
    loop 20 {
        Send "{WheelUp}"
        Sleep 50
    }
    Sleep 1000
    FixClick(481, 589)
    Sleep 600
    FixClick(400, 560)
    Sleep 1500
}

ClearLeftRight() {
    SendInput("{s down}")
    Sleep 303
    SendInput("{s up}")
    Sleep 246
    SendInput("{d down}")
    Sleep 246
    SendInput("{d up}")
    Sleep 358
    SendInput("{w down}")
    Sleep 581
    SendInput("{w up}")
    Sleep 295
    SendInput("{d down}")
    Sleep 199
    SendInput("{d up}")
    Sleep 486
    SendInput("{s down}")
    Sleep 533
    SendInput("{s up}")
    Sleep 350
    SendInput("{d down}")
    Sleep 172
    SendInput("{d up}")
    Sleep 398
    SendInput("{w down}")
    Sleep 981
    SendInput("{w up}")
    Sleep 1126
    SendInput("{w down}")
    Sleep 229
    SendInput("{w up}")
    Sleep 421
    SendInput("{d down}")
    Sleep 198
    SendInput("{d up}")
    Sleep 356
    SendInput("{s down}")
    Sleep 726
    SendInput("{s up}")
    Sleep 1044
    SendInput("{d down}")
    Sleep 77
    SendInput("{d up}")
    Sleep 478
    SendInput("{w down}")
    Sleep 806
    SendInput("{w up}")
    Sleep 379
    SendInput("{d down}")
    Sleep 190
    SendInput("{d up}")
    Sleep 309
    SendInput("{s down}")
    Sleep 472
    SendInput("{s up}")
    Sleep 797
    SendInput("{d down}")
    Sleep 198
    SendInput("{d up}")
    Sleep 421
    SendInput("{w down}")
    Sleep 502
    SendInput("{w up}")
    Sleep 317
    SendInput("{d down}")
    Sleep 142
    SendInput("{d up}")
    Sleep 416
    SendInput("{s down}")
    Sleep 318
    SendInput("{s up}")
    Sleep 339
    SendInput("{w down}")
    Sleep 493
    SendInput("{w up}")
    SendInput("{d down}")
    Sleep 270
    SendInput("{d up}")
    Sleep 236
    SendInput("{w down}")
    Sleep 222
    SendInput("{w up}")
    Sleep 213
    SendInput("{a down}")
    Sleep 309
    SendInput("{a up}")
    Sleep 277
    SendInput("{a down}")
    Sleep 198
    SendInput("{a up}")
    Sleep 221
    SendInput("{w down}")
    Sleep 446
    SendInput("{w up}")
    SendInput("{d down}")
    Sleep 398
    SendInput("{d up}")
    Sleep 645
    SendInput("{a down}")
    Sleep 725
    SendInput("{a up}")
    Sleep 246
    SendInput("{s down}")
    Sleep 373
    SendInput("{s up}")
    Sleep 254
    SendInput("{a down}")
    Sleep 52
    SendInput("{a up}")
    Sleep 260
    SendInput("{s down}")
    Sleep 108
    SendInput("{a down}")
    Sleep 93
    SendInput("{a up}")
    SendInput("{s up}")
    Sleep 303
    SendInput("{s down}")
    SendInput("{a down}")
    Sleep 61
    SendInput("{a up}")
    SendInput("{s up}")
    Sleep 406
    SendInput("{d down}")
    Sleep 325
    SendInput("{d up}")
    Sleep 381
    SendInput("{s down}")
    Sleep 166
    SendInput("{a down}")
    SendInput("{s up}")
    Sleep 90
    SendInput("{s down}")
    Sleep 157
    SendInput("{s up}")
    SendInput("{s down}")
    Sleep 446
    SendInput("{a up}")
    SendInput("{s up}")
    Sleep 1043
    SendInput("{s down}")
    Sleep 252
    SendInput("{a down}")
    Sleep 53
    SendInput("{s up}")
    Sleep 235
    SendInput("{s down}")
    Sleep 325
    SendInput("{s up}")
    Sleep 140
    SendInput("{a up}")
    Sleep 860
    SendInput("{s down}")
    Sleep 262
    SendInput("{s up}")
    SendInput("{a down}")
    Sleep 1614
    SendInput("{a up}")
    Sleep 462
    SendInput("{w down}")
    Sleep 93
    SendInput("{a down}")
    SendInput("{w up}")
    Sleep 222
    SendInput("{w down}")
    Sleep 125
    SendInput("{w up}")
    Sleep 436
    SendInput("{a up}")
    Sleep 444
    SendInput("{a down}")
    Sleep 277
    SendInput("{a up}")
    Sleep 188
    SendInput("{w down}")
    Sleep 132
    SendInput("{d down}")
    SendInput("{w up}")
    Sleep 398
    SendInput("{w down}")
    SendInput("{d up}")
    Sleep 342
    SendInput("{a down}")
    SendInput("{w up}")
    Sleep 1030
    SendInput("{w down}")
    Sleep 61
    SendInput("{a up}")
    Sleep 164
    SendInput("{d down}")
    SendInput("{w up}")
    Sleep 669
    SendInput("{w down}")
    Sleep 165
    SendInput("{d up}")
    Sleep 188
    SendInput("{a down}")
    Sleep 60
    SendInput("{w up}")
    Sleep 693
    SendInput("{s down}")
    Sleep 173
    SendInput("{a up}")
    SendInput("{d down}")
    SendInput("{s up}")
    Sleep 189
    SendInput("{w down}")
    SendInput("{d up}")
    Sleep 525
    SendInput("{a down}")
    Sleep 316
    SendInput("{a up}")
    Sleep 108
    SendInput("{d down}")
    Sleep 237
    SendInput("{w up}")
    Sleep 427
    SendInput("{s down}")
    SendInput("{d up}")
    Sleep 269
    SendInput("{a down}")
    Sleep 196
    SendInput("{a up}")
    SendInput("{d down}")
    Sleep 107
    SendInput("{s up}")
    Sleep 268
    SendInput("{a down}")
    SendInput("{d up}")
    Sleep 53
    SendInput("{s down}")
    Sleep 82
    SendInput("{a up}")
    Sleep 180
    SendInput("{a down}")
    SendInput("{s up}")
    Sleep 190
    SendInput("{w down}")
    Sleep 99
    SendInput("{a up}")
    Sleep 524
    SendInput("{a down}")
    SendInput("{w up}")
    Sleep 230
    SendInput("{s down}")
    SendInput("{a up}")
    Sleep 382
    SendInput("{d down}")
    Sleep 123
    SendInput("{s up}")
    Sleep 132
    SendInput("{s down}")
    SendInput("{d up}")
    Sleep 574
    SendInput("{d down}")
    Sleep 340
    SendInput("{s up}")
    Sleep 202
    SendInput("{s down}")
    Sleep 226
    SendInput("{d up}")
    Sleep 220
    SendInput("{a down}")
    Sleep 147
    SendInput("{a up}")
    Sleep 59
    SendInput("{d down}")
    Sleep 60
    SendInput("{s up}")
    Sleep 124
    SendInput("{w down}")
    SendInput("{d up}")
    Sleep 61
    SendInput("{d down}")
    Sleep 51
    SendInput("{w up}")
    Sleep 331
    SendInput("{s down}")
    Sleep 219
    SendInput("{s up}")
    Sleep 1276
    SendInput("{d up}")
}

CloseLeaderboard() {
    if (!ok := FindText(&X, &Y, 758 - 150000, 361 - 150000, 758 + 150000, 361 + 150000, 0, 0, LeaderboardEnabledCheck)) {
        SendInput ("{Tab}")
    }
}

setstuff() {
    ResetCharacter()
    TeleportTopMap()
    Zoom()
}

SkipRoll() {
    Sleep 500
    FixClick(399, 354)
    Sleep 1500
}

OpenAllBoxes() {
    FixClick(39, 230)
    Sleep 1500
    ; Open first
    FixClick(199, 227)
    SkipRoll()
    ; Open second
    FixClick(279, 227)
    SkipRoll()
    ; Open third
    FixClick(359, 288)
    SkipRoll()
    ; Open fourth
    FixClick(441, 230)
    SkipRoll()
    ; Open fifth
    FixClick(232, 318)
    SkipRoll()
    ; Open sixth
    FixClick(318, 319)
    SkipRoll()
    ; Open seventh
    FixClick(410, 317)
    SkipRoll()
    ; Open eighth
    FixClick(247, 423)
    SkipRoll()
    ; Open ninth
    FixClick(393, 417)
    SkipRoll()

    Sleep 1500
    FixClick(634, 134)

    ClaimBoxesAvailable := false
    ProcessLog("All boxes claimed. Resetting cooldown.")
    SetTimer(ResetClaimTimer, -7500000)
}

ResetClaimTimer() {
    global ClaimBoxesAvailable
    ClaimBoxesAvailable := true
    ProcessLog("Time rewards available again!")
}

stuff() {
   
}

SendCoinsWebhook() {
    global WebhookURL

    WebhookURL := FileRead(WebhookURLFile, "UTF-8")
    if !(WebhookURL ~= 'i)https?:\/\/discord\.com\/api\/webhooks\/(\d{18,19})\/[\w-]{68}') {
        return
    }

    static webhook := WebHookBuilder(
        WebhookURL
    )
    captureRect := "7|390|195|65"  ; Left|Top|Width|Height

    pToken := Gdip_Startup()
    pBitmap := Gdip_BitmapFromScreen(captureRect)

    embed := EmbedBuilder()
    .setTitle("Current Coins")
    .setImage(AttachmentBuilder(pBitmap))

    webhook.send({
        embeds: [embed],
        files: [AttachmentBuilder(pBitmap)]
    })

    Gdip_DisposeImage(pBitmap)
    Gdip_Shutdown(pToken)
}

ClaimChests() {
    global ClaimAvailable, ChestCooldown
    if (AutoAbilityBox.Value) {
        ProcessLog("Claiming chests...")

        ; Claiming sequence
        SendInput("{m}")
        Sleep 2000
        loop 4 {
            FixClick(649, 468)
            Sleep 1000
        }

        ProcessLog("Island Reached")
        FixClick(400, 555)
        Sleep 2500
        Send("{s down}")
        Sleep 991
        Send("{s up}")
        Sleep 1000
        FixClick(463, 230)
        Sleep 1000
        Send("{w down}")
        Sleep 1118
        Send("{w up}")
        Sleep 200
        Send("{d down}")
        Sleep 774
        Send("{d up}")
        Sleep 200
        Send("{s down}")
        Sleep 791
        Send("{s up}")
        SLeep 1500

        Send("{e down}")
        Sleep 70
        Send("{e up}")

        SendCoinsWebhook()

        ; Set cooldown
        global ClaimAvailable := false
        ProcessLog("Chest claimed. Cooldown started.")

        ; Set timer to reset availability
        SetTimer(ResetChestAvailability, -ChestCooldown)
    }
}

ClaimChests2() {
    if (AutoAbilityBox.Value) {
        ProcessLog("Claiming chests...")

        ; Claiming sequence
        SendInput("{m}")
        Sleep 2000
        loop 20 {
            FixClick(648, 130)
            Sleep 50
        }
        Sleep 2000
        FixClick(311, 462)
        Sleep 1500
        FixClick(400, 555)
        Sleep 2500

        Send("{w down}")
        Sleep 304
        Send("{w up}")
        Sleep 200
        Send("{d down}")
        Sleep 303
        Send("{d up}")
        Sleep 200
        Send("{w down}")
        Sleep 390
        Send("{w up}")
        Sleep 200
        Send("{d down}")
        Sleep 302
        Send("{d up}")
        Sleep 200
        Send("{w down}")
        Sleep 319
        Send("{w up}")
        Sleep 200
        Send("{d down}")
        Sleep 235
        Send("{d up}")
        Sleep 200
        Send("{w down}")
        Sleep 309
        Send("{w up}")
        Sleep 200
        Send("{d down}")
        Sleep 173
        Send("{d up}")
        Sleep 200
        Send("{w down}")
        Sleep 270
        Send("{w up}")
        Sleep 200
        Send("{d down}")
        Sleep 198
        Send("{d up}")
        Sleep 200
        Send("{w down}")
        Sleep 270
        Send("{w up}")
        Sleep 200
        Send("{d down}")
        Sleep 190
        Send("{d up}")
        Sleep 200
        Send("{w down}")
        Sleep 341
        Send("{w up}")
        Sleep 200
        Send("{d down}")
        Sleep 197
        Send("{d up}")
        Sleep 200
        Send("{w down}")
        Sleep 318
        Send("{w up}")
        Sleep 200
        Send("{d down}")
        Sleep 205
        Send("{d up}")
        Sleep 200
        Send("{w down}")
        Sleep 357
        Send("{w up}")
        Sleep 200
        Send("{d down}")
        Sleep 278
        Send("{d up}")
        Sleep 200
        Send("{w down}")
        Sleep 348
        Send("{w up}")
        Sleep 200
        Send("{e down}")
        Sleep 77
        Send("{e up}")
        Sleep 200
        Send("{e down}")
        Sleep 94
        Send("{e up}")
        Sleep 200
        Send("{e down}")
        Sleep 70
        Send("{e up}")

        ; vip chest

        if (VIPChestBox.Value) {
            SendInput("{m}")
            Sleep 2000
            loop 20 {
                FixClick(649, 469)
                Sleep 10
            }
            Sleep 2000
            FixClick(400, 556)
            Sleep 2000

            Send("{w down}")
            Sleep 551
            Send("{w up}")
            Sleep 200
            Send("{d down}")
            Sleep 4135
            Send("{d up}")
            Sleep 200
            Send("{s down}")
            Sleep 158
            Send("{s up}")
            Sleep 200
            Send("{d down}")
            Sleep 1093
            Send("{d up}")
            Sleep 200
            Send("{s down}")
            Sleep 230
            Send("{s up}")
            Sleep 200
            Send("{d down}")
            Sleep 662
            Send("{d up}")
            Sleep 200
            Send("{e down}")
            Send("{e up}")
        }

        ; Set cooldown
        global Claim2Available := false
        ProcessLog("Chest 2 claimed. Cooldown started.")

        ; Set timer to reset availability
        SetTimer(ResetChest2Availability, -Chest2Cooldown)
    }
}

ResetChestAvailability() {
    global ClaimAvailable
    ClaimAvailable := true
    ProcessLog("Chest available again!")
}

ResetChest2Availability() {
    global Claim2Available
    Claim2Available := true
    ProcessLog("Chest 2 available again!")
}

global ClaimAvailable := true
global ChestCooldown := 1200000 ; 20 minutes

global Claim2Available := true
global Chest2Cooldown := 2400000 ; 40 minutes

global ClaimBoxesAvailable := false
SetTimer(TurnOnAvailability, -7500000)

TurnOnAvailability() {
    global ClaimBoxesAvailable := true
}

ClearLeftRight2() {
    Send("{s down}")
    Sleep 279
    Send("{s up}")
    Sleep 200

    Send("{d down}")
    Sleep 286
    Send("{d up}")
    Sleep 200

    Send("{w down}")
    Sleep 646
    Send("{w up}")
    Sleep 200

    Send("{d down}")
    Sleep 262
    Send("{d up}")
    Sleep 200

    Send("{w down}")
    Sleep 445
    Send("{w up}")
    Sleep 200

    Send("{d down}")
    Sleep 278
    Send("{d up}")
    Sleep 200

    Send("{s down}")
    Sleep 574
    Send("{s up}")
    Sleep 200

    Send("{w down}")
    Sleep 222
    Send("{w up}")
    Sleep 200

    Send("{d down}")
    Sleep 366
    Send("{d up}")
    Sleep 200

    Send("{w down}")
    Sleep 582
    Send("{w up}")
    Sleep 200

    Send("{a down}")
    Sleep 358
    Send("{a up}")
    Sleep 200

    Send("{d down}")
    Sleep 558
    Send("{d up}")
    Sleep 200

    Send("{w down}")
    Sleep 158
    Send("{w up}")
    Sleep 200

    Send("{d down}")
    Sleep 237
    Send("{d up}")
    Sleep 200

    Send("{w down}")
    Sleep 222
    Send("{w up}")
    Sleep 200

    Send("{a down}")
    Sleep 870
    Send("{a up}")
    Sleep 200

    Send("{s down}")
    Sleep 152
    Send("{s up}")
    Sleep 200

    Send("{w down}")
    Sleep 317
    Send("{w up}")
    Sleep 200

    Send("{d down}")
    Sleep 253
    Send("{d up}")
    Sleep 200

    Send("{w down}")
    Sleep 427
    Send("{w up}")
    Sleep 200

    Send("{d down}")
    Sleep 407
    Send("{d up}")
    Sleep 200

    Send("{s down}")
    Sleep 117
    Send("{s up}")
    Sleep 200

    Send("{d down}")
    Sleep 119
    Send("{d up}")
    Sleep 200

    Send("{s down}")
    Sleep 117
    Send("{s up}")
    Sleep 200

    Send("{d down}")
    Sleep 141
    Send("{d up}")
    Sleep 200

    Send("{s down}")
    Sleep 509
    Send("{s up}")
    Sleep 200

    Send("{a down}")
    Sleep 765
    Send("{a up}")
    Sleep 200

    Send("{s down}")
    Sleep 799
    Send("{s up}")
    Sleep 200

    Send("{a down}")
    Sleep 454
    Send("{a up}")
    Sleep 200

    Send("{s down}")
    Sleep 493
    Send("{s up}")
    Sleep 200

    Send("{a down}")
    Sleep 2765
    Send("{a up}")
    Sleep 200

    Send("{a down}")
    Sleep 332
    Send("{a up}")
    Sleep 200

    Send("{w down}")
    Sleep 973
    Send("{w up}")
    Sleep 200

    Send("{a down}")
    Sleep 182
    Send("{a up}")
    Sleep 200

    Send("{s down}")
    Sleep 574
    Send("{s up}")
    Sleep 200

    Send("{w down}")
    Sleep 270
    Send("{w up}")
    Sleep 200

    Send("{a down}")
    Sleep 629
    Send("{a up}")
    Sleep 200

    Send("{w down}")
    Sleep 692
    Send("{w up}")
    Sleep 200

    Send("{a down}")
    Sleep 173
    Send("{a up}")
    Sleep 200

    Send("{d down}")
    Sleep 965
    Send("{d up}")
    Sleep 200

    Send("{s down}")
    Sleep 340
    Send("{s up}")
    Sleep 200

    Send("{d down}")
    Sleep 165
    Send("{d up}")
    Sleep 200

    Send("{s down}")
    Sleep 188
    Send("{s up}")
    Sleep 200

    Send("{a down}")
    Sleep 789
    Send("{a up}")
    Sleep 200

    Send("{w down}")
    Sleep 196
    Send("{w up}")
    Sleep 200

    Send("{d down}")
    Sleep 605
    Send("{d up}")
    Sleep 200

    Send("{w down}")
    Sleep 244
    Send("{w up}")
    Sleep 200

    Send("{a down}")
    Sleep 604
    Send("{a up}")
    Sleep 200

    Send("{w down}")
    Sleep 348
    Send("{w up}")
    Sleep 200

    Send("{a down}")
    Sleep 237
    Send("{a up}")
    Sleep 200

    Send("{w down}")
    Sleep 396
    Send("{w up}")
    Sleep 200

    Send("{d down}")
    Sleep 209
    Send("{d up}")
    Sleep 200

    Send("{w down}")
    Sleep 140
    Send("{w up}")
    Sleep 200

    Send("{d down}")
    Sleep 380
    Send("{d up}")
    Sleep 200

    Send("{s down}")
    Sleep 483
    Send("{s up}")
    Sleep 200

    Send("{d down}")
    Sleep 173
    Send("{d up}")
    Sleep 200

    Send("{s down}")
    Sleep 553
    Send("{s up}")
    Sleep 200

    Send("{a down}")
    Sleep 132
    Send("{a up}")
    Sleep 200

    Send("{s down}")
    Sleep 412
    Send("{s up}")
    Sleep 200

    Send("{d down}")
    Sleep 245
    Send("{d up}")
}

LegendMode() {
    global LegendDropdown

    ; Get current map and act

    ProcessLog("Starting to farm " . LegendDropdown.Text)

    if (LegendDropdown.Text = "Coins, Gems") {
        ResetCharacter()
        Zoom()

        TeleportTopMap()

        Sleep 600
        CloseLeaderboard()
        Sleep 3500

        if (!ok := FindText(&X, &Y, 468 - 150000, 465 - 150000, 468 + 150000, 465 + 150000, 0, 0, NormalCoinsAngle)) {
            SendInput ("{Right down}")
            Sleep 750
            SendInput ("{Right up}")

            loop {
                ClearLeftRight2()
                Sleep 1500
                if (ClaimAvailable) {
                    ClaimChests()
                }
                if (Claim2Available) {
                    ClaimChests2()
                }
                if (ClaimBoxesAvailable) {
                    OpenAllBoxes()
                }
                TeleportTopMap()
            }
        }

        loop {
            ClearLeftRight()
            Sleep 1500
            if (ClaimAvailable) {
                ClaimChests()
            }
            if (Claim2Available) {
                ClaimChests2()
            }
            if (ClaimBoxesAvailable) {
                OpenAllBoxes()
            }
            TeleportTopMap()
        }
    }

    if (LegendDropdown.Text = "Bubbles") {
        TeleportVoid()
        Sleep 1500
        Zoom()
        Sleep 1500
        SendInput ("{d down}")
        Sleep 200
        SendInput ("{d up}")
        Sleep 200
        SendInput ("{s down}")
        Sleep 750
        SendInput ("{s up}")

        loop {
            FixClick(400, 250)
            Sleep 450
        }
    }

    if (LegendDropdown.Text = "Eggs") {
        ResetCharacter()
        Teleport()
        Zoom()
        Sleep 2000
        GotoEggs()
        Sleep 1000
        SendInput ("{d down}")
        Sleep 500
        SendInput ("{d up}")
        Sleep 700
        SendInput ("{s down}")
        Sleep 900
        SendInput ("{s up}")
        Sleep 1000
        FixClick(358, 191)
        Sleep 150
        FixClick(416, 193)
        Sleep 150
        FixClick(463, 188)
        Sleep 150
        FixClick(357, 255)
        Sleep 1000

        StartHatching()
    }
}

EnchantMode() {
    global EnchantsDropdown, EnchantModeDropdown

    loop {
        if (EnchantModeDropdown.Text) = "Gems" {
            FixClick(178, 504)
        } else {
            FixClick(230, 431)
        }

        Sleep 150
        if (EnchantsDropdown.Text) = "Teamup IV" {
            if (ok := FindText(&X, &Y, 94, 353, 264, 514, 0, 0, TeamupIV)) {
                ProcessLog("Found " . EnchantsDropdown.Text)
                break
            }
        }
        if (EnchantsDropdown.Text) = "Team up V" {
            if (ok := FindText(&X, &Y, 94, 353, 264, 514, 0, 0, TeamupV)) {
                ProcessLog("Found " . EnchantsDropdown.Text)
                break
            }

            if (EnchantTierBox.Value) {
                if (ok := FindText(&X, &Y, 94, 353, 264, 514, 0, 0, TeamupIV)) {
                    ProcessLog("Stopping at Teamup IV, due to being 1 tier lower")
                    break
                }
            }
        }
        if (EnchantsDropdown.Text) = "Looter IV" {
            if (ok := FindText(&X, &Y, 94, 353, 264, 514, 0, 0, LooterIV)) {
                ProcessLog("Found " . EnchantsDropdown.Text)
                break
            }
        }
        if (EnchantsDropdown.Text) = "Looter V" {
            if (ok := FindText(&X, &Y, 94, 353, 264, 514, 0, 0, LooterV)) {
                ProcessLog("Found " . EnchantsDropdown.Text)
                break
            }

            if (EnchantTierBox.Value) {
                if (ok := FindText(&X, &Y, 94, 353, 264, 514, 0, 0, LooterIV)) {
                    ProcessLog("Stopping at Looter IV, due to being 1 tier lower")
                    break
                }
            }
        }
        if (EnchantsDropdown.Text) = "Bubbler IV" {
            if (ok := FindText(&X, &Y, 94, 353, 264, 514, 0, 0, BubblerIV)) {
                ProcessLog("Found " . EnchantsDropdown.Text)
                break
            }
        }
        if (EnchantsDropdown.Text) = "Bubbler V" {
            if (ok := FindText(&X, &Y, 94, 353, 264, 514, 0, 0, BubblerV)) {
                ProcessLog("Found " . EnchantsDropdown.Text)
                break
            }

            if (EnchantTierBox.Value) {
                if (ok := FindText(&X, &Y, 94, 353, 264, 514, 0, 0, BubblerIV)) {
                    ProcessLog("Stopping at Bubbler IV, due to being 1 tier lower")
                    break
                }
            }
        }
        if (EnchantsDropdown.Text) = "Gleaming III" {
            if (ok := FindText(&X, &Y, 94, 353, 264, 514, 0, 0, GleamingIII)) {
                ProcessLog("Found " . EnchantsDropdown.Text)
                break
            }
        }
    }
}

RaidMode() {
    global RaidDropdown, RaidActDropdown

    ; Get current map and act
    currentRaidMap := RaidDropdown.Text
    currentRaidAct := RaidActDropdown.Text

    ; Execute the movement pattern
    ProcessLog("Moving to position for " currentRaidMap)
    RaidMovement()

    ; Start stage
    while !(ok := FindText(&X, &Y, 325, 520, 489, 587, 0, 0, ModeCancel)) {
        RaidMovement()
    }
    ProcessLog("Starting " currentRaidMap " - " currentRaidAct)
    StartRaid(currentRaidMap, currentRaidAct)
    ; Handle play mode selection
    if (MatchMaking.Value) {
        FindMatch()
    } else {
        PlayHere()
    }

    RestartStage()
}

InfinityCastleMode() {
    global InfinityCastleDropdown

    ; Get current difficulty
    currentDifficulty := InfinityCastleDropdown.Text

    ; Execute the movement pattern
    ProcessLog("Moving to position for Infinity Castle")
    InfCastleMovement()

    ; Start stage
    while !(ok := FindText(&X, &Y, 325, 520, 489, 587, 0, 0, ModeCancel)) {
        InfCastleMovement()
    }
    ProcessLog("Starting Infinity Castle - " currentDifficulty)

    ; Select difficulty with direct clicks
    if (currentDifficulty = "Normal") {
        FixClick(418, 375)  ; Click Easy Mode
    } else {
        FixClick(485, 375)  ; Click Hard Mode
    }

    ;Start Inf Castle
    if (ok := FindText(&X, &Y, 325, 520, 489, 587, 0, 0, ModeCancel)) {
        ClickUntilGone(0, 0, 325, 520, 489, 587, ModeCancel, -10, -120)
    }

    RestartStage()
}

ContractMode() {
    Sleep(10000)
    if (ContractJoinDropdown.Text = "Creating") {
        FixClick(35, 400)  ; Click contracts
        Sleep(1000)
        HandleContractJoin()
    } else if (ContractJoinDropdown.Text = "Matchmaking") {
        FixClick(35, 400)  ; Click contracts
        Sleep(1000)
        HandleContractJoin()
    } else {
        ProcessLog("Join the contract portal manually")
    }
    Sleep(2500)
    RestartStage()
}

DungeonMode() {
    ProcessLog("Entering Dungeon Mode")
    FixClick(85, 400)  ; Click Dungeon mode button
    Sleep(1000)
    if (ok := FindText(&X, &Y, 310, 395, 495, 440, 0.20, 0.20, EnterDungeon) or (ok := FindText(&X, &Y, 370, 225, 545,
        300, 0.20, 0.20, DungeonDeath))) {
        FixClick(395, 380)
    }
    Sleep(1000)
    if (ok := FindText(&X, &Y, 310, 395, 495, 440, 0.20, 0.20, EnterDungeon) or (ok := FindText(&X, &Y, 370, 225, 545,
        300, 0.20, 0.20, DungeonDeath))) {
        FixClick(395, 380)
    }
    Sleep(1000)

    ; Check for Specials if we reconnected
    CheckDungeonSpecials()

    ; Select dungeon route and enter
    SelectDungeonRoute()
}

ClickReplay() {
    ClickUntilGone(0, 0, 80, 85, 739, 224, LobbyText, +120, -35, LobbyText2)
}

ClickNextLevel() {
    ClickUntilGone(0, 0, 80, 85, 739, 224, LobbyText, +260, -35, LobbyText2)
}

ClickReturnToLobby() {
    ClickUntilGone(0, 0, 80, 85, 739, 224, LobbyText, 0, -35, LobbyText2)
}

MonitorEndScreen() {
    global mode, StoryDropdown, ReturnLobbyBox, MatchMaking

    loop {
        Sleep(3000)

        FixClick(560, 560)

        if (ok := FindText(&X, &Y, 300, 190, 360, 250, 0, 0, UnitExit)) {
            ClickUntilGone(0, 0, 300, 190, 360, 250, UnitExit, -4, -35)
        }

        if (ok := FindText(&X, &Y, 260, 400, 390, 450, 0, 0, NextText)) {
            ClickUntilGone(0, 0, 260, 400, 390, 450, NextText, 0, -40)
        }

        ; Now handle each mode
        if (ok := FindText(&X, &Y, 80, 85, 739, 224, 0, 0, LobbyText) or (ok := FindText(&X, &Y, 80, 85, 739, 224, 0, 0,
            LobbyText2))) {
            ProcessLog("Found Lobby Text - Current Mode: " mode)
            if (mode = "Story") {
                ProcessLog("Handling Story mode end")
                return RestartStage()
            }
            else if (mode = "Raid") {
                ProcessLog("Handling Raid end")
                if (ReturnLobbyBox.Value) {
                    ProcessLog("Return to lobby")
                    ClickReturnToLobby()
                    return CheckLobby()
                } else {
                    ProcessLog("Replay raid")
                    ClickReplay()
                    return RestartStage()
                }
            }
            else if (mode = "Infinity Castle") {
                ProcessLog("Handling Infinity Castle end")
                if (lastResult = "win") {
                    ProcessLog("Next floor")
                    ClickReplay()
                } else {
                    ProcessLog("Restart floor")
                    ClickReplay()
                }
                return RestartStage()
            }
            else {
                ProcessLog("Handling end case")
                if (ReturnLobbyBox.Value) {
                    ProcessLog("Return to lobby enabled")
                    ClickReturnToLobby()
                    return CheckLobby()
                } else {
                    ProcessLog("Replaying")
                    ClickReplay()
                    return RestartStage()
                }
            }
        }

        Reconnect()
    }
}

MonitorStage() {
    global Wins, loss, mode

    lastClickTime := A_TickCount

    loop {
        Sleep(1000)

        if (mode = "Story") {
            timeElapsed := A_TickCount - lastClickTime
            if (timeElapsed >= 300000) {  ; 5 minutes
                ProcessLog("Performing anti-AFK click")
                FixClick(560, 560)  ; Move click
                lastClickTime := A_TickCount
            }
        }

        ; Check for XP screen
        if CheckForXp() {
            ProcessLog("Checking win/loss status")

            ; Calculate stage end time here, before checking win/loss
            stageEndTime := A_TickCount
            stageLength := FormatStageTime(stageEndTime - stageStartTime)

            if (ok := FindText(&X, &Y, 300, 190, 360, 250, 0, 0, UnitExit)) {
                ClickUntilGone(0, 0, 300, 190, 360, 250, UnitExit, -4, -35)
            }

            ; Check for Victory or Defeat
            if (ok := FindText(&X, &Y, 150, 180, 350, 260, 0, 0, VictoryText) or (ok := FindText(&X, &Y, 150, 180, 350,
                260, 0, 0, VictoryText2))) {
                ProcessLog("Victory detected - Stage Length: " stageLength)
                Wins += 1
                SendWebhookWithTime(true, stageLength)
                if (mode = "Contract") {
                    return HandleContractEnd()  ; New function for Contract endings
                } else if (mode = "Dungeon") {
                    return MonitorDungeonEnd()  ; New function for Dungeon endings
                } else {
                    return MonitorEndScreen()  ; Original behavior for other modes
                }
            }
            else if (ok := FindText(&X, &Y, 150, 180, 350, 260, 0, 0, DefeatText) or (ok := FindText(&X, &Y, 150, 180,
                350, 260, 0, 0, DefeatText2))) {
                ProcessLog("Defeat detected - Stage Length: " stageLength)
                loss += 1
                SendWebhookWithTime(false, stageLength)
                if (mode = "Contract") {
                    return HandleContractEnd()  ; New function for Contract endings
                } else if (mode = "Dungeon") {
                    return MonitorDungeonEnd()  ; New function for Dungeon endings
                } else {
                    return MonitorEndScreen()  ; Original behavior for other modes
                }
            }
        }
        Reconnect()
    }
}

StoryMovement() {
    FixClick(85, 295)
    sleep (1000)
    SendInput ("{w down}")
    Sleep(300)
    SendInput ("{w up}")
    Sleep(300)
    SendInput ("{d down}")
    SendInput ("{w down}")
    Sleep(4500)
    SendInput ("{d up}")
    SendInput ("{w up}")
    Sleep(500)
}

RaidMovement() {
    FixClick(765, 475) ; Click Area
    Sleep(300)
    FixClick(495, 410)
    Sleep(500)
    SendInput ("{a down}")
    Sleep(400)
    SendInput ("{a up}")
    Sleep(500)
    SendInput ("{w down}")
    Sleep(5000)
    SendInput ("{w up}")
}

InfCastleMovement() {
    FixClick(765, 475)
    Sleep (300)
    FixClick(370, 330)
    Sleep (500)
    SendInput ("{w down}")
    Sleep (500)
    SendInput ("{w up}")
    Sleep (500)
    SendInput ("{a down}")
    sleep (4000)
    SendInput ("{a up}")
    Sleep (500)
}

StartStory(map) {
    FixClick(640, 70) ; Closes Player leaderboard
    Sleep(500)
    navKeys := GetNavKeys()
    for key in navKeys {
        SendInput("{" key "}")
    }
    Sleep(500)

    downArrows := GetStoryDownArrows(map) ; Map selection down arrows
    loop downArrows {
        SendInput("{Down}")
        Sleep(200)
    }

    SendInput("{Enter}") ; Select storymode
    Sleep(500)

    loop 4 {
        SendInput("{Up}") ; Makes sure it selects act
        Sleep(200)
    }

    SendInput("{Left}") ; Go to act selection
    Sleep(1000)

    SendInput("{Enter}") ; Select Act
    Sleep(500)
    for key in navKeys {
        SendInput("{" key "}")
    }
}

StartLegend(map, LegendActDropdown) {

    FixClick(640, 70) ; Closes Player leaderboard
    Sleep(500)
    navKeys := GetNavKeys()
    for key in navKeys {
        SendInput("{" key "}")
    }
    Sleep(500)
    SendInput("{Down}")
    Sleep(500)
    SendInput("{Enter}") ; Opens Legend Stage

    downArrows := GetLegendDownArrows(map) ; Map selection down arrows
    loop downArrows {
        SendInput("{Down}")
        Sleep(200)
    }

    SendInput("{Enter}") ; Select LegendStage
    Sleep(500)

    loop 4 {
        SendInput("{Up}") ; Makes sure it selects act
        Sleep(200)
    }

    SendInput("{Left}") ; Go to act selection
    Sleep(1000)

    actArrows := GetLegendActDownArrows(LegendActDropdown) ; Act selection down arrows
    loop actArrows {
        SendInput("{Down}")
        Sleep(200)
    }

    SendInput("{Enter}") ; Select Act
    Sleep(500)
    for key in navKeys {
        SendInput("{" key "}")
    }
}

StartRaid(map, RaidActDropdown) {
    FixClick(640, 70) ; Closes Player leaderboard
    Sleep(500)
    navKeys := GetNavKeys()
    for key in navKeys {
        SendInput("{" key "}")
    }
    Sleep(500)

    downArrows := GetRaidDownArrows(map) ; Map selection down arrows
    loop downArrows {
        SendInput("{Down}")
        Sleep(200)
    }

    SendInput("{Enter}") ; Select Raid

    loop 4 {
        SendInput("{Up}") ; Makes sure it selects act
        Sleep(200)
    }

    SendInput("{Left}") ; Go to act selection
    Sleep(500)

    actArrows := GetRaidActDownArrows(RaidActDropdown) ; Act selection down arrows
    loop actArrows {
        SendInput("{Down}")
        Sleep(200)
    }

    SendInput("{Enter}") ; Select Act
    Sleep(300)
    for key in navKeys {
        SendInput("{" key "}")
    }
}

PlayHere() {
    FixClick(400, 435)  ; Play Here or Find Match
    Sleep (300)
    FixClick(330, 325) ;Click Play here
    Sleep (300)
    FixClick(400, 465) ;
    Sleep (300)
}

FindMatch() {
    startTime := A_TickCount

    loop {
        if (A_TickCount - startTime > 50000) {
            ProcessLog("Matchmaking timeout, restarting mode")
            FixClick(400, 520)
            return StartSelectedMode()
        }

        FixClick(400, 435)  ; Play Here or Find Match
        Sleep(300)
        FixClick(460, 330)  ; Click Find Match
        Sleep(300)

        ; Try captcha
        if (!CaptchaDetect(252, 292, 300, 50, 400, 335)) {
            ProcessLog("Captcha not detected, retrying...")
            FixClick(585, 190)  ; Click close
            Sleep(1000)
            continue
        }
        FixClick(300, 385)  ; Enter captcha
        return true
    }
}

GetStoryDownArrows(map) {
    switch map {
        case "Planet Greenie": return 2
        case "Walled City": return 3
        case "Snowy Town": return 4
        case "Sand Village": return 5
        case "Navy Bay": return 6
        case "Fiend City": return 7
        case "Spirit World": return 8
        case "Ant Kingdom": return 9
        case "Magic Town": return 10
        case "Haunted Academy": return 11
        case "Magic Hills": return 12
        case "Space Center": return 13
        case "Alien Spaceship": return 14
        case "Fabled Kingdom": return 15
        case "Ruined City": return 16
        case "Puppet Island": return 17
        case "Virtual Dungeon": return 18
        case "Snowy Kingdom": return 19
        case "Dungeon Throne": return 20
        case "Mountain Temple": return 21
        case "Rain Village": return 22
        case "Shibuya District": return 23
    }
}

GetLegendDownArrows(map) {
    switch map {
        case "Magic Hills": return 1
        case "Space Center": return 3
        case "Fabled Kingdom": return 4
        case "Virtual Dungeon": return 6
        case "Dungeon Throne": return 7
        case "Rain Village": return 8
    }
}

GetLegendActDownArrows(LegendActDropdown) {
    switch LegendActDropdown {
        case "Act 1": return 1
        case "Act 2": return 2
        case "Act 3": return 3
    }
}

GetRaidDownArrows(map) {
    switch map {
        case "Sacred Planet": return 2
        case "Strange Town": return 3
        case "Ruined City": return 4
    }
}

GetRaidActDownArrows(RaidActDropdown) {
    switch RaidActDropdown {
        case "Act 1": return 1
        case "Act 2": return 2
        case "Act 3": return 3
        case "Act 4": return 4
        case "Act 5": return 5
    }
}

Zoom() {
    MouseMove(400, 300)
    Sleep 100

    ; Zoom in smoothly
    loop 50 {
        Send "{WheelUp}"
        Sleep 50
    }

    ; Look down
    Click
    MouseMove(400, 400)  ; Move mouse down to angle camera down

    ; Zoom back out smoothly
    loop 14 {
        Send "{WheelDown}"
        Sleep 50
    }

    ; Move mouse back to center
    MouseMove(400, 300)
}

TpSpawn() {
    FixClick(26, 570) ;click settings
    Sleep 300
    FixClick(400, 215)
    Sleep 300
    loop 4 {
        Sleep 150
        SendInput("{WheelDown 1}") ;scroll
    }
    Sleep 300
    if (ok := FindText(&X, &Y, 215, 160, 596, 480, 0, 0, Spawn)) {
        ProcessLog("Found Teleport to Spawn button")
        FixClick(X + 100, Y - 30)
    } else {
        ProcessLog("Could not find Teleport button")
    }
    Sleep 300
    FixClick(583, 147)
    Sleep 300
}

CloseChat() {
    if (ok := FindText(&X, &Y, 123, 50, 156, 79, 0, 0, OpenChat)) {
        ProcessLog "Closing Chat"
        FixClick(138, 30) ;close chat
    }
}

BasicSetup() {
    SendInput("{Tab}") ; Closes Player leaderboard
    Sleep 300
    FixClick(564, 72) ; Closes Player leaderboard
    Sleep 300
    CloseChat()
    Sleep 300
    Zoom()
    Sleep 300
    TpSpawn()
}

DetectMap() {
    ProcessLog("Determining Movement Necessity on Map...")
    startTime := A_TickCount

    loop {
        ; Check if we waited more than 5 minute for votestart
        if (A_TickCount - startTime > 300000) {
            if (ok := FindText(&X, &Y, 746, 514, 789, 530, 0, 0, AreaText)) {
                ProcessLog("Found in lobby - restarting selected mode")
                return StartSelectedMode()
            }
            ProcessLog("Could not detect map after 5 minutes - proceeding without movement")
            return "no map found"
        }

        ; Check for vote screen
        if (ok := FindText(&X, &Y, 326, 60, 547, 173, 0, 0, VoteStart) or (ok := FindText(&X, &Y, 340, 537, 468, 557, 0,
            0, Yen))) {
            ProcessLog("No Map Found or Movement Unnecessary")
            return "no map found"
        }

        mapPatterns := Map(
            "Planet Greenie", Greenie,
            "Ant Kingdom", Ant,
            "Magic Town", MagicTown,
            "Magic Hill", MagicHills,
            "Navy Bay", Navy,
            "Snowy Town", SnowyTown,
            "Fiend City", Fiend,
            "Space Center", SpaceCenter,
            "Mountain Temple", Mount,
            "Cursed Festival", Cursed,
            "Nightmare Train", Nightmare,
            "Air Craft", AirCraft,
            "Hellish City", Hellish,
            "Shibuya District", Shibuya
        )

        for mapName, pattern in mapPatterns {
            if (ok := FindText(&X, &Y, 10, 90, 415, 160, 0, 0, pattern)) {
                ProcessLog("Detected map: " mapName)
                return mapName
            }
        }

        Sleep 1000
        Reconnect()
    }
}

HandleMapMovement(MapName) {
    ProcessLog("Executing Movement for: " MapName)

    switch MapName {
        case "Planet Greenie":
            MoveForGreenie()
        case "Snowy Town":
            MoveForSnowyTown()
        case "Ant Kingdom":
            MoveForAntKingdom()
        case "Magic Town":
            MoveForMagicTown()
        case "Magic Hill":
            MoveForMagicHill()
        case "Navy Bay":
            MoveForNavyBay()
        case "Fiend City":
            MoveForFiendCity()
        case "Space Center":
            MoveForSpaceCenter()
        case "Mountain Temple":
            MoveForMountainTemple()
        case "Cursed Festival":
            MoveForCursedFestival()
        case "Nightmare Train":
            MoveForNightmareTrain()
        case "Air Craft":
            MoveForAirCraft()
        case "Hellish City":
            MoveForHellish()
        case "Shibuya District":
            MoveForShibuya()
    }
}

MoveForGreenie() {
    SendInput ("{a down}")
    SendInput ("{w down}")
    Sleep (2200)
    SendInput ("{a up}")
    SendInput ("{w up}")
}

MoveForSnowyTown() {
    Fixclick(700, 125, "Right")
    Sleep (7000)
}

MoveForNavyBay() {
    SendInput ("{a down}")
    SendInput ("{w down}")
    Sleep (1700)
    SendInput ("{a up}")
    SendInput ("{w up}")
}

MoveForFiendCity() {
    Fixclick(185, 410, "Right")
    Sleep (3000)
    SendInput ("{a down}")
    Sleep (3000)
    SendInput ("{a up}")
    Sleep (500)
    SendInput ("{s down}")
    Sleep (2000)
    SendInput ("{s up}")
}

MoveForSpiritWorld() {
    SendInput ("{d down}")
    SendInput ("{w down}")
    Sleep(7000)
    SendInput ("{d up}")
    SendInput ("{w up}")
    sleep(500)
    Fixclick(400, 15, "Right")
    sleep(4000)
}

MoveForAntKingdom() {
    Fixclick(130, 550, "Right")
    Sleep (3000)
    Fixclick(130, 550, "Right")
    Sleep (4000)
    Fixclick(30, 450, "Right")
    Sleep (3000)
    Fixclick(120, 100, "Right")
    sleep (3000)
}

MoveForMagicTown() {
    Fixclick(700, 315, "Right")
    Sleep (2500)
    Fixclick(565, 325, "Right")
    Sleep (2500)
}

MoveForMagicHill() {
    if (ok := FindText(&X, &Y, 640, 470, 695, 525, 0.15, 0.15, MagicHillAngle)) {
        Fixclick(45, 185, "Right")
        Sleep (3000)
        Fixclick(140, 250, "Right")
        Sleep (2500)
        Fixclick(25, 485, "Right")
        Sleep (3000)
        Fixclick(110, 455, "Right")
        Sleep (3000)
        Fixclick(40, 340, "Right")
        Sleep (3000)
        Fixclick(250, 80, "Right")
        Sleep (3000)
        Fixclick(230, 110, "Right")
        Sleep (3000)
    } else {
        Fixclick(500, 20, "Right")
        Sleep (3000)
        Fixclick(500, 20, "Right")
        Sleep (3500)
        Fixclick(285, 15, "Right")
        Sleep (2500)
        Fixclick(285, 25, "Right")
        Sleep (3000)
        Fixclick(410, 25, "Right")
        Sleep (3000)
        Fixclick(765, 150, "Right")
        Sleep (3000)
        Fixclick(545, 30, "Right")
        Sleep (3000)
    }
}

MoveForSpaceCenter() {
    if (ok := FindText(&X, &Y, 630, 170, 720, 260, 0.15, 0.15, SpaceCenterAngle)) {
        Fixclick(660, 420, "Right")
        Sleep (7000)
    } else {
        Fixclick(160, 280, "Right")
        Sleep (7000)
    }
}

MoveForMountainTemple() {
    Fixclick(40, 500, "Right")
    Sleep (4000)
}

MoveForCursedFestival() {
    if (ok := FindText(&X, &Y, 560, 285, 615, 350, 0.15, 0.15, FestivalAngle)) {
        SendInput ("{d down}")
        sleep (1800)
        SendInput ("{d up}")
    } else {
        SendInput ("{a down}")
        sleep (1800)
        SendInput ("{a up}")
    }
}

MoveForNightmareTrain() {
    SendInput ("{a down}")
    sleep (1800)
    SendInput ("{a up}")
}

MoveForAirCraft() {
    if (ok := FindText(&X, &Y, 535, 110, 620, 175, 0.15, 0.15, AirCraftAngle)) {
        Fixclick(90, 560, "Right")
        Sleep (5000)
    } else {
        Fixclick(655, 122, "Right")
        Sleep (5000)
    }
}

MoveForHellish() {
    Fixclick(600, 300, "Right")
    Sleep (7000)
}

MoveForShibuya() {
    if (ok := FindText(&X, &Y, 220, 190, 320, 250, 0.15, 0.15, ShibuyaAngle)) {
        SendInput ("{a down}")
        sleep (600)
        SendInput ("{a up}")
        sleep (500)
        SendInput ("{a down}")
        SendInput ("{w down}")
        Sleep (1500)
        SendInput ("{a up}")
        SendInput ("{w up}")
    } else {
        SendInput ("{d down}")
        Sleep(2000)
        SendInput ("{d up}")
    }
}

RestartStage() {
    currentMap := DetectMap()

    ; Wait for loading
    CheckLoaded()

    ; Do initial setup and map-specific movement during vote timer
    BasicSetup()
    if (currentMap != "no map found") {
        HandleMapMovement(currentMap)
    }

    ; Wait for game to actually start
    StartedGame()

    ; Monitor stage progress
    MonitorStage()
}

Reconnect() {
    ; Check for Disconnected Screen using FindText
    if (ok := FindText(&X, &Y, 330, 218, 474, 247, 0, 0, Disconnect)) {
        ProcessLog("Lost Connection! Attempting To Reconnect To Private Server...")

        psLink := FileExist("Settings\PrivateServer.txt") ? FileRead("Settings\PrivateServer.txt", "UTF-8") : ""

        ; Reconnect to Ps
        if FileExist("Settings\PrivateServer.txt") && (psLink := FileRead("Settings\PrivateServer.txt", "UTF-8")) {
            ProcessLog("Connecting to private server...")
            Run(psLink)
        } else {
            Run("roblox://placeID=8304191830")
        }

        Sleep(5000)

        loop {
            ProcessLog("Reconnecting to Roblox...")
            Sleep(15000)

            if WinExist(rblxID) {
                forceRobloxSize()
                moveRobloxWindow()
                Sleep(1000)
            }
            CheckLobby()
        }
    }
}

PlaceUnit(x, y, slot := 1) {
    SendInput(slot)
    Sleep 50
    FixClick(x, y)
    Sleep 50
    SendInput("q")

    if UnitPlaced() {
        Sleep 15
        return true
    }
    return false
}

MaxUpgrade() {
    Sleep 500
    ; Check for max text
    if (ok := FindText(&X, &Y, 160, 215, 330, 420, 0, 0, MaxText) or (ok := FindText(&X, &Y, 160, 215, 330, 420, 0, 0,
        MaxText2))) {
        return true
    }
    return false
}

UnitPlaced() {
    Sleep 2000
    ; Check for upgrade text
    if (ok := FindText(&X, &Y, 160, 215, 330, 420, 0, 0, UpgradeText) or (ok := FindText(&X, &Y, 160, 215, 330, 420, 0,
        0, UpgradeText2))) {
        ProcessLog("Unit Placed Successfully")
        CheckAbility()
        FixClick(325, 185) ; close upg menu
        return true
    }
    return false
}

CheckAbility() {
    global AutoAbilityBox  ; Reference your checkbox

    ; Only check ability if checkbox is checked
    if (AutoAbilityBox.Value) {
        if (ok := FindText(&X, &Y, 342, 253, 401, 281, 0, 0, AutoOff)) {
            FixClick(373, 237)  ; Turn ability on
            ProcessLog("Auto Ability Enabled")
        }
    }
}

CheckForXp() {
    ; Check for lobby text
    if (ok := FindText(&X, &Y, 340, 369, 437, 402, 0, 0, XpText) or (ok := FindText(&X, &Y, 539, 155, 760, 189, 0, 0,
        XpText2))) {
        FixClick(325, 185)
        FixClick(560, 560)
        return true
    }
    return false
}

UpgradeUnit(x, y) {
    FixClick(x, y - 3)
    FixClick(264, 363) ; upgrade button
    FixClick(264, 363) ; upgrade button
    FixClick(264, 363) ; upgrade button
}

CheckLobby() {
    loop {
        Sleep 1000
        if (ok := FindText(&X, &Y, 746, 514, 789, 530, 0, 0, AreaText)) {
            break
        }
        Reconnect()
    }
    ProcessLog("Returned to lobby, restarting selected mode")
    return StartSelectedMode()
}

CheckLoaded() {
    loop {
        Sleep(1000)

        ; Check for vote screen
        if (ok := FindText(&X, &Y, 326, 60, 547, 173, 0, 0, VoteStart) or PixelGetColor(320, 60) = 0x00EE00) {
            ProcessLog("Successfully Loaded In")
            Sleep(1000)
            break
        }

        Reconnect()
    }
}

StartedGame() {
    loop {
        Sleep(1000)
        if (ok := FindText(&X, &Y, 326, 60, 547, 173, 0, 0, VoteStart)) {
            FixClick(350, 103) ; click yes
            FixClick(350, 100)
            FixClick(350, 97)
            continue  ; Keep waiting if vote screen is still there
        }

        ; If we don't see vote screen anymore the game has started
        ProcessLog("Game started")
        global stageStartTime := A_TickCount
        break
    }
}

StartSelectedMode() {
    FixClick(400, 340)
    FixClick(400, 390)
    if (ModeDropdown.Text = "Hatch Eggs") {
        EggHatching()
    }
    else if (ModeDropdown.Text = "Farm") {
        LegendMode()
    }
    else if (ModeDropdown.Text = "Reroll Enchants") {
        EnchantMode()
    }
    else if (ModeDropdown.Text = "Raid") {
        RaidMode()
    }
    else if (ModeDropdown.Text = "Infinity Castle") {
        InfinityCastleMode()
    }
    else if (ModeDropdown.Text = "Contract") {
        ContractMode()
    }
    else if (ModeDropdown.Text = "Dungeon") {
        DungeonMode()
    }
}

FormatStageTime(ms) {
    seconds := Floor(ms / 1000)
    minutes := Floor(seconds / 60)
    hours := Floor(minutes / 60)

    minutes := Mod(minutes, 60)
    seconds := Mod(seconds, 60)

    return Format("{:02}:{:02}:{:02}", hours, minutes, seconds)
}

ValidateMode() {
    if (ModeDropdown.Text = "") {
        ProcessLog("Please select a gamemode before starting the macro!")
        return false
    }
    if (!confirmClicked) {
        ProcessLog("Please click the confirm button before starting the macro!")
        return false
    }
    return true
}

GetNavKeys() {
    return StrSplit(FileExist("Settings\UINavigation.txt") ? FileRead("Settings\UINavigation.txt", "UTF-8") : "\,#,}",
    ",")
}

HandleContractJoin() {
    selectedPage := ContractPageDropdown.Text
    joinType := ContractJoinDropdown.Text

    ; Handle 4-5 Page pattern selection
    if (selectedPage = "Page 4-5") {
        selectedPage := GetContractPage()
        ProcessLog("Pattern selected: " selectedPage)
    }

    pageNum := selectedPage = "Page 4-5" ? GetContractPage() : selectedPage
    pageNum := Integer(RegExReplace(RegExReplace(pageNum, "Page\s*", ""), "-.*", ""))

    ; Define click coordinates for each page
    clickCoords := Map(
        1, { openHere: { x: 170, y: 420 }, matchmaking: { x: 240, y: 420 } },  ; Example coords for page 1
        2, { openHere: { x: 330, y: 420 }, matchmaking: { x: 400, y: 420 } },  ; Example coords for page 2
        3, { openHere: { x: 490, y: 420 }, matchmaking: { x: 560, y: 420 } }, ; Example coords for page 3
        4, { openHere: { x: 237, y: 420 }, matchmaking: { x: 305, y: 420 } },  ; Example coords for page 4
        5, { openHere: { x: 397, y: 420 }, matchmaking: { x: 465, y: 420 } },  ; Example coords for page 5
        6, { openHere: { x: 557, y: 420 }, matchmaking: { x: 625, y: 420 } }  ; Example coords for page 6
    )

    ; First scroll if needed for pages 4-6
    if (pageNum >= 4) {
        FixClick(445, 300)
        Sleep(200)
        loop 5 {
            SendInput("{WheelDown}")
            Sleep(150)
        }
        Sleep(300)
    }

    ; Get coordinates for the selected page
    pageCoords := clickCoords[pageNum]

    ; Handle different join types
    if (joinType = "Creating") {
        ProcessLog("Creating contract portal on page " pageNum)
        FixClick(pageCoords.openHere.x, pageCoords.openHere.y)
        Sleep(300)
        FixClick(255, 355)
        Sleep(15000)
        ProcessLog("Waiting 15 seconds for others to join")
        FixClick(400, 460)
    } else if (joinType = "Matchmaking") {
        ProcessLog("Joining matchmaking for contract on page " pageNum)
        FixClick(pageCoords.matchmaking.x, pageCoords.matchmaking.y)  ; Click matchmaking button
        Sleep(300)

        ; Try captcha
        if (!CaptchaDetect(252, 292, 300, 50, 400, 335)) {
            ProcessLog("Captcha not detected, retrying...")
            FixClick(585, 190)  ; Click close
            return
        }
        FixClick(300, 385)  ; Enter captcha

        startTime := A_TickCount
        while (A_TickCount - startTime < 20000) {  ; Check for 20 seconds
            if !(ok := FindText(&X, &Y, 746, 514, 789, 530, 0, 0, AreaText)) {
                ProcessLog("Area text gone - matchmaking successful")
                return true
            }
            Sleep(200)  ; Check every 200ms
        }

        ProcessLog("Matchmaking failed - still on area screen after 20s, retrying...")
        FixClick(445, 220)
        Sleep(1000)
        loop 5 {
            SendInput("{WheelUp}")
            Sleep(150)
        }
        Sleep(1000)
        return HandleContractJoin()
    }

    ProcessLog("Joining Contract Mode")
    return true
}

HandleNextContract() {
    selectedPage := ContractPageDropdown.Text
    if (selectedPage = "Page 4-5") {
        selectedPage := GetContractPage()
    }

    pageNum := Integer(RegExReplace(selectedPage, "Page ", ""))

    ; Define click coordinates to vote
    clickCoords := Map(
        1, { x: 205, y: 470 },
        2, { x: 365, y: 470 },
        3, { x: 525, y: 470 },
        4, { x: 272, y: 470 },
        5, { x: 432, y: 470 },
        6, { x: 592, y: 470 }
    )

    ; First scroll if needed for pages 4-6
    if (pageNum >= 4) {
        FixClick(400, 300)
        Sleep(200)
        loop 5 {
            SendInput("{WheelDown}")
            Sleep(150)
        }
        Sleep(300)
    }

    ; Click the Open Here button for the selected page
    ProcessLog("Opening contract on page " selectedPage)
    FixClick(clickCoords[pageNum].x, clickCoords[pageNum].y)
    Sleep(500)

    return RestartStage()
}

HandleContractEnd() {

    loop {
        Sleep(3000)

        ; Click to claim any drops/rewards
        FixClick(560, 560)

        if (ok := FindText(&X, &Y, 300, 190, 360, 250, 0, 0, UnitExit)) {
            ClickUntilGone(0, 0, 300, 190, 360, 250, UnitExit, -4, -35)
        }

        if (ok := FindText(&X, &Y, 260, 400, 390, 450, 0, 0, NextText)) {
            ClickUntilGone(0, 0, 260, 400, 390, 450, NextText, 0, -40)
        }

        ; Check for both lobby texts
        if (ok := FindText(&X, &Y, 80, 85, 739, 224, 0, 0, LobbyText) or (ok := FindText(&X, &Y, 80, 85, 739, 224, 0, 0,
            LobbyText2))) {
            ProcessLog("Found Lobby Text - proceeding with contract end options")
            Sleep(2000)  ; Wait for UI to settle

            if (ReturnLobbyBox.Value) {
                ProcessLog("Contract complete - returning to lobby")
                Sleep(1500)
                ClickReturnToLobby()
                CheckLobby()
                return StartSelectedMode()
            } else {
                ProcessLog("Starting next contract")
                Sleep(1500)
                ClickOnce(0, 0, 80, 85, 739, 224, LobbyText, +120, -35, LobbyText2)
                return HandleNextContract()
            }
        }
        Reconnect()
    }
}

GetContractPage() {
    global contractPageCounter, contractSwitchPattern

    if (contractSwitchPattern = 0) {  ; During page 4 phase
        contractPageCounter++
        if (contractPageCounter >= 6) {  ; After 6 times on page 4
            contractPageCounter := 0
            contractSwitchPattern := 1  ; Switch to page 5
            return "Page 5"
        }
        return "Page 4"
    } else {  ; During page 5 phase
        contractPageCounter := 0
        contractSwitchPattern := 0  ; Switch back to page 4 pattern
        return "Page 4"
    }
}

GenerateRandomPoints() {
    points := []
    gridSize := 40  ; Minimum spacing between units

    ; Center point coordinates
    centerX := 408
    centerY := 320

    ; Define placement area boundaries (adjust these as needed)
    minX := centerX - 180  ; Left boundary
    maxX := centerX + 180  ; Right boundary
    minY := centerY - 140  ; Top boundary
    maxY := centerY + 140  ; Bottom boundary

    ; Generate 40 random points
    loop 40 {
        ; Generate random coordinates
        x := Random(minX, maxX)
        y := Random(minY, maxY)

        ; Check if point is too close to existing points
        tooClose := false
        for existingPoint in points {
            ; Calculate distance to existing point
            distance := Sqrt((x - existingPoint.x) ** 2 + (y - existingPoint.y) ** 2)
            if (distance < gridSize) {
                tooClose := true
                break
            }
        }

        ; If point is not too close to others, add it
        if (!tooClose)
            points.Push({ x: x, y: y })
    }

    ; Always add center point last (so it's used last)
    points.Push({ x: centerX, y: centerY })

    return points
}

GenerateGridPoints() {
    points := []
    gridSize := 40  ; Space between points
    squaresPerSide := 7  ; How many points per row/column (odd number recommended)

    ; Center point coordinates
    centerX := 408
    centerY := 320

    ; Calculate starting position for top-left point of the grid
    startX := centerX - ((squaresPerSide - 1) / 2 * gridSize)
    startY := centerY - ((squaresPerSide - 1) / 2 * gridSize)

    ; Generate grid points row by row
    loop squaresPerSide {
        currentRow := A_Index
        y := startY + ((currentRow - 1) * gridSize)

        ; Generate each point in the current row
        loop squaresPerSide {
            x := startX + ((A_Index - 1) * gridSize)
            points.Push({ x: x, y: y })
        }
    }

    return points
}

; circle coordinates
GenerateCirclePoints() {
    points := []

    ; Define each circle's radius
    radius1 := 45    ; First circle
    radius2 := 90    ; Second circle
    radius3 := 135   ; Third circle
    radius4 := 180   ; Fourth circle

    ; Angles for 8 evenly spaced points (in degrees)
    angles := [0, 45, 90, 135, 180, 225, 270, 315]

    ; First circle points
    for angle in angles {
        radians := angle * 3.14159 / 180
        x := centerX + radius1 * Cos(radians)
        y := centerY + radius1 * Sin(radians)
        points.Push({ x: Round(x), y: Round(y) })
    }

    ; second circle points
    for angle in angles {
        radians := angle * 3.14159 / 180
        x := centerX + radius2 * Cos(radians)
        y := centerY + radius2 * Sin(radians)
        points.Push({ x: Round(x), y: Round(y) })
    }

    ; third circle points
    for angle in angles {
        radians := angle * 3.14159 / 180
        x := centerX + radius3 * Cos(radians)
        y := centerY + radius3 * Sin(radians)
        points.Push({ x: Round(x), y: Round(y) })
    }

    ;  fourth circle points
    for angle in angles {
        radians := angle * 3.14159 / 180
        x := centerX + radius4 * Cos(radians)
        y := centerY + radius4 * Sin(radians)
        points.Push({ x: Round(x), y: Round(y) })
    }

    return points
}

CheckEndAndRoute() {
    if (ok := FindText(&X, &Y, 140, 130, 662, 172, 0, 0, LobbyText)) {
        ProcessLog("Found end screen")
        if (mode = "Contract") {
            return HandleContractEnd()
        } else if (mode = "Dungeon") {
            return MonitorDungeonEnd()
        } else {
            return MonitorEndScreen()
        }
    }
}

ClickUntilGone(x, y, searchX1, searchY1, searchX2, searchY2, textToFind, offsetX := 0, offsetY := 0, textToFind2 := "") {
    while (ok := FindText(&X, &Y, searchX1, searchY1, searchX2, searchY2, 0.15, 0.15, textToFind) ||
    textToFind2 && FindText(&X, &Y, searchX1, searchY1, searchX2, searchY2, 0.15, 0.15, textToFind2)) {
        if (offsetX != 0 || offsetY != 0) {
            FixClick(X + offsetX, Y + offsetY)
        } else {
            FixClick(x, y)
        }
        Sleep(1000)
    }
}

ClickOnce(x, y, searchX1, searchY1, searchX2, searchY2, textToFind, offsetX := 0, offsetY := 0, textToFind2 := "") {
    if (ok := FindText(&X, &Y, searchX1, searchY1, searchX2, searchY2, 0.15, 0.15, textToFind) ||
    textToFind2 && FindText(&X, &Y, searchX1, searchY1, searchX2, searchY2, 0.15, 0.15, textToFind2)) {

        if (offsetX != 0 || offsetY != 0) {
            FixClick(X + offsetX, Y + offsetY)
        } else {
            FixClick(x, y)
        }
    }
}

StartMacro(*) {
    if (!ValidateMode()) {
        return
    }
    StartSelectedMode()
}

TogglePause(*) {
    Pause -1
    if (A_IsPaused) {
        ProcessLog("Macro Paused")
        Sleep(1000)
    } else {
        ProcessLog("Macro Resumed")
        Sleep(1000)
    }
}

IsColorInRange(color, targetColor, tolerance := 50) {
    ; Extract RGB components
    r1 := (color >> 16) & 0xFF
    g1 := (color >> 8) & 0xFF
    b1 := color & 0xFF

    ; Extract target RGB components
    r2 := (targetColor >> 16) & 0xFF
    g2 := (targetColor >> 8) & 0xFF
    b2 := targetColor & 0xFF

    ; Check if within tolerance range
    return Abs(r1 - r2) <= tolerance
    && Abs(g1 - g2) <= tolerance
    && Abs(b1 - b2) <= tolerance
}

; Custom monitor for dungeon ending
MonitorDungeonEnd() {
    global mode, Wins, loss

    loop {
        Sleep(3000)

        FixClick(560, 560)  ; Move click

        ; Check for unit exit UI element
        if (ok := FindText(&X, &Y, 300, 190, 360, 250, 0, 0, UnitExit)) {
            ClickUntilGone(0, 0, 300, 190, 360, 250, UnitExit, -4, -35)
        }

        ; Check for next text UI element
        if (ok := FindText(&X, &Y, 260, 400, 390, 450, 0, 0, NextText)) {
            ClickUntilGone(0, 0, 260, 400, 390, 450, NextText, 0, -40)
        }

        ; Check for returning to lobby
        if (ok := FindText(&X, &Y, 80, 85, 739, 224, 0, 0, LobbyText) or
        (ok := FindText(&X, &Y, 80, 85, 739, 224, 0, 0, LobbyText2))) {
            ProcessLog("Dungeon run completed, clicking replay")

            ; Click replay button
            ClickReplay()

            ; After clicking replay, check for shop/shrine/chest
            CheckDungeonSpecials()

            if (CheckForFinishDungeon()) {
                ProcessLog("Handled dungeon completion")
                return
            }

            ; Start a new dungeon run
            ProcessLog("Starting next dungeon")
            return SelectDungeonRoute()
        }

        Reconnect()
    }
}

; Function to check for special dungeon elements after replay
CheckDungeonSpecials() {
    ProcessLog("Checking for dungeon shop, shrine, open chest")

    ; Give time for special elements to appear
    Sleep(2000)

    ; Check the area for shop, shrine, or chest
    loop 5 {
        ; Check for shop
        if (ok := FindText(&X, &Y, 140, 200, 375, 250, 0, 0, Shop)) {
            ProcessLog("Found Shop")
            Sleep(1000)
            HandleShop()
            Sleep(1000)
            return true
        }
        ; Check for shrine
        if (ok := FindText(&X, &Y, 140, 200, 375, 250, 0, 0, Shrine)) {
            ProcessLog("Found Shrine, Denying")
            ClickUntilGone(0, 0, 490, 420, 605, 455, DenyShrine, 0, -30)
            Sleep(3000)
            ClickUntilGone(0, 0, 380, 385, 615, 490, DungeonContinue, -3, -35, DungeonContinue2)
            Sleep(1000)
            return true
        }
        ; Check for Chest Opening
        if (ok := FindText(&X, &Y, 140, 200, 375, 250, 0, 0, ChestRoom)) {
            ProcessLog("Found Chest Opening")
            HandleChestScreen()
            return true
        }

        Sleep(1000)  ; Wait and check again
    }

    ProcessLog("No shop, shrine, open chest found")
    return false
}

SelectDungeonRoute() {
    if (ok := FindText(&X, &Y, 300, 260, 500, 465, 0.10, 0.10, BossRoom) or (ok := FindText(&X, &Y, 300, 260, 500, 465,
        0.10, 0.10, BossRoom2))) {
        ProcessLog("Boss room detected!")
        global BossRoomCompleted := true
        FixClick(X, Y - 30)
        Sleep(1000)
    }
    else if (ok := FindText(&X, &Y, 200, 350, 600, 435, 0.20, 0.20, Chest)) {
        ProcessLog("Found Chest Room, clicking it")
        FixClick(X, Y - 30)
        Sleep(1000)
    }
    else if (ok := FindText(&X, &Y, 200, 350, 600, 435, 0.20, 0.20, Hoard)) {
        ProcessLog("Found Hoard Room, clicking it")
        FixClick(X, Y - 30)
        Sleep(1000)
    }
    else {
        ; If no chest/hoard found, click default positions
        ProcessLog("No chest/hoard found, clicking default positions")
        FixClick(400, 355)
        Sleep(500)
        FixClick(335, 355)
        Sleep(500)
    }

    ; Look for Enter button and click until gone
    if (ok := FindText(&X, &Y, 120, 425, 680, 500, 0.20, 0.20, Enter)) {
        ProcessLog("Found Enter button, joining dungeon")
        ClickUntilGone(0, 0, 120, 425, 680, 500, Enter, 0, -30)
        Sleep(2000)

        ; Start dungeon run
        ProcessLog("Starting dungeon run")
        RestartStage()
    }
}

HandleShop() {
    ProcessLog("Handling shop - buying available items")

    ; Give the shop time to fully load
    Sleep(1000)

    ; Buy item in slot 3 (bottom)
    FixClick(560, 335)
    Sleep(1000)

    ; Buy item in slot 2 (middle)
    FixClick(560, 280)
    Sleep(1000)

    ; Buy item in slot 1 (top)
    FixClick(560, 225)
    Sleep(1000)

    ; Click continue to close the shop
    ProcessLog("Closing shop")
    Sleep(5000)
    ClickUntilGone(0, 0, 380, 385, 615, 490, DungeonContinue, -3, -35, DungeonContinue2)
    return true
}

HandleChestScreen() {
    global BossRoomCompleted, SaveChestsForBoss

    ; Determine if we should open chests now
    shouldOpenChests := BossRoomCompleted || !SaveChestsForBoss

    if (shouldOpenChests) {
        ProcessLog("Opening all available chests")

        ; Process first chest position - keep clicking until exhausted
        firstChestExhausted := false

        while (!firstChestExhausted) {
            ; Click first chest OPEN button
            ClickOnce(0, 0, 535, 265, 605, 315, OpenChest, -3, -35)
            Sleep(2000)

            ; Check if we're still on the chest screen
            if (!IsChestScreenVisible()) {
                ClaimChestReward()
            } else {
                firstChestExhausted := true
            }
        }

        ; Process second chest position - keep clicking until exhausted
        secondChestExhausted := false

        while (!secondChestExhausted) {
            ; Click second chest OPEN button
            ClickOnce(0, 0, 530, 330, 605, 375, OpenChest, -3, -35)
            Sleep(1000)

            ; Check if we're still on the chest screen
            if (!IsChestScreenVisible()) {
                ClaimChestReward()
            } else {
                secondChestExhausted := true
            }
        }

        ProcessLog("All chests opened")

        ; Reset the boss room flag if it was set
        if (BossRoomCompleted) {
            BossRoomCompleted := false
            Sleep(3000)
            ClickUntilGone(0, 0, 380, 385, 615, 490, DungeonContinue, -3, -35, DungeonContinue2)
            FixClick(550, 410)
        }
    } else {
        ; Skip opening chests, just click continue
        ProcessLog("Saving chests for boss room - clicking continue")
        Sleep(3000)
        ClickUntilGone(0, 0, 380, 385, 615, 490, DungeonContinue, -3, -35, DungeonContinue2)
        FixClick(550, 410)
    }
    Sleep(1000)
    Reconnect()
    return true
}

ClaimChestReward() {
    maxClicks := 30  ; Safety limit
    clicks := 0

    while (clicks < maxClicks) {
        ; Click to claim reward
        FixClick(560, 560)
        Sleep(1500)

        ; Check if chest screen has returned
        if (IsChestScreenVisible()) {
            return true
        }

        clicks++
    }

    ProcessLog("Max clicks reached while claiming rewards")
    return false
}

IsChestScreenVisible() {
    return FindText(&X, &Y, 140, 200, 375, 250, 0, 0, ChestRoom)
}

CheckForFinishDungeon() {
    ; Check for the finish dungeon popup
    if (ok := FindText(&X, &Y, 240, 180, 565, 480, 0, 0, FinishDungeon) or (ok := FindText(&X, &Y, 310, 395, 495, 440,
        0.20, 0.20, EnterDungeon)) or (ok := FindText(&X, &Y, 370, 225, 545, 300, 0.20, 0.20, DungeonDeath))) {

        ; Click the Finish button
        ClickUntilGone(0, 0, 240, 180, 565, 480, DungeonFinish, -3, -35)
        Sleep(1500)

        ; Click the X in the top right
        ClickUntilGone(0, 0, 640, 175, 700, 205, DungeonRedX, -3, -35)
        Sleep(1000)

        ; Return to lobby
        ProcessLog("Returning to lobby after completing dungeon")
        ClickReturnToLobby()

        ; Check for lobby and restart
        return CheckLobby()
    }

    return false
}
