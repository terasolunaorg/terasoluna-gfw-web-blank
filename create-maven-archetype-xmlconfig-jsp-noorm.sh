#!/bin/sh
CONFIG=XMLConfig
VIEW=JSP
ORM=NoORM
DEPLOY=$1
REPOSITORY=$2

sh create-maven-archetype.sh $CONFIG $VIEW $ORM "$DEPLOY" "$REPOSITORY"
