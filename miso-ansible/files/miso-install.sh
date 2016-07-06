#!/bin/bash

set -e 

MISO_VERSION=$1
MISO_DB_USER="$(xmlstarlet sel -t -v '//Resource[@name="jdbc/MISODB"]/@username' /etc/tomcat8/Catalina/localhost/ROOT.xml)"
MISO_DB_PASS="$(xmlstarlet sel -t -v '//Resource[@name="jdbc/MISODB"]/@password' /etc/tomcat8/Catalina/localhost/ROOT.xml)"
MISO_DB_URL="$(xmlstarlet sel -T -t -v '//Resource[@name="jdbc/MISODB"]/@url' /etc/tomcat8/Catalina/localhost/ROOT.xml)"
FLYWAY=flyway
cd ${FLYWAY}
rm -f lib/sqlstore-*.jar
unzip -xjo /var/lib/tomcat8/webapps/ROOT.war 'WEB-INF/lib/sqlstore-*.jar' -d lib
/etc/init.d/mysql start
./flyway -user=$MISO_DB_USER -password=$MISO_DB_PASS -url=$MISO_DB_URL -outOfOrder=true -locations=classpath:db/migration migrate
