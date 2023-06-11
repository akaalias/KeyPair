#!/usr/bin/env zsh
set -e


echo "Let's tell them why they should update!"
export EDITOR=/opt/homebrew/bin/emacs
$EDITOR ../Archive/$HTMLNAME

echo "Creating HTML for $DMGNAME: $HTMLNAME"
echo "-----------------------------------"
echo "-----------------------------------"
