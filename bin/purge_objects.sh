#!/bin/bash
set -e
[ $# -eq 0 ] && exit
 
paths=$@
echo About to purge the following files: $paths

git filter-branch --tag-name-filter cat --index-filter "git rm -rf --cached --ignore-unmatch -- $paths" -- --all

git reset --hard 

git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d --

git reflog expire --expire=now --all
git gc --prune=now --aggressive
