#!/bin/sh
rm -rf ./tmp
mkdir tmp
cp -r src pom.xml tmp
pushd tmp

# rename "projectName" in filename to replace by ${artifactId}
mv src/main/resources/META-INF/spring/projectName-domain.xml src/main/resources/META-INF/spring/__artifactId__-domain.xml
mv src/main/resources/META-INF/spring/projectName-infra.xml src/main/resources/META-INF/spring/__artifactId__-infra.xml
mv src/main/resources/META-INF/spring/projectName-env.xml src/main/resources/META-INF/spring/__artifactId__-env.xml
mv src/main/resources/META-INF/spring/projectName-infra.properties src/main/resources/META-INF/spring/__artifactId__-infra.properties


sed -i -e "s/org\.terasoluna\.gfw\.blank/xxxxxx.yyyyyy.zzzzzz/g" pom.xml
sed -i -e "s/terasoluna-gfw-web-blank/projectName/g" pom.xml

rm -rf `find . -name '.svn' -type d`
mvn archetype:create-from-project

pushd target/generated-sources/archetype

sed -i -e "s/xxxxxx\.yyyyyy\.zzzzzz/org.terasoluna.gfw.blank/g" pom.xml
sed -i -e "s/projectName/terasoluna-gfw-web-blank/g" pom.xml
mvn deploy
