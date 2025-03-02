#!/usr/bin/env bash

check_command() {
    for c in "$@"; do
        if ! command -v $c > /dev/null 2>&1 ; then
            echo "command $c not in PATH" 1>&2
            exit 1
        fi
    done
}

check_command awk sed rm cat chmod fzf find

# start AME process
echo "generating file list" 1>&2
rm -f file_list.txt fzf_list.txt
find -type f > file_list.txt
targets=(applocker autologger clipsvc clipup DeliveryOptimization DeviceCensus.exe diagtrack dmclient dosvc EnhancedStorage homegroup hotspot invagent microsoftedge.exe msra sihclient slui startupscan storsvc usoapi usoclient usocore usocoreworker usosvc WaaS windowsmaps windowsupdate wsqmcons wua wus)
for i in "${targets[@]}"; do
    echo "looking for $i" 1>&2
    fzf -e -f $i < file_list.txt >> fzf_list.txt
done 

# check if fzf found anything
if ! [ -s fzf_list.txt ]; then
    echo "fzf found nothing, please ensure that this script is at the root of your windows installation" 1>&2
    exit 1
fi

# remove outliers but not remove everything after the last `/` since it can result in "C:\windows\system32"
awk '!/FileMaps/ && !/WinSxS/ && !/MSRAW/ && !/msrating/' fzf_list.txt > dirs.txt

# creates removal script
cat << 'EOF' > remove.sh
#!/bin/bash
rm -rf "Program Files/Internet Explorer"
rm -rf "Program Files/Windows Defender"
rm -rf "Program Files/Windows Mail"
rm -rf "Program Files/Windows Media Player"
rm -rf "Program Files (x86)/Internet Explorer"
rm -rf "Program Files (x86)/Microsoft"
rm -rf "Program Files (x86)/Windows Defender"
rm -rf "Program Files (x86)/Windows Defender Advanced Threat Protection"
rm -rf "Program Files (x86)/Windows Mail"
rm -rf "Program Files (x86)/Windows Media Player"
rm -rf Windows/System32/wua*
rm -rf Windows/System32/wups*
rm -rf Windows/SystemApps/*CloudExperienceHost*
rm -rf Windows/SystemApps/*ContentDeliveryManager*
rm -rf Windows/SystemApps/Microsoft.MicrosoftEdge*
rm -rf Windows/SystemApps/Microsoft.Windows.Cortana*
rm -rf Windows/SystemApps/Microsoft.XboxGameCallableUI*
rm -rf Windows/SystemApps/Microsoft.XboxIdentityProvider*
rm -rf Windows/diagnostics/system/Apps
rm -rf Windows/diagnostics/system/WindowsUpdate
rm -rf "Windows/System32/smartscreen.exe"
rm -rf "Windows/System32/smartscreenps.dll"
rm -rf "Windows/System32/SecurityHealthAgent.dll"
rm -rf "Windows/System32/SecurityHealthService.exe"
rm -rf "Windows/System32/SecurityHealthSystray.exe"
EOF
awk -v quote='"' '{print "rm -rf " quote $0 quote}' dirs.txt >> remove.sh
chmod +x remove.sh
rm fzf_list.txt file_list.txt dirs.txt
echo "now run ./remove.sh to finish" 1>&2