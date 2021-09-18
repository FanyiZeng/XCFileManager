#!/bin/bash

repoName=XCFileManager

git stash
git pull origin master --tags
git stash pop

VersionString=`grep -E 's.version.*=' ${repoName}.podspec`
VersionNumber=`tr -cd 0-9 <<<"$VersionString"`
NewVersionNumber=$(($VersionNumber + 1))
LineNumber=`grep -nE 's.version.*=' ${repoName}.podspec | cut -d : -f1`

git add .
git commit -am modification
git pull origin master --tags

sed -i "" "${LineNumber}s/${VersionNumber}/${NewVersionNumber}/g" ${repoName}.podspec

echo "current version is ${VersionNumber}, new version is ${NewVersionNumber}"

git commit -am ${NewVersionNumber}
git tag ${NewVersionNumber}
git push origin master --tags
pod trunk push ./${repoName}.podspec --verbose --use-libraries --allow-warnings
