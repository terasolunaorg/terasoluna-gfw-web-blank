# TERASOLUNA Server Framework for Java 5.x Blank Project

This is blank project template for web application is provided in collaboration with TERASOLUNA Server Framework for Java 5.x (Spring MVC + Spring + MyBatis3/JPA).

Use this as the starting point of all kinds of development activities. 

This blank project can be be beneficial in following ways. 

1. The **most standard and ideal baseline configuration and structure** to all the development activities.
2. Quickly jump to focus on business application.

## Getting Started

There are two ways to get started. Download or use maven archetype to let it download and setup the project for you.

### Use maven archetype

Quickly create your blank project using maven archetype of TERASOLUNA Server Framework for Java 5.x.
Execute `mvn archetype:generate -DarchetypeCatalog=http://repo.terasoluna.org/nexus/content/repositories/terasoluna-gfw-releases <options>`.


#### a blank project without any DB configuration

To create a plain blank project

##### for CommandPrompt
```
mvn archetype:generate^
 -DarchetypeCatalog=http://repo.terasoluna.org/nexus/content/repositories/terasoluna-gfw-releases^
 -DarchetypeGroupId=org.terasoluna.gfw.blank^
 -DarchetypeArtifactId=terasoluna-gfw-web-blank-archetype^
 -DarchetypeVersion=5.0.0.RELEASE
```

##### for Bash

```
mvn archetype:generate\
 -DarchetypeCatalog=http://repo.terasoluna.org/nexus/content/repositories/terasoluna-gfw-releases\
 -DarchetypeGroupId=org.terasoluna.gfw.blank\
 -DarchetypeArtifactId=terasoluna-gfw-web-blank-archetype\
 -DarchetypeVersion=5.0.0.RELEASE
```

#### a blank project with MyBatis3

To create a blank project with MyBatis3

##### for CommandPrompt
```
mvn archetype:generate^
 -DarchetypeCatalog=http://repo.terasoluna.org/nexus/content/repositories/terasoluna-gfw-releases^
 -DarchetypeGroupId=org.terasoluna.gfw.blank^
 -DarchetypeArtifactId=terasoluna-gfw-web-blank-mybatis3-archetype^
 -DarchetypeVersion=5.0.0.RELEASE
```

##### for Bash

```
mvn archetype:generate\
 -DarchetypeCatalog=http://repo.terasoluna.org/nexus/content/repositories/terasoluna-gfw-releases\
 -DarchetypeGroupId=org.terasoluna.gfw.blank\
 -DarchetypeArtifactId=terasoluna-gfw-web-blank-mybatis3-archetype\
 -DarchetypeVersion=5.0.0.RELEASE
```

#### a blank project with JPA (Spring Data JPA)

To create a blank project with JPA (Spring Data JPA)

##### for CommandPrompt
```
mvn archetype:generate^
 -DarchetypeCatalog=http://repo.terasoluna.org/nexus/content/repositories/terasoluna-gfw-releases^
 -DarchetypeGroupId=org.terasoluna.gfw.blank^
 -DarchetypeArtifactId=terasoluna-gfw-web-blank-jpa-archetype^
 -DarchetypeVersion=5.0.0.RELEASE
```

##### for Bash

```
mvn archetype:generate\
 -DarchetypeCatalog=http://repo.terasoluna.org/nexus/content/repositories/terasoluna-gfw-releases\
 -DarchetypeGroupId=org.terasoluna.gfw.blank\
 -DarchetypeArtifactId=terasoluna-gfw-web-blank-jpa-archetype\
 -DarchetypeVersion=5.0.0.RELEASE
```

### Download
If you don't want to use maven archetype, download manually from the following link.

[https://github.com/terasolunaorg/terasoluna-gfw-web-blank/releases](https://github.com/terasolunaorg/terasoluna-gfw-web-blank/releases)

There are two type of downloads available.

1. Project that includes settings related to WTP of Eclipse and dependency libraries (jar files).
2. Maven project which does not include jar files. 

When downloaded manually, following points needs to be taken care of separately.

1. groupId is **xxxxxx.yyyyyy.zzzzzz**.
2. artifactId is **projectName**. Accordingly, all the configuration filenames have **projectName** as prefix.

The above two points need to be modified manually as per the requirements. 

## Run

In order to run the blank project, execute the below command. (This command starts the embedded tomcat server. Hence check whether any other instance of Tomcat is not running on your local machine)

    $ cd <your artifaceId>
    $ mvn tomcat7:run
    
Access the following to confirm.

    http://localhost:8080/<your artifactId\>

