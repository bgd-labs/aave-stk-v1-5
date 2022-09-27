#!/bin/bash

git diff --no-index --diff-algorithm=patience --ignore-space-at-eol $1 $2 > diff/$3.md
sed -i '1s/^/```/' diff/$3.md
