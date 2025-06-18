script utils
    property u : load script ¬
        POSIX file (POSIX path of (path to home folder) & "dotfiles/scripts/bin/desk_utils.scpt")
end script

on run
    set externalDisplay to utils's u's hasExternalDisplay()
    
    -- 1 ▸ Clean-up (if needed)
    utils's u's closeAllUserApps({"Finder","Electron","TextEdit"})
    
    -- 2 ▸ Launch apps
    tell application "Visual Studio Code" to activate
    tell application "Arc" to activate
    tell application "Pasta" to activate
    tell application "Google Chrome" to activate
    tell application "ChatGPT" to activate
    tell application "TextEdit" to activate
    tell application "Notion" to activate
    delay 1
    
    -- 3 ▸ Arrange on external monitor
    if externalDisplay then
        snapLeftHalf("Visual Studio Code")
        snapRightHalf("Google Chrome")
    else
        snapLeftHalf("Visual Studio Code")
        snapRightHalf("Google Chrome")
    end if
end run

on snapLeftHalf(appName)
    tell application appName to activate
    tell application "System Events" to key code 123 using {control down, option down}
end snapLeftHalf

on snapRightHalf(appName)
    tell application appName to activate
    tell application "System Events" to key code 124 using {control down, option down}
end snapRightHalf