#!/bin/bash -e
echo "Going to deploy the joy. Buckle up."

GIT_REMOTE_URL=$1

if [ -z "$GIT_REMOTE_URL" ]; then
  echo "Missing git remote url. Aborting"
  exit 1
fi

ruby bin/build.rb build
cd build
rm -rf .git
git init
git add .
git commit -m 'Deployment'
git push "$GIT_REMOTE_URL" master:gh-pages --force
rm -rf .git

echo "Deployment done"

