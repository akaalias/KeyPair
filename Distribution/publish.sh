#!/usr/bin/env zsh

set -e

export APPNAME=KeyPair
export APPBUNDLE="$APPNAME.app"
export DMGNAME="$APPNAME-$VERSION.dmg"
export HTMLNAME="$APPNAME-$VERSION.html"

if [ -d $APPBUNDLE ] 
then
    echo "SUCCESS: $APPBUNDLE exists!" 
else
    echo "ERROR: $APPBUNDLE is missing!" 
    exit 1
fi

export APPVERSION=$(scout read -i $APPBUNDLE/Contents/Info.plist -f plist "CFBundleVersion")

echo ""
echo "Committing latest code changes to Github:"
echo ""
./ship.sh

echo ""
echo "Generating DMG:"
echo ""
./dmg.sh

echo ""
echo "Write Release Notes:"
echo ""
./write_release_notes.sh

echo ""
echo "Generating Appcast:"
echo ""
./generate_appcast.sh

echo ""
echo "Cleaning up:"
echo ""
# ./cleanup.sh 

echo "Committing latest Appcast to Github:"
echo ""
./ship.sh
