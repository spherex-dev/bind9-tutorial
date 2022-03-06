#!/bin/bash
# this script reverts permissions to your current user
chown $UID:$(id -g) -R etc
chown $UID:$(id -g) -R var