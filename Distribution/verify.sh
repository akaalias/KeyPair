#!/usr/bin/env zsh

set -e

if [ -d $APPBUNDLE ] 
then
    echo "SUCCESS: $APPBUNDLE exists!" 
else
    echo "ERROR: $APPBUNDLE is missing!" 
    exit 1
fi
