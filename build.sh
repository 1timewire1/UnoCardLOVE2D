#!/bin/sh
# Packages the game as dist/UnoCard.love (a zip archive with main.lua at its
# root). Run it with any LOVE 11.x install:  love dist/UnoCard.love
set -e

cd "$(dirname "$0")"
mkdir -p dist
rm -f dist/UnoCard.love
zip -9 -r dist/UnoCard.love main.lua conf.lua LICENSE src resource
echo "dist/UnoCard.love"
