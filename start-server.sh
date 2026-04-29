#!/bin/bash

set -e 

# Set the Enviroment, could change to accept environment value
GAME_LOC=$HOMEDIR/l4d2
MAP=$L4D2_MAP
MODE=$L4D2_MODE
PORT=$L4D2_PORT
TICK=$L4D2_TICK
SOURCETV=$L4D2_SOURCETV

# Change directory
cd $GAME_LOC

# Start the Server
./srcds_run -console -game left4dead2 -port $PORT +log on +map $MAP +mp_gamemode "$MODE" +exec server +sv_lan 0 -tickrate $TICK +sv_setmax 31 -insecure +tv_enable $SOURCETV 

