#!/bin/sh

# export DIRNAME=`dirname \`pwd\``-`date '+%Y%m%d'`
export DIRNAME=`dirname \`pwd\``-$VERSION
export FNAME=`basename $DIRNAME`
export FNAME_D=$FNAME-with-dependencies

#----------------------------------------
# remove metafiles
#----------------------------------------
rm -rf `find . -type d -name .svn`
rm -rf `find . -type d -name .git`
rm -f `find . -type f -name .gitkeep`
rm -f `find . -type f -name .gitignore`

#----------------------------------------
# create directory to make zip for maven project
#----------------------------------------
rm -rf $FNAME
mkdir -p $FNAME
cp -r src pom.xml $FNAME/
zip -r $FNAME.zip $FNAME

#----------------------------------------
# maven project -> WTP project with dependencies
#----------------------------------------
rm -rf $FNAME_D
mkdir -p $FNAME_D
cp -r src pom.xml *.sh $FNAME_D/
pushd $FNAME_D
  sh unmaven-project.sh $JOB_NAME
  rm -f *.sh
popd
zip -r $FNAME_D.zip $FNAME_D

#----------------------------------------
# remove trash
#----------------------------------------
rm -rf *.sh *.xml src infra
rm -rf $FNAME $FNAME_D
