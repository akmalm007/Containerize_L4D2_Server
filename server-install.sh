#!/bin/bash 
set -e

STEAM_CMD_LOC=/steamcmd/
DEPOT_CMD_LOC=/steamcmd/
INSTALL_DIR=/steamcmd/l4d2/

# Install SteamCMD
$STEAM_CMD_LOC/steamcmd.sh +quit

# Install L4D2 Game Server
$DEPOT_CMD_LOC/steamcmd/DepotDownloader -dir $INSTALL_DIR -app 222860 -depot 222861 -manifest 4827977561765481436
$DEPOT_CMD_LOC/steamcmd/DepotDownloader -dir $INSTALL_DIR -app 222860 -depot 222863 -manifest 2405357637318523777

# Patch to make executable is stack since Docker and Modern linux prevent code execution in stack
patchelf --clear-exectack /steamcmd/l4d2/bin/libsteamvalidateuseridtickets.so
 
exec "$@"


