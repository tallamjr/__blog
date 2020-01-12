#!/bin/bash

rm -rf public/* && hugo && cd public && git add --all && git commit -m "Publishing to gh-pages"

git push --all
