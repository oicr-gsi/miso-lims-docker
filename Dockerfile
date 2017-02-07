FROM debian:jessie

ENV DEPS="\
            python  \
            tomcat8 \
            nginx   \
            openjdk-7-jre \
            python-lxml \
            python-mysqldb" 


ENV BUILD_PKGS="\
            git                    \
            python-setuptools      \
            build-essential        \
            libssl-dev             \
            python-dev             \
            ca-certificates "

ENV TO_REMOVE="binutils build-essential bzip2 ca-certificates cpp cpp-4.9 dpkg-dev g++ \
  g++-4.9 gcc gcc-4.9 libasan1 libatomic1 libc-dev-bin libc6-dev libcilkrts5 \
  libcloog-isl4 libdpkg-perl libexpat1 libexpat1-dev libffi6 libgcc-4.9-dev \
  libgdbm3 libgmp10 libgomp1 libisl10 libitm1 liblsan0 libmpc3 libmpfr4 \
  libpython-dev libpython-stdlib libpython2.7 libpython2.7-dev \
  libpython2.7-minimal libpython2.7-stdlib libquadmath0 libsqlite3-0 \
  libssl-dev libssl1.0.0 libstdc++-4.9-dev libtimedate-perl libtsan0 libubsan0 \
  linux-libc-dev make mime-support openssl patch perl perl-modules python \
  python-dev python-minimal python-pkg-resources python-setuptools python2.7 \
  python2.7-dev python2.7-minimal xz-utils zlib1g-dev cpp g++ gcc perl perl-modules"

#install dependencies for ansible
#/bin/sh is a symlink to /bin/dash, which does not support 'source' command
RUN     rm /bin/sh && ln -s /bin/bash /bin/sh           &&\
        apt-get -y -q update                            &&\
        apt-get -y -q --no-install-recommends install   \
            $BUILD_PKGS                                 &&\
        easy_install pip                                &&\
        pip install         \
            paramiko        \
            PyYAML          \
            Jinja2          \
            httplib2        \
            six             \
            pycrypto                                    &&\
        git clone git://github.com/ansible/ansible.git --branch v2.1.0.0-1 --recursive --depth 1 /ansible &&\
        rm -r /ansible/test /ansible/docsite                         &&\ 
        apt-get purge --auto-remove -q -y $BUILD_PKGS $TO_REMOVE      &&\
        apt-get -y -q --no-install-recommends install           \
            $DEPS						&&\ 
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#copy the local files for ansible and startup to the container
COPY    . /root/

# Debian doesn't have mysql 5.7 by default, so add the repo and then proceed with
# the installation
RUN	apt-key add /root/miso-ansible/mysql-sig-key.gpg &&\
	echo "deb http://repo.mysql.com/apt/debian/ jessie mysql-5.7" > /etc/apt/sources.list.d/mysql.list &&\
	echo "deb http://repo.mysql.com/apt/debian/ jessie connector-python-2.0" >> /etc/apt/sources.list.d/mysql.list &&\
	apt-get -y -q update &&\
        source /ansible/hacking/env-setup                       &&\
        export ANSIBLE_INVENTORY=/root/miso-ansible/hosts       &&\
        ansible-playbook /root/miso-ansible/miso.yml            &&\
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*           &&\
        chmod +x /root/miso-ansible/misoStart.sh

EXPOSE  8080

CMD ["/bin/bash"]
