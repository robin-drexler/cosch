#!/bin/bash -e
echo "Going to deploy the joy. Buckle up."

GIT_REMOTE_URL=${GIT_REMOTE_URL:=$(git remote show -n origin | grep 'Push' | awk '{print $NF}')}


echo "Will push to: $GIT_REMOTE_URL gh-pages branch"
echo "ok? [y/n]"
read -e GO_FOR_IT


if [ "$GO_FOR_IT" != "y" ]; then
  echo "Aborting"
  exit 1
fi


ruby bin/build.rb
cd build
rm -rf .git
git init
git add .
git commit -m 'Deployment'
git push "$GIT_REMOTE_URL" master:gh-pages --force
rm -rf .git

