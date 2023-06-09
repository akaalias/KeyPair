#!/usr/bin/env zsh

set -e

hdiutil create -volname $APPNAME -srcfolder $APPBUNDLE -ov -format UDZO ../Archive/$APPNAME-$APPVERSION.dmg 
