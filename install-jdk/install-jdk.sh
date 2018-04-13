#!/bin/bash

JDK_NAME=jdk-8u161-linux-x64.tar.gz

JDK_DIR=/usr/local/java

if [ ! -d "$JDK_DIR" ]
then
 echo "mkdir $JDK_DIR"
 mkdir $JDK_DIR
fi

cd $JDK_DIR

# download jdk
if [ ! -f "$JDK_NAME" ]
then
  wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie;" http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz 
fi


#extract jdk
tar -zxvf $JDK_NAME

# rename jdk
mv jdk1.* jdk8

#set java environment
#if ! grep "JAVA_HOME=/usr/local/java/jdk1.8.0_131" /etc/profile
echo "#set java environment" >> /etc/profile
echo "export JAVA_HOME=/usr/local/java/jdk8" >> /etc/profile
echo "export JRE_HOME=/usr/local/java/jdk8/jre/" >> /etc/profile
echo "export CLASSPATH=.:\$CLASSPATH:\$JAVA_HOME/lib:\$JRE_HOME/lib" >> /etc/profile
echo "export PATH=\$PATH:\$JAVA_HOME/bin:\$JRE_HOME/bin" >> /etc/profile

su root
source /etc/profile

java -version



