#!/bin/sh
rm -rf ./tmp
mkdir tmp
cp -r src pom.xml tmp
pushd tmp

# rename "projectName" in filename to replace by ${artifactId}
mv src/main/resources/META-INF/spring/projectName-domain.xml src/main/resources/META-INF/spring/__artifactId__-domain.xml
mv src/main/resources/META-INF/spring/projectName-infra.xml src/main/resources/META-INF/spring/__artifactId__-infra.xml
mv src/main/resources/META-INF/spring/projectName-codelist.xml src/main/resources/META-INF/spring/__artifactId__-codelist.xml

# if JPA or Mybatis3 is used
if [ -e src/main/resources/META-INF/spring/projectName-env.xml ];then
  mv src/main/resources/META-INF/spring/projectName-env.xml src/main/resources/META-INF/spring/__artifactId__-env.xml

  # add database dependency info
  LF=$(printf '\\\012_')
  LF=${LF%_}

  REPLACEMENT_TAG="        <\!-- \=\= Begin Database \=\= -->${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}<\!--         <dependency> -->${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}<\!--             <groupId>org.postgresql<\/groupId> -->${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}<\!--             <artifactId>postgresql<\/artifactId> -->${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}<\!--             <version>\$\{postgresql.version\}<\/version> -->${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}<\!--         </dependency> -->${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}<\!--         <dependency> -->${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}<\!--             <groupId>com.oracle<\/groupId> -->${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}<\!--             <artifactId>ojdbc7<\/artifactId> -->${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}<\!--             <version>\$\{ojdbc.version\}<\/version> -->${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}<\!--         <\/dependency> -->${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}        <\!-- \=\= End Database \=\= -->${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}    <\/dependencies>"

  sed -i -e "s/    <\/dependencies>/${REPLACEMENT_TAG}/" pom.xml

  REPLACEMENT_TAG="        <postgresql.version>9.4-1206-jdbc41<\/postgresql.version>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}        <ojdbc.version>12.1.0.2<\/ojdbc.version>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}        <selenium.version>2.46.0<\/selenium.version>"

  sed -i -e "s/        <selenium.version>2.46.0<\/selenium.version>/${REPLACEMENT_TAG}/" pom.xml

fi
if [ -e src/main/resources/META-INF/spring/projectName-infra.properties ];then
  mv src/main/resources/META-INF/spring/projectName-infra.properties src/main/resources/META-INF/spring/__artifactId__-infra.properties
fi

if [ -d src/main/resources/xxxxxx ];then
  echo "rename to __packageInPathFormat__"
  mkdir -p src/main/resources/__packageInPathFormat__
  mv src/main/resources/xxxxxx/yyyyyy/zzzzzz/domain src/main/resources/__packageInPathFormat__/
  rm -rf src/main/resources/xxxxxx
fi

sed -i -e "s/org\.terasoluna\.gfw\.blank/xxxxxx.yyyyyy.zzzzzz/g" pom.xml
sed -i -e "s/terasoluna-gfw-web-blank/projectName/g" pom.xml

rm -rf `find . -name '.svn' -type d`

if [ "$1" = "central" ]; then
  PROFILE="-P central"
fi
mvn archetype:create-from-project ${PROFILE}

pushd target/generated-sources/archetype

sed -i -e "s/xxxxxx\.yyyyyy\.zzzzzz/org.terasoluna.gfw.blank/g" pom.xml
sed -i -e "s/projectName/terasoluna-gfw-web-blank/g" pom.xml

if [ "$1" = "central" ]; then
  # add plugins to deploy to Maven Central Repository
  LF=$(printf '\\\012_')
  LF=${LF%_}
  
  REPLACEMENT_TAG="    <plugins>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}      <plugin>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}        <groupId>org.sonatype.plugins<\/groupId>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}        <artifactId>nexus-staging-maven-plugin<\/artifactId>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}        <version>1.6.7<\/version>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}        <extensions>true<\/extensions>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}        <configuration>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}          <serverId>ossrh<\/serverId>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}          <nexusUrl>https:\/\/oss.sonatype.org\/<\/nexusUrl>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}          <autoReleaseAfterClose>true<\/autoReleaseAfterClose>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}        <\/configuration>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}      <\/plugin>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}      <plugin>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}        <groupId>org.apache.maven.plugins<\/groupId>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}        <artifactId>maven-gpg-plugin<\/artifactId>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}        <version>1.6<\/version>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}        <executions>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}          <execution>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}            <id>sign-artifacts<\/id>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}            <phase>verify<\/phase>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}            <goals>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}              <goal>sign<\/goal>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}            <\/goals>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}          <\/execution>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}        <\/executions>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}      <\/plugin>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}    <\/plugins>${LF}"
  REPLACEMENT_TAG="${REPLACEMENT_TAG}  <\/build>"
  
  sed -i -e "s/  <\/build>/${REPLACEMENT_TAG}/" pom.xml
fi
mvn deploy

popd
popd
