#!/bin/sh
sh change-infra.sh JPA
sed -i -e "s/terasoluna-gfw-web-blank/terasoluna-gfw-web-blank-jpa/g" pom.xml
sed -i -e "s/terasoluna-gfw-web-blank/terasoluna-gfw-web-blank-jpa/g" create-maven-archetype.sh
sed -i -e "s/<description>Blank project using TERASOLUNA Global Framework/<description>Blank project using TERASOLUNA Global Framework (JPA)/g" pom.xml
sh create-maven-archetype.sh