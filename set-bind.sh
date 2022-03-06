#!/bin/bash
# before running the docker image, run this script to set the
# user to 101 which is the id of the bind user in the docker image
sudo rndc-confgen >./etc/bind/rndc.key
chown 101:101 -R etc
chown 101:101 -R var
