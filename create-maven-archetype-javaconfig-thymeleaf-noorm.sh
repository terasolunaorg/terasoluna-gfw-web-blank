set -e
#!/bin/sh
CONFIG=JavaConfig
VIEW=Thymeleaf
ORM=NoORM
DEPLOY=$1
REPOSITORY=$2

sh create-maven-archetype.sh $CONFIG $VIEW $ORM "$DEPLOY" "$REPOSITORY"