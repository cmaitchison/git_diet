#!/bin/bash
set -e
[ $# -eq 0 ] && exit
 
paths=$@
echo About to purge the following files: $paths

git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch $paths" HEAD

rm -rf .git/refs/original/
git reflog expire --all
git gc --prune=now 
git gc --aggressive