#!/usr/bin/env zsh
#
# The main script to push to github
#
# See README.md for instructions
#
# abort on errors
set -e

echo "Creating a new commit for KeyPair.app"
echo -n "My commit message: "
read MESSAGE
echo $MESSAGE
git add -A
git commit -m $MESSAGE
git push origin main
