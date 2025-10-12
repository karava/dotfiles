script utils
    property u : load script ¬
        POSIX file (POSIX path of (path to home folder) & "dotfiles/scripts/bin/desk_utils.scpt")
end script

on run
    set externalDisplay to utils's u's hasExternalDisplay()
    
    -- 1 ▸ Clean-up (if needed)
    utils's u's closeAllUserApps({"Finder","Electron","TextEdit"})
    
    -- 2 ▸ Launch apps
    log "Launching applications..."
    tell application "Visual Studio Code" to activate
    tell application "Terminal" to activate
    tell application "Google Chrome" to activate
    delay 2 -- Give apps time to launch
    
    -- 3 ▸ Get screen dimensions
    tell application "Finder"
        set screenBounds to bounds of window of desktop
        set screenWidth to item 3 of screenBounds
        set screenHeight to item 4 of screenBounds
    end tell
    
    log "Screen dimensions: " & screenWidth & " x " & screenHeight
    
    -- 4 ▸ Calculate positions
    -- Chrome: 1/3 of screen on right
    set chromeX to screenWidth * 2 / 3
    set chromeY to 0
    set chromeWidth to screenWidth / 3
    set chromeHeight to screenHeight
    
    -- Terminal and VS Code: 2/3 of screen on left
    set leftX to 0
    set leftY to 0
    set leftWidth to screenWidth * 2 / 3
    set leftHeight to screenHeight
    
    -- 5 ▸ Position windows
    log "Positioning Chrome..."
    positionWindow("Google Chrome", chromeX, chromeY, chromeWidth, chromeHeight)
    
    log "Positioning Terminal..."
    positionWindow("Terminal", leftX, leftY, leftWidth, leftHeight)
    
    log "Positioning VS Code..."
    positionWindow("Visual Studio Code", leftX, leftY, leftWidth, leftHeight)
    
    -- Bring VS Code to front as it's likely the main working app
    tell application "Visual Studio Code" to activate
    
    log "Window arrangement complete!"
end run

on positionWindow(appName, x, y, w, h)
    tell application "System Events"
        tell process appName
            try
                set frontmost to true
                tell window 1
                    set position to {x, y}
                    set size to {w, h}
                end tell
            on error errMsg
                log "Error positioning " & appName & ": " & errMsg
            end try
        end tell
    end tell
end positionWindow