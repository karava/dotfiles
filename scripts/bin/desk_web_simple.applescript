on run
    log "Starting simple desk_web script..."
    
    -- Launch apps if not running
    tell application "Visual Studio Code" to launch
    tell application "Terminal" to launch
    tell application "Google Chrome" to launch
    
    delay 2 -- Give apps time to launch
    
    -- Get screen dimensions
    tell application "Finder"
        set screenBounds to bounds of window of desktop
        set screenWidth to item 3 of screenBounds
        set screenHeight to item 4 of screenBounds
    end tell
    
    log "Screen: " & screenWidth & " x " & screenHeight
    
    -- Calculate positions
    set chromeX to round (screenWidth * 2 / 3)
    set chromeWidth to round (screenWidth / 3)
    set leftWidth to round (screenWidth * 2 / 3)
    
    -- Position windows using System Events
    tell application "System Events"
        -- Position Chrome (1/3 right)
        try
            tell process "Google Chrome"
                set frontmost to true
                tell window 1
                    set position to {chromeX, 0}
                    set size to {chromeWidth, screenHeight}
                end tell
            end tell
            log "Chrome positioned successfully"
        on error errMsg
            log "Chrome error: " & errMsg
        end try
        
        -- Position Terminal (2/3 left)
        try
            tell process "Terminal"
                set frontmost to true
                tell window 1
                    set position to {0, 0}
                    set size to {leftWidth, screenHeight}
                end tell
            end tell
            log "Terminal positioned successfully"
        on error errMsg
            log "Terminal error: " & errMsg
        end try
        
        -- Position VS Code (2/3 left)
        try
            tell process "Code"
                set frontmost to true
                tell window 1
                    set position to {0, 0}
                    set size to {leftWidth, screenHeight}
                end tell
            end tell
            log "VS Code positioned successfully"
        on error errMsg
            -- Try alternative process name
            try
                tell process "Visual Studio Code"
                    set frontmost to true
                    tell window 1
                        set position to {0, 0}
                        set size to {leftWidth, screenHeight}
                    end tell
                end tell
                log "VS Code positioned successfully (alt name)"
            on error errMsg2
                log "VS Code error: " & errMsg & " / " & errMsg2
            end try
        end try
    end tell
    
    -- Bring VS Code to front
    tell application "Visual Studio Code" to activate
    
    log "Window arrangement complete!"
    display notification "Windows arranged!" with title "Desk Web"
end run