#!/usr/bin/env zsh

set -e
DEFAULT_MESSAGE="Updates $APPNAME Version $APPVERSION"
echo -n "My commit message: "
read MESSAGE
git add -A
git commit -m "$DEFAULT_MESSAGE - $MESSAGE"
git push origin main
