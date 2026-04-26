#!/bin/bash

set -e 

# Set the Enviroment, could change to accept environment value
MAP=c8m4_interior
MODE=survival
GAME_LOC=$HOMEDIR/l4d2
PORT=$PORT
CFG=$CFG

# Change directory
cd $GAME_LOC

# Start the Server
./srcds_run -console -game left4dead2 -port 27015 +log on +map $MAP +mp_gamemode "$MODE" +exec server +sv_lan 0 -tickrate 100 +sv_setmax 31

