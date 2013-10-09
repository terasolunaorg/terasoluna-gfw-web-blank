#!/bin/sh

#----------------------------------------
# change infra
#----------------------------------------
sh change-infra.sh MyBatis2

#----------------------------------------
# create zip
#----------------------------------------
sh create-blank-zip.sh

#----------------------------------------
# move to destination
#----------------------------------------
mv $FNAME*.zip $WORKSPACE/../../terasoluna-gfw-web-blank/workspace