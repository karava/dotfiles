-- Issues if arc browser is not already in full screen we can't move it's location

script utils
    property u : load script ¬
        POSIX file (POSIX path of (path to home folder) & "dotfiles/scripts/bin/desk_utils.scpt")
end script

on run
    set externalDisplay to utils's u's hasExternalDisplay()
    
    utils's u's closeAllUserApps({"Finder","Electron","ChatGPT"})
    
    tell application "Arc"
        activate
    end tell

    leaveFullScreen("Arc")

    delay 0.5
    snapMaximize("Arc")

    delay 1
    tell application "Arc"
        delay 1
        if (count of windows) = 1 then make new window
        set meetWin to front window
    end tell

    delay 1

    if externalDisplay then
        delay 1
        if onMainScreen("Arc") is true then
            moveToNextDisplay("Arc")
        else
            moveToPreviousDisplay("Arc")
        end if

        delay 1
    end if

    say "We're done"
end run

on snapLeftHalf(appName)
    tell application appName to activate
    tell application "System Events" to key code 123 using {control down, option down}
end snapLeftHalf

on snapRightHalf(appName)
    tell application appName to activate
    tell application "System Events" to key code 124 using {control down, option down}
end snapRightHalf

on snapMaximize(appName)
    tell application appName to activate
    tell application "System Events" to key code 36 using {control down, option down}
end snapMaximize

on moveToNextDisplay(appName)
    tell application appName to activate
    tell application "System Events" to key code 124 using {control down, option down, command down}
end moveToNextDisplay

on moveToPreviousDisplay(appName)
    tell application appName to activate
    tell application "System Events" to key code 123 using {control down, option down, command down}
end moveToPreviousDisplay

on onMainScreen(appName)
    ---------------------------------------------------------------------------
    -- 1 ▸ Get the window’s centre point (cx, cy)
    ---------------------------------------------------------------------------
    tell application "System Events"
        if not (exists application process appName) then return false
        tell application process appName
            if (count of windows) = 0 then return false
            set {xPos, yPos} to position of window 1
            set {wSize, hSize} to size of window 1
        end tell
    end tell
    set cx to (xPos + (wSize / 2))
    set cy to (yPos + (hSize / 2))
    log yPos
    log "...checking if window is on main (monitor) screen:"
    log yPos < 100
    
    return yPos < 100
end onMainScreen

on leaveFullScreen(appName)
    log "Leaving full screen"
    try
        tell application "System Events" ¬
            to tell application process appName ¬
            to set value of attribute "AXFullScreen" of window 1 to false
    on error
        log "Error leaving full screen"
        delay 2
        tell application "System Events" to key code 20
        tell application "System Events" to key code 20
        -- tell application "System Events" to key code 53
        tell application "System Events" to key code 27
        tell application "System Events" to key code 27
    end try -- ignore errors for apps with no AXFullScreen attribute
end leaveFullScreen