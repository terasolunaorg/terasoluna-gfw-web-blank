#!/bin/sh
sh change-infra.sh MyBatis3
sed -i -e "s/terasoluna-gfw-web-blank/terasoluna-gfw-web-blank-mybatis3/g" pom.xml
sed -i -e "s/terasoluna-gfw-web-blank/terasoluna-gfw-web-blank-mybatis3/g" create-maven-archetype.sh
sed -i -e "s/<description>Blank project using TERASOLUNA Global Framework/<description>Blank project using TERASOLUNA Global Framework (MyBatis3)/g" pom.xml
sh create-maven-archetype.sh