FROM alpine:latest

ARG LOCAL_REPO
ARG JAVA_PACKAGE
ARG JAVA_VERSION
ARG JAVA_VERSION_BUILD
ARG MAVEN_VERSION

RUN wget -O - http://${LOCAL_REPO}/install/alpine/glibc.sh | sh -s

RUN	wget -O - http://${LOCAL_REPO}/install/java/oracle/jdk.sh | \
		JAVA_PACKAGE=${JAVA_PACKAGE} \
		JAVA_VERSION=${JAVA_VERSION} \
		JAVA_VERSION_BUILD=${JAVA_VERSION_BUILD} sh -s 

RUN wget -O - http://${LOCAL_REPO}/install/apache/maven.sh | \
		MAVEN_VERSION=${MAVEN_VERSION} sh -s



