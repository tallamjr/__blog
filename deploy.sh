#!/bin/bash

# Serve website at http://localhost:1313/blog/ and send to bg
hugo serve &
# Run link checker
muffet --verbose http://localhost:1313/blog/
# Grab exit code from 'muffet'
exitCode=$?
# Kill background 'hugo serve' process
kill $(ps aux | grep "hugo serve" | grep -v "grep" | awk '{print $2}')
# If 'muffet' was successfull, then compile html and deply to gh-pages
if [[ $exitCode == 0 ]]; then
    rm -rf public/* && hugo && cd public && git add --all && git commit -m "Publishing to gh-pages"
    git push --all
fi
