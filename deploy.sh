#!/bin/bash

hugo serve &

muffet --verbose http://localhost:1313/blog/
exitCode=$?
if [[ $exitCode == 0 ]]; then
    rm -rf public/* && hugo && cd public && git add --all && git commit -m "Publishing to gh-pages"
    git push --all
fi

kill $(ps aux | grep "hugo serve" | grep -v "grep" | awk '{print $2}')
