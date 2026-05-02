#!/bin/bash 
set -e

INSTALL_DIR=$HOMEDIR/l4d2
L4D2_VALIDATION="false"

# Install Linux Dependecies First
if [ ! -d $INSTALL_DIR/left4dead2 ]; then
    DepotDownloader -dir $INSTALL_DIR -app 222860 -depot 222863 -manifest 2405357637318523777 -validate
    # Patch to make executable in stack since Docker and Modern linux prevent code execution in stack
    patchelf --clear-execstack $INSTALL_DIR/bin/libsteamvalidateuseridtickets.so
elif [ "$L4D2_VALIDATION" = "true" ]; then
    DepotDownloader -dir $INSTALL_DIR -app 222860 -depot 222863 -manifest 2405357637318523777 -validate
fi

if [ ! -d $INSTALL_DIR/left4dead2 ]; then
# Install the game server
    DepotDownloader -dir $INSTALL_DIR -app 222860 -depot 222861 -manifest 4827977561765481436 -validate
elif [ "$L4D2_VALIDATION" = "true" ]; then
    DepotDownloader -dir $INSTALL_DIR -app 222860 -depot 222861 -manifest 4827977561765481436 -validate
fi

exec "$@"


