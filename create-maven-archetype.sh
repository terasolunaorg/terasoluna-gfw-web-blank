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

if [ -d src/main/resources/xxxxxx ];then
  echo "rename to __packageInPathFormat__"
  mkdir -p src/main/resources/__packageInPathFormat__
  mv src/main/resources/xxxxxx/yyyyyy/zzzzzz/domain src/main/resources/__packageInPathFormat__/
  rm -rf src/main/resources/xxxxxx
fi

sed -i -e "s/org\.terasoluna\.gfw\.blank/xxxxxx.yyyyyy.zzzzzz/g" pom.xml
sed -i -e "s/terasoluna-gfw-web-blank/projectName/g" pom.xml

rm -rf `find . -name '.svn' -type d`

if [ $1 = "central" ]; then
  profile="-P central"
fi
mvn archetype:create-from-project ${profile}

pushd target/generated-sources/archetype

sed -i -e "s/xxxxxx\.yyyyyy\.zzzzzz/org.terasoluna.gfw.blank/g" pom.xml
sed -i -e "s/projectName/terasoluna-gfw-web-blank/g" pom.xml

if [ $1 = "central" ]; then
  # add plugins to deploy to Maven Central Repository
  LF=$(printf '\\\012_')
  LF=${LF%_}
  
  TAG_FEATURE_MANAGER="    <plugins>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}      <plugin>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}        <groupId>org.sonatype.plugins<\/groupId>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}        <artifactId>nexus-staging-maven-plugin<\/artifactId>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}        <version>1.6.7<\/version>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}        <extensions>true<\/extensions>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}        <configuration>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}          <serverId>ossrh<\/serverId>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}          <nexusUrl>https:\/\/oss.sonatype.org\/<\/nexusUrl>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}          <autoReleaseAfterClose>true<\/autoReleaseAfterClose>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}        <\/configuration>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}      <\/plugin>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}      <plugin>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}        <groupId>org.apache.maven.plugins<\/groupId>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}        <artifactId>maven-gpg-plugin<\/artifactId>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}        <version>1.6<\/version>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}        <executions>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}          <execution>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}            <id>sign-artifacts<\/id>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}            <phase>verify<\/phase>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}            <goals>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}              <goal>sign<\/goal>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}            <\/goals>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}          <\/execution>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}        <\/executions>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}      <\/plugin>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}    <\/plugins>${LF}"
  TAG_FEATURE_MANAGER="${TAG_FEATURE_MANAGER}  <\/build>"
  
  sed -i -e "s/  <\/build>/${TAG_FEATURE_MANAGER}/" pom.xml
fi
mvn deploy

popd
popd
