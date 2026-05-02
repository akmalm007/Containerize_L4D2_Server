#!/bin/bash 
set -e

INSTALL_DIR=$HOMEDIR/l4d2
PLUGINS="https://github.com/akmalm007/L4D2_Survival_Plugins/releases/download/version/survival-plugins.tar.gz"

# Install Linux Dependecies First
DepotDownloader -dir $INSTALL_DIR -app 222860 -depot 222863 -manifest 2405357637318523777 -validate

# Patch to make executable in stack since Docker and Modern linux prevent code execution in stack
patchelf --clear-execstack $INSTALL_DIR/bin/libsteamvalidateuseridtickets.so

# Install the game server
DepotDownloader -dir $INSTALL_DIR -app 222860 -depot 222861 -manifest 4827977561765481436 -validate

exec "$@"


