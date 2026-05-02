#!/bin/bash

set -e

INSTALL_DIR=$HOMEDIR/l4d2
PLUGINS="https://github.com/akmalm007/L4D2_Survival_Plugins/releases/download/version/survival-plugins.tar.gz"

# Sourcemod, Metamod, and Plugins to Installation
if [ ! -d "$INSTALL_DIR/left4dead2/addons/sourcemod" ] && [ "$L4D2_MODE" = "survival" ]; then
    curl -sqL $PLUGINS | tar xzvfk - -C $INSTALL_DIR/left4dead2
elif [ ! -f "$INSTALL_DIR/left4dead2/cfg/server.cfg"]; then
    curl -sqL $PLUGINS | tar xzvfk - -C $INSTALL_DIR/left4dead2 cfg/server.cfg
fi 
