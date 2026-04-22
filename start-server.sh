#!/bin/bash

set -e 

GAME_LOC=/steamcmd/l4d2/

# Set the Enviroment, could change to accept environment value
MAP=c8m4_interior
MODE=survival

# Start the Server
$GAME_LOC/srcds_run -console -game left4dead2 -port 27015 +log on +map $MAP +mp_gamemode "$MODE" +exec server +sv_lan 0 -tickrate 100 +sv_setmax 31

