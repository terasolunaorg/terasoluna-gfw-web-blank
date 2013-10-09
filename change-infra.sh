#!/bin/sh
MODE=$1
KEYWORD="REMOVE THIS LINE IF YOU USE $1"
TARGET="src pom.xml"
DIRNAME=`echo $MODE | tr "[:upper:]" "[:lower:]"`

echo "change to $MODE"

mkdir tmp
cp -r infra/$DIRNAME/* tmp/
cp -r infra/common/* tmp/
rm -rf `/bin/find tmp -name '.svn' -type d `

echo "copy infra/$DIRNAME to src/main/resources"
cp -rf tmp/* src/main/resources
rm -rf tmp


sed -i -e "/$KEYWORD/d" `grep -rIl "$1" $TARGET | grep -v '.svn'`
