#!/bin/sh
CONFIG=JavaConfig
VIEW=JSP
DB=NoDB
DEPLOY=$1
REPOSITORY=$2

sh create-maven-archetype.sh $CONFIG $VIEW $DB "$DEPLOY" "$REPOSITORY"