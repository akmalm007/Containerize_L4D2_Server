#!/bin/bash

set -e 

# Set the Enviroment, could change to accept environment value
MAP=$L4D2_MAP
MODE=$L4D2_MODE
GAME_LOC=$HOMEDIR/l4d2
PORT=$L4D2_PORT

# Change directory
cd $GAME_LOC

# Start the Server
./srcds_run -console -game left4dead2 -port $PORT +log on +map $MAP +mp_gamemode "$MODE" +exec server +sv_lan 0 -tickrate 100 +sv_setmax 31

