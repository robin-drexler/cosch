#!/bin/bash -e
echo "Going to deploy the joy. Buckle up."

GIT_REMOTE_URL=$1

# thanks http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ -z "$GIT_REMOTE_URL" ]; then
  echo "Missing git remote url. Aborting"
  exit 1
fi


# xxx there must be a better way
# why isn't even possible to call the script with ../../ in the first place?
ABSOLUTE_SCRIPT_PATH=$(cd "$DIR/../../bin/" && pwd)

"$ABSOLUTE_SCRIPT_PATH/cosch.rb" build

cd build
rm -rf .git
git init
git add .
git commit -m 'Deployment'
git push "$GIT_REMOTE_URL" master:gh-pages --force
rm -rf .git

echo "Deployment done"

