#!/bin/sh
set -e

CONFIG=JavaConfig
VIEW=JSP
ORM=JPA
DEPLOY=$1
REPOSITORY=$2

sh create-maven-archetype.sh $CONFIG $VIEW $ORM "$DEPLOY" "$REPOSITORY"
