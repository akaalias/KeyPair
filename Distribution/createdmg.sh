rm KeyPair.dmg
hdiutil create -volname "KeyPair" -srcfolder ./KeyPair.app -ov -format UDZO KeyPair.dmg && rm -Rf ./KeyPair.app
