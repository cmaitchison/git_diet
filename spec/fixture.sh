#!/bin/bash
set -e

[ -x spec/test-repo ] && rm -rf spec/test-repo

(
  mkdir spec/test-repo
  cd spec/test-repo
  git init --quiet
  cat ../test-repo.gz | gunzip | git fast-import --quiet
  git checkout --quiet master
)