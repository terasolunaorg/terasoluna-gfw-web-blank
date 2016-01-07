#!/bin/sh

##-------------------------
## configurable params
##-------------------------
PROJECTNAME=$1
if [ "$PROJECTNAME" == "" ];then
    PROJECTNAME=`basename \`pwd\``
fi
JAVAVERSION=1.8

echo "PROJECTNAME=$PROJECTNAME"

##-------------------------
WEBINFLIB=src/main/webapp/WEB-INF/lib
LIBSRC=libsrc
TESTLIB=testlib
DOTCLASSPATH=.classpath
DOTPROJECT=.project
DOTSETTINGS=.settings
PREFS=$DOTSETTINGS/org.eclipse.jdt.core.prefs
COMPONENT=$DOTSETTINGS/org.eclipse.wst.common.component
FACET=$DOTSETTINGS/org.eclipse.wst.common.project.facet.core.xml
BUILDXML=build.xml

##-------------------------
## download jars
##-------------------------

download_jars() {
    rm -rf $WEBINFLIB $LIBSRC $TESTLIB
    mvn dependency:copy-dependencies -DoutputDirectory=$WEBINFLIB -DincludeScope=compile -DexcludeScope=provided -DexcludeTypes=pom
    mvn dependency:copy-dependencies -DoutputDirectory=$LIBSRC -DincludeScope=compile -DexcludeScope=provided -DexcludeTypes=pom -Dclassifier=sources
    mvn dependency:copy-dependencies -DoutputDirectory=$TESTLIB -DexcludeScope=compile -DexcludeTypes=pom
    mvn dependency:copy-dependencies -DoutputDirectory=$LIBSRC -DexcludeScope=compile -DexcludeTypes=pom -Dclassifier=sources
    echo $? > /dev/null
}

##-------------------------
## create .classpath
##-------------------------

create_dotclasspath() {
    ENTRIES=
    for f in `ls $WEBINFLIB`;do
        SRCNAME=`echo $f | sed -e s/.jar/-sources.jar/`
        ENTRIES=`cat <<__EOT__
$ENTRIES
    <classpathentry kind="lib"
        path="$WEBINFLIB/$f"
        sourcepath="$LIBSRC/$SRCNAME" />
__EOT__`
    done
    for f in `ls $TESTLIB`;do
        SRCNAME=`echo $f | sed -e s/.jar/-sources.jar/`
        ENTRIES=`cat <<__EOT__
$ENTRIES
    <classpathentry kind="lib"
        path="$TESTLIB/$f"
        sourcepath="$LIBSRC/$SRCNAME" />
__EOT__`
    done

    DOTCLASSPATH_CONTENT=`cat <<__EOT__
<?xml version="1.0" encoding="UTF-8"?>
<classpath>
    <classpathentry kind="src" output="target/classes"
        path="src/main/java">
        <attributes>
            <attribute name="optional" value="true" />
            <attribute name="maven.pomderived" value="true" />
        </attributes>
    </classpathentry>
    <classpathentry kind="src" output="target/classes" path="src/main/resources">
        <attributes>
            <attribute name="maven.pomderived" value="true"/>
        </attributes>
    </classpathentry>
    <classpathentry kind="src" output="target/test-classes"
        path="src/test/java">
        <attributes>
            <attribute name="optional" value="true" />
            <attribute name="maven.pomderived" value="true" />
        </attributes>
    </classpathentry>
    <classpathentry kind="src" output="target/classes" path="src/test/resources">
        <attributes>
            <attribute name="maven.pomderived" value="true"/>
        </attributes>
    </classpathentry>
    <classpathentry kind="con"
        path="org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-$JAVAVERSION">
        <attributes>
            <attribute name="maven.pomderived" value="true" />
        </attributes>
    </classpathentry>$ENTRIES
    <classpathentry kind="output" path="target/classes" />
</classpath>
__EOT__`


    echo "$DOTCLASSPATH_CONTENT" > $DOTCLASSPATH
}

##-------------------------
## create .project
##-------------------------

create_dotproject() {
    DOTPROJECT_CONTENT=`cat <<__EOT__
<?xml version="1.0" encoding="UTF-8"?>
<projectDescription>
    <name>$PROJECTNAME</name>
    <comment></comment>
    <projects>
    </projects>
    <buildSpec>
        <buildCommand>
            <name>org.eclipse.jdt.core.javabuilder</name>
            <arguments>
            </arguments>
        </buildCommand>
        <buildCommand>
            <name>org.eclipse.wst.common.project.facet.core.builder</name>
            <arguments>
            </arguments>
        </buildCommand>
        <buildCommand>
            <name>org.springframework.ide.eclipse.core.springbuilder</name>
            <arguments>
            </arguments>
        </buildCommand>
        <buildCommand>
            <name>org.eclipse.wst.jsdt.core.javascriptValidator</name>
            <arguments>
            </arguments>
        </buildCommand>
        <buildCommand>
            <name>org.eclipse.wst.validation.validationbuilder</name>
            <arguments>
            </arguments>
        </buildCommand>
    </buildSpec>
    <natures>
        <nature>org.springframework.ide.eclipse.core.springnature</nature>
        <nature>org.eclipse.jdt.core.javanature</nature>
        <nature>org.eclipse.wst.common.project.facet.core.nature</nature>
        <nature>org.eclipse.wst.common.modulecore.ModuleCoreNature</nature>
        <nature>org.eclipse.wst.jsdt.core.jsNature</nature>
    </natures>
</projectDescription>
__EOT__`
    echo "$DOTPROJECT_CONTENT" > $DOTPROJECT
}

##-------------------------
## create .settings
##-------------------------

create_settings() {
    rm -rf $DOTSETTINGS
    mkdir -p $DOTSETTINGS
}

##--------------------------------------------------
## create org.eclipse.jdt.core.prefs
##--------------------------------------------------

create_prefs() {
    CONTENT=`cat <<__EOT__
eclipse.preferences.version=1
org.eclipse.jdt.core.compiler.codegen.inlineJsrBytecode=enabled
org.eclipse.jdt.core.compiler.codegen.targetPlatform=$JAVAVERSION
org.eclipse.jdt.core.compiler.compliance=$JAVAVERSION
org.eclipse.jdt.core.compiler.problem.assertIdentifier=error
org.eclipse.jdt.core.compiler.problem.enumIdentifier=error
org.eclipse.jdt.core.compiler.source=$JAVAVERSION
__EOT__`
    echo "$CONTENT" > $PREFS
}

##--------------------------------------------------
## create org.eclipse.wst.common.component
##--------------------------------------------------

create_component() {
    CONTENT=`cat <<__EOT__
<?xml version="1.0" encoding="UTF-8"?><project-modules id="moduleCoreId" project-version="1.5.0">
    <wb-module deploy-name="$PROJECTNAME">
        <wb-resource deploy-path="/" source-path="/src/main/webapp" tag="defaultRootSource"/>
        <wb-resource deploy-path="/WEB-INF/classes" source-path="/src/main/java"/>
        <wb-resource deploy-path="/WEB-INF/classes" source-path="/src/main/resources"/>
        <wb-resource deploy-path="/WEB-INF/classes" source-path="/src/test/java"/>
        <wb-resource deploy-path="/WEB-INF/classes" source-path="/src/test/resources"/>
        <property name="context-root" value="$PROJECTNAME"/>
        <property name="java-output-path" value="/$PROJECTNAME/target/classes"/>
    </wb-module>
</project-modules>
__EOT__`
    echo "$CONTENT" > $COMPONENT
}

##--------------------------------------------------
## create org.eclipse.wst.common.project.facet.core.xml
##--------------------------------------------------

create_facet() {
    CONTENT=`cat <<__EOT__
<?xml version="1.0" encoding="UTF-8"?>
<faceted-project>
  <installed facet="java" version="$JAVAVERSION"/>
  <installed facet="jst.web" version="3.0"/>
  <installed facet="wst.jsdt.web" version="1.0"/>
</faceted-project>
__EOT__`
    echo "$CONTENT" > $FACET
}



##-------------------------
## create build.xml
##-------------------------

create_buildxml() {
    ENTRIES=
    for f in `ls $WEBINFLIB`;do
        ENTRIES=`cat <<__EOT__
$ENTRIES
    <pathelement location="\\${lib.dir}/$f"/>
__EOT__`
    done

    TESTENTRIES=
    for f in `ls $TESTLIB`;do
        TESTENTRIES=`cat <<__EOT__
$TESTENTRIES
    <pathelement location="\\${testlib.dir}/$f"/>
__EOT__`
    done

    CONTENT=`cat <<__EOT__
<?xml version="1.0" encoding="UTF-8"?>
<project name="$PROJECTNAME" default="package">
  <property name="maven.build.finalName" value="$PROJECTNAME"/>
  <property name="maven.build.dir" value="target"/>
  <property name="maven.build.outputDir" value="\\${maven.build.dir}/classes"/>
  <property name="maven.build.srcDir.0" value="src/main/java"/>
  <property name="maven.build.resourceDir.0" value="src/main/resources"/>
  <property name="maven.build.testOutputDir" value="\\${maven.build.dir}/test-classes"/>
  <property name="maven.build.testDir.0" value="src/test/java"/>
  <property name="maven.build.testResourceDir.0" value="src/test/resources"/>
  <property name="maven.test.reports" value="\\${maven.build.dir}/test-reports"/>
  <property name="maven.reporting.outputDirectory" value="\\${maven.build.dir}/site"/>
  <property name="lib.dir" value="$WEBINFLIB" />
  <property name="testlib.dir" value="$TESTLIB" />
  <path id="build.classpath">$ENTRIES
  </path>
  <path id="build.test.classpath">
    <path refid="build.classpath" />$TESTENTRIES
  </path>

  <!-- ====================================================================== -->
  <!-- Cleaning up target                                                     -->
  <!-- ====================================================================== -->

  <target name="clean" description="Clean the output directory">
    <delete dir="\\${maven.build.dir}"/>
  </target>

  <!-- ====================================================================== -->
  <!-- Compilation target                                                     -->
  <!-- ====================================================================== -->

  <target name="compile" description="Compile the code">
    <mkdir dir="\\${maven.build.outputDir}"/>
    <javac destdir="\\${maven.build.outputDir}" 
           nowarn="false" 
           debug="true" 
           optimize="false" 
           deprecation="true" 
           target="$JAVAVERSION" 
           verbose="false" 
           fork="false" 
           source="$JAVAVERSION">
      <src>
        <pathelement location="\\${maven.build.srcDir.0}"/>
      </src>
      <classpath refid="build.classpath"/>
    </javac>
    <copy todir="\\${maven.build.outputDir}">
      <fileset dir="\\${maven.build.resourceDir.0}"/>
    </copy>
  </target>

  <!-- ====================================================================== -->
  <!-- Test-compilation target                                                -->
  <!-- ====================================================================== -->

  <target name="compile-tests" 
          depends="compile" 
          description="Compile the test code" 
          unless="maven.test.skip">
    <mkdir dir="\\${maven.build.testOutputDir}"/>
    <javac destdir="\\${maven.build.testOutputDir}" 
           nowarn="false" 
           debug="true" 
           optimize="false" 
           deprecation="true" 
           target="$JAVAVERSION" 
           verbose="false" 
           fork="false" 
           source="$JAVAVERSION">
      <src>
        <pathelement location="\\${maven.build.testDir.0}"/>
      </src>
      <classpath>
        <path refid="build.test.classpath"/>
        <pathelement location="\\${maven.build.outputDir}"/>
      </classpath>
    </javac>
    <copy todir="\\${maven.build.testOutputDir}">
      <fileset dir="\\${maven.build.testResourceDir.0}"/>
    </copy>
  </target>

  <!-- ====================================================================== -->
  <!-- Run all tests                                                          -->
  <!-- ====================================================================== -->

  <target name="test" 
          depends="compile-tests" 
          unless="junit.skipped" 
          description="Run the test cases">
    <mkdir dir="\\${maven.test.reports}"/>
    <junit printSummary="yes" haltonerror="true" haltonfailure="true" fork="true" dir=".">
      <sysproperty key="basedir" value="."/>
      <formatter type="xml"/>
      <formatter type="plain" usefile="false"/>
      <classpath>
        <path refid="build.test.classpath"/>
        <pathelement location="\\${maven.build.outputDir}"/>
        <pathelement location="\\${maven.build.testOutputDir}"/>
      </classpath>
      <batchtest todir="\\${maven.test.reports}" unless="test">
        <fileset dir="\\${maven.build.testDir.0}">
          <include name="**/*Test.java"/>
          <exclude name="**/*Abstract*Test.java"/>
        </fileset>
      </batchtest>
      <batchtest todir="\\${maven.test.reports}" if="test">
        <fileset dir="\\${maven.build.testDir.0}">
          <include name="**/\\${test}.java"/>
          <exclude name="**/*Abstract*Test.java"/>
        </fileset>
      </batchtest>
    </junit>
  </target>

  <!-- ====================================================================== -->
  <!-- Package target                                                         -->
  <!-- ====================================================================== -->

  <target name="package" depends="compile,test" description="Package the application">
    <war destfile="\\${maven.build.dir}/\\${maven.build.finalName}.war" 
         compress="true" 
         webxml="src/main/webapp/WEB-INF/web.xml">
      <lib dir="\\${lib.dir}"/>
      <classes dir="\\${maven.build.outputDir}"/>
      <fileset dir="src/main/webapp" 
               excludes="WEB-INF/web.xml"/>
    </war>
  </target>

  <!-- ====================================================================== -->
  <!-- Javadoc target                                                         -->
  <!-- ====================================================================== -->

  <target name="javadoc" description="Generates the Javadoc of the application">
    <javadoc sourcepath="\\${maven.build.srcDir.0}" 
             packagenames="*" 
             destdir="\\${maven.reporting.outputDirectory}/apidocs" 
             access="protected" 
             old="false" 
             verbose="false" 
             version="true" 
             use="true" 
             author="true" 
             splitindex="false" 
             nodeprecated="false" 
             nodeprecatedlist="false" 
             notree="false" 
             noindex="false" 
             nohelp="false" 
             nonavbar="false" 
             serialwarn="false" 
             encoding="UTF-8" 
             charset="UTF-8" 
             linksource="false" 
             breakiterator="false"/>
  </target>

  <!-- ====================================================================== -->
  <!-- A dummy target for the package named after the type it creates         -->
  <!-- ====================================================================== -->

  <target name="war" depends="package" description="Builds the war for the application"/>
</project>

__EOT__`

    echo "$CONTENT" > $BUILDXML
}

##--------------------------------------------------
## run unmaven
##--------------------------------------------------

unmaven() {
    download_jars
    create_dotclasspath
    create_dotproject
    create_settings
    create_prefs
    create_component
    create_facet
    create_buildxml
    echo "done!"
}

unmaven