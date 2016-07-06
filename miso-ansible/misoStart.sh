#!/bin/bash
# Inspired by http://stackoverflow.com/questions/24265354/tomcat7-in-debianwheezy-docker-instance-fails-to-start

/etc/init.d/mysql start
/etc/init.d/tomcat8 start


# The container will run as long as the script is running, that's why
# we need something long-lived here
exec tail -f /var/log/tomcat8/catalina.out
