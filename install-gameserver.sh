#!/bin/bash 

set -e

# Enviroment
DEPOT_BIN=$HOME/steamcmd/
STEAM_BIN=$HOME/steamcmd/

# Depedencies
sudo dpkg --add-architecture i386 
sudo apt update 
sudo apt -y install curl wget file tar bzip2 gzip unzip bsdmainutils python3 \
    util-linux ca-certificates binutils bc jq tmux netcat \
    lib32gcc-s1 lib32stdc++6 libsdl2-2.0-0:i386 lib32z1 \
    gcc-multilib libcurl4-openssl-dev:i386 libc6 \
    libc6:i386 libstdc++6 libstdc++6:i386

# Change Directory
cd $HOME
mkdir -p steamcmd
cd $HOME/steamcmd

# SteamCMD
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Depot Downloder
wget https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_3.4.0/DepotDownloader-linux-x64.zip 
unzip DepotDownloader-linux-x64.zip

# Install Steamcmd
$STEAM_BIN/steam.sh +quit

# Install L4D2 Game Server
$DEPOT_BIN/steamcmd/DepotDownloader -dir $HOME/l4d2 -app 222860 -depot 222861 -manifest 4827977561765481436
$DEPOT_BIN/steamcmd/DepotDownloader -dir $HOME/l4d2 -app 222860 -depot 222863 -manifest 2405357637318523777
 
# Start the Server
MAP=c8m4_interior
MODE=coop

./srcds_run -console -game left4dead2 -port 27015 +log on +map c8m4_interior +mp_gamemode "survival" +exec server +sv_lan 0 -tickrate 100 +sv_setmax 31




