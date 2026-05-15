script utils
    property u : load script ¬
        POSIX file (POSIX path of (path to home folder) & "dotfiles/scripts/bin/desk_utils.scpt")
end script

on run
    set externalDisplay to utils's u's hasExternalDisplay()
    
    -- 1 ▸ Clean-up (if needed)
    utils's u's closeAllUserApps({"Finder"})
    
    -- 2 ▸ Launch apps
    -- tell application "Notion" to activate
    -- delay 1
    
    -- 5 ▸ Load Notion cheat-sheet
    do shell script "open -g 'notion://www.notion.so/161ec94654ff8234936d812a52406076'"
    -- delay 0.4
    -- tell application "Notion" to activate
end run

on snapLeftHalf(appName)
    tell application appName to activate
    tell application "System Events" to key code 123 using {control down, option down}
end snapLeftHalf
