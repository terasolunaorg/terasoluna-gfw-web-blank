#!/bin/bash

####################################################
# Shell to apply after project generation.
# Distribute additional test files.
#
# The parameters of this script are as follows.
# $1:Generated blank project path
####################################################

set -e
cd $(dirname $0)
WORK_DIR=$1
PROJECT_NAME=$(basename "${WORK_DIR}")

echo ">>>>> ARGS CHECK"

if [ ! -n "${WORK_DIR}" ]; then
    echo "[Error] Destination directory not specified."
    exit -100
fi

if [ ! -d "${WORK_DIR}" ]; then
    echo "[Error] Destination directory does not exist."
    exit -101
fi

if [ ! -d "${WORK_DIR}/src" ]; then
    echo "[Error] It's not a single-project configuration."
    exit -102
fi

if [ -e "${WORK_DIR}/src/main/resources/META-INF/spring/applicationContext.xml" ]; then
    CONFIG_TYPE="XMLConfig"
else
    CONFIG_TYPE="JavaConfig"
fi

if [ -e "${WORK_DIR}/src/main/webapp/WEB-INF/views/welcome/home.jsp" ]; then
    VIEW_TYPE="JSP"
else
    VIEW_TYPE="Thymeleaf"
fi

APP_PATH=$(find "${WORK_DIR}" -name HelloController.java)
PACKAGE_DIR=$(dirname "$APP_PATH")
PACKAGE_DIR=${PACKAGE_DIR#*/java/}
PACKAGE_DIR=${PACKAGE_DIR%/app/*}
PACKAGE_NAME=${PACKAGE_DIR//\//.}

echo "#####<Parameter>#####"
echo "WORK_DIR=${WORK_DIR}"
echo "CONFIG_TYPE=${CONFIG_TYPE}"
echo "VIEW_TYPE=${VIEW_TYPE}"
echo "PROJECT_NAME=${PROJECT_NAME}"
echo "PACKAGE_NAME=${PACKAGE_NAME}"
echo "#####################"

echo ">>>>> CREATE TMP"
rm -fr ./tmp
mkdir -p ./tmp/${PROJECT_NAME}

echo ">>>>> COPY PARTS"
cp -fr ./parts/base/projectName-*/src ./tmp/${PROJECT_NAME}
cp -fr ./parts/${CONFIG_TYPE}/projectName-*/src ./tmp/${PROJECT_NAME}
cp -fr ./parts/${VIEW_TYPE}/projectName-*/src ./tmp/${PROJECT_NAME}

echo ">>>>> CHANGE PACKAGE"
mkdir -p ./tmp/${PROJECT_NAME}/src/main/java/${PACKAGE_DIR}
mkdir -p ./tmp/${PROJECT_NAME}/src/test/java/${PACKAGE_DIR}

mv ./tmp/${PROJECT_NAME}/src/main/java/xxxxxx/yyyyyy/zzzzzz/* ./tmp/${PROJECT_NAME}/src/main/java/${PACKAGE_DIR}/
mv ./tmp/${PROJECT_NAME}/src/test/java/xxxxxx/yyyyyy/zzzzzz/* ./tmp/${PROJECT_NAME}/src/test/java/${PACKAGE_DIR}/
rm -fr ./tmp/${PROJECT_NAME}/src/*/java/xxxxxx

find ./tmp/${PROJECT_NAME} -type f | xargs sed -i -e "s/xxxxxx\.yyyyyy\.zzzzzz/${PACKAGE_NAME}/g"

echo ">>>>> RENAME PROJECT NAME"

find ./tmp/${PROJECT_NAME} -type f | xargs sed -i -e "s/projectName-web/${PROJECT_NAME}/g"

echo ">>>>> ADD DEPENDENCIES"
cp -f ${WORK_DIR}/pom.xml ./tmp/${PROJECT_NAME}

LF=$(printf '\\\012_')
LF=${LF%_}
DEPENDENCIES_TAG="<dependency>${LF}"
DEPENDENCIES_TAG="${DEPENDENCIES_TAG}            <groupId>org.springframework.security<\/groupId>${LF}"
DEPENDENCIES_TAG="${DEPENDENCIES_TAG}            <artifactId>spring-security-test<\/artifactId>${LF}"
DEPENDENCIES_TAG="${DEPENDENCIES_TAG}            <scope>test<\/scope>${LF}"
DEPENDENCIES_TAG="${DEPENDENCIES_TAG}        <\/dependency>${LF}"
DEPENDENCIES_TAG="${DEPENDENCIES_TAG}        <!-- == End Unit Test == -->"

sed -i -e "s/<!-- == End Unit Test == -->/${DEPENDENCIES_TAG}/" ./tmp/${PROJECT_NAME}/pom.xml

echo ">>>>> COPY TMP"
cp -fr ./tmp/${PROJECT_NAME}/* ${WORK_DIR}

echo ">>>>> END"

exit 0
