#!/bin/sh
sh change-infra.sh MyBatis2
sed -i -e "s/terasoluna-gfw-web-blank/terasoluna-gfw-web-blank-mybatis2/g" pom.xml
sed -i -e "s/terasoluna-gfw-web-blank/terasoluna-gfw-web-blank-mybatis2/g" create-maven-archetype.sh
sed -i -e "s/<description>Blank project using TERASOLUNA Global Framework/<description>Blank project using TERASOLUNA Global Framework (MyBatis2)/g" pom.xml
sh create-maven-archetype.sh