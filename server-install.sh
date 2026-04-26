#!/bin/bash 
set -e

INSTALL_DIR=$HOMEDIR/l4d2

# Install Linux Dependecies First
DepotDownloader -dir $INSTALL_DIR -app 222860 -depot 222863 -manifest 2405357637318523777 -validate

# Patch to make executable in stack since Docker and Modern linux prevent code execution in stack
patchelf --clear-execstack $INSTALL_DIR/bin/libsteamvalidateuseridtickets.so

# Copy server.cfg
# cp $STEAM_CMD_LOC/server.cfg $INSTALL_DIR/bin/server.cfg

# Check the directory
ls -al

# Install the game server
DepotDownloader -dir $INSTALL_DIR -app 222860 -depot 222861 -manifest 4827977561765481436 -validate
 
exec "$@"


