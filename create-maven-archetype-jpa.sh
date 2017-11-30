#!/bin/sh
sh change-infra.sh JPA
sed -i -e "s/terasoluna-gfw-web-blank/terasoluna-gfw-web-blank-jpa/g" pom.xml
sed -i -e "s/terasoluna-gfw-web-blank/terasoluna-gfw-web-blank-jpa/g" create-maven-archetype.sh
sed -i -e "s/Web Blank Project/Web Blank Project (JPA)/g" pom.xml
sh create-maven-archetype.sh "$1" "$2"