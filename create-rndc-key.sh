#!/bin/bash
# ensure that bind9-utils is installed so this command works
# note that it might be necessary to remove the `options block` after the file is created
sudo rndc-confgen >./etc/bind/rndc.key
