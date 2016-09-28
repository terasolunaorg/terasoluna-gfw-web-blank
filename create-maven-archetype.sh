#!/bin/sh
rm -rf ./tmp
mkdir tmp
cp -r src pom.xml tmp
pushd tmp

# rename "projectName" in filename to replace by ${artifactId}
mv src/main/resources/META-INF/spring/projectName-domain.xml src/main/resources/META-INF/spring/__artifactId__-domain.xml
mv src/main/resources/META-INF/spring/projectName-infra.xml src/main/resources/META-INF/spring/__artifactId__-infra.xml
mv src/main/resources/META-INF/spring/projectName-codelist.xml src/main/resources/META-INF/spring/__artifactId__-codelist.xml

# if JPA or Mybatis2 is used
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


sed -i -e "s/org\.terasoluna\.gfw\.blank/xxxxxx.yyyyyy.zzzzzz/g" pom.xml
sed -i -e "s/terasoluna-gfw-web-blank/projectName/g" pom.xml

rm -rf `find . -name '.svn' -type d`
mvn archetype:create-from-project

pushd target/generated-sources/archetype

sed -i -e "s/xxxxxx\.yyyyyy\.zzzzzz/org.terasoluna.gfw.blank/g" pom.xml
sed -i -e "s/projectName/terasoluna-gfw-web-blank/g" pom.xml
mvn deploy
