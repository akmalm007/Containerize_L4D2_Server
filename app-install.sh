#!/bin/bash 
set -e

STEAM_CMD_LOC=/steamcmd/
DEPOT_CMD_LOC=/steamcmd/
INSTALL_DIR=/steamcmd/games/

$STEAM_CMD_LOC/steamcmd.sh +quit

# Install Steamcmd
$STEAM_BIN/steam.sh +quit

# Install L4D2 Game Server
$DEPOT_BIN/steamcmd/DepotDownloader -dir $HOME/l4d2 -app 222860 -depot 222861 -manifest 4827977561765481436
$DEPOT_BIN/steamcmd/DepotDownloader -dir $HOME/l4d2 -app 222860 -depot 222863 -manifest 2405357637318523777
 
# Start the Server
# MAP=c8m4_interior
# MODE=coop
#
# ./srcds_run -console -game left4dead2 -port 27015 +log on +map c8m4_interior +mp_gamemode "survival" +exec server +sv_lan 0 -tickrate 100 +sv_setmax 31
#
exec "$@"


