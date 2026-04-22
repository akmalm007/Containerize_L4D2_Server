#!/bin/bash 
set -e

STEAM_CMD_LOC=/steamcmd
DEPOT_CMD_LOC=/steamcmd
INSTALL_DIR=/steamcmd/l4d2

# Install SteamCMD
$STEAM_CMD_LOC/steamcmd.sh +quit

# Install Linux Dependecies First
$DEPOT_CMD_LOC/DepotDownloader -dir $INSTALL_DIR -app 222860 -depot 222861 -manifest 4827977561765481436

# Patch to make executable in stack since Docker and Modern linux prevent code execution in stack
patchelf --clear-execstack $INSTALL_DIR/bin/libsteamvalidateuseridtickets.so

# Copy server.cfg
cp $STEAM_CMD_LOC/server.cfg $INSTALL_DIR/bin/server.cfg

# Check the directory
ls -al

# Install the game server
$DEPOT_CMD_LOC/DepotDownloader -dir $INSTALL_DIR -app 222860 -depot 222863 -manifest 2405357637318523777
 
exec "$@"


