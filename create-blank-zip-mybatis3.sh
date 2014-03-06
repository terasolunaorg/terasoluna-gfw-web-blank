#!/bin/sh

#----------------------------------------
# change infra
#----------------------------------------
sh change-infra.sh MyBatis3

#----------------------------------------
# create zip
#----------------------------------------
sh create-blank-zip.sh

#----------------------------------------
# move to destination
#----------------------------------------
mv $FNAME*.zip $WORKSPACE/../../terasoluna-gfw-web-blank/workspace