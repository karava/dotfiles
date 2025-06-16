on run argv
    say "Hello, Kish"
end run

on hasExternalDisplay()
    set displayCount to do shell script ¬
        "system_profiler SPDisplaysDataType | " & ¬
        "awk '/Online:[[:space:]]+Yes/ {c++} END {print c}'"
    return (displayCount as integer) > 1
end hasExternalDisplay

on safeClose(theApp, autoClickDialogs)
    if autoClickDialogs is missing value then set autoClickDialogs to true
    -- Try the app's own 'save' verb (works for most document-based apps)
    try
        if application theApp is running then
            tell application theApp
                if (count documents) > 0 then save every document
            end tell
        end if
    end try
    
    set noSaveKeyApps to {"Terminal", "iTerm2"}

    delay 0.3
    if application theApp is running then
        tell application theApp to activate
        tell application "System Events"
            if noSaveKeyApps does not contain theApp then
                keystroke "s" using {command down} -- Save
            end if
            delay 0.15
            keystroke "q" using {command down} -- Quit
        end tell
    end if
    
    -- Auto-click common “Save” or “OK” buttons in modal dialogs
    if autoClickDialogs and application theApp is running then
        delay 0.5
        try
            tell application "System Events"
                if exists (window 1 of application process theApp) then
                    if exists (button "Save" of window 1 of application process theApp) then
                        click button "Save" of window 1 of application process theApp
                    else if exists (button "OK" of window 1 of application process theApp) then
                        click button "OK" of window 1 of application process theApp
                    end if
                end if
            end tell
        end try
    end if
    
    -- Wait up to 6 seconds total; force-quit if still alive
    repeat with i from 1 to 30 -- 30 x 0.2 s = 6 s
        if application theApp is not running then exit repeat
        delay 0.2
    end repeat
    
    -- if application theApp is running then
    --     do shell script "killall -TERM " & quoted form of theApp
    -- end if
    return not (application theApp is running)
end safeClose

on closeAllUserApps(extraSkipList)
    if extraSkipList is missing value then set extraSkipList to {}

    -- Essentials macOS relies on; never touch these
    set essentialApps to {"Finder", "Dock", "SystemUIServer", "ControlCenter", "loginwindow", "Terminal"}
    
    -- Merge lists
    set skipList to essentialApps & extraSkipList

    -- Gather front-most (non-daemon) processes
    tell application "System Events"
        set userApps to (name of (processes where background only is false))
    end tell
    
    set survivors to {}
    
    repeat with appName in userApps
        set appName to appName as text

        log appName

        if skipList does not contain appName then
            if safeClose(appName, true) is false then
                set end of survivors to appName
            end if
        end if
    end repeat
    
    return survivors
end closeAllUserApps