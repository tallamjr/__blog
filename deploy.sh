#!/bin/bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ $BRANCH == "master" ]]; then
    rm -rf public/* && hugo && cd public && git add --all && git commit -m "Publishing to gh-pages"
    git push --all
    cd ..
fi
