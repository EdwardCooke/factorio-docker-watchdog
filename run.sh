#!/bin/bash

echo "Org: $GIT_ORG"
echo "Repo: $GIT_REPO"
echo "Branch: $GIT_BRANCH"
echo "SSH File: $GIT_SSHFILE"
echo "Force: $FORCE"

[ -z $GIT_ORG ] && echo "GIT_ORG environment variable must be set." && exit 1
[ -z $GIT_REPO ] && echo "GIT_REPO environment variable must be set." && exit 1
[ -z $GIT_BRANCH ] && echo "GIT_BRANCH environment variable must be set." && exit 1
[ -z $GIT_SSHFILE ] && echo "GIT_SSH environment variable must be set to a valid ssh key." && exit 1

JSON=`curl https://www.factorio.com/updater/get-available-versions?apiVersion=2`
VERSION=`echo $JSON | jq '.[][] | select(.stable != null) .stable' -r`
[ -z $VERSION ] && echo "Unable to determine latest stable version from https://www.factorio.com/updater/get-available-versions?apiVersion=2" && exit 1
echo "Current stable: $VERSION"

LASTBUILT=`curl https://raw.githubusercontent.com/$GIT_ORG/$GIT_REPO/$GIT_BRANCH/currentversion`
[ -z $LASTBUILT ] && echo "Unable to get last built version from https://raw.githubusercontent.com/$GIT_ORG/$GIT_REPO/$GIT_BRANCH/currentversion." && exit 1;
echo "Last built: $LASTBUILT"

if [ "$LASTBUILT" != "$VERSION" || "$FORCE" != "" ]
then
    echo "Version mismatch, publishing new version"
    echo "Configuring ssh"
    [ "$DOCKER" == "1" ] && mkdir -p ~/.ssh
    [ "$DOCKER" == "1" ] && cat <<EOF > ~/.ssh/config && chmod 600 ~/.ssh/config
Host github.com
    User git
    StrictHostKeyChecking no
    IdentityFile $GIT_SSH
EOF
    export GIT_SSH=./myssh.sh

    git clone git@github.com:$GIT_ORG/$GIT_REPO.git $GIT_REPO
    cd $GIT_REPO
    git checkout $GIT_BRANCH
    echo $VERSION > currentversion
    date > builddate
    git add -A
    git commit -m "Version bump to $VERSION"

    #git push origin $GIT_BRANCH
    cd ..
    #rm -rf $GIT_REPO
fi