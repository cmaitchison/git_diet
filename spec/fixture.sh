#!/bin/bash
set -e

[ -x test-repo ] && rm -rf test-repo

(
  mkdir test-repo
  cd test-repo
  git init --quiet
  cat ../test-repo.gz | gunzip | git fast-import --quiet
  git checkout --quiet master
)