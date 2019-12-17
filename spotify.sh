#!/bin/bash
# Specify to run it as an OS applesctipt specifying it ends at EOT
/usr/bin/osascript <<EOT
if application "Spotify" is running then
    tell application "Spotify"
        if player state is playing then
            return (get artist of current track) & " - " & (get name of current track)
        else
            return ""
        end if
    end tell
end if
if application "iTunes" is running then
    tell application "iTunes"
        if player state is playing then
            return (get artist of current track) & " - " & (get name of current track)
        else
            return ""
        end if
    end tell
end if
return ""
EOT
exit 0