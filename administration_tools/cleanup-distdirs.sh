#!/bin/bash

ME=$(readlink -f "$0")
MYDIR=$(dirname "$ME")

cd "$MYDIR/.." || exit

rm -rf dist
rm -rf dist-github

