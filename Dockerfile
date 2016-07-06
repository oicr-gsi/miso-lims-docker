FROM debian:jessie
#Make sure the install environment is clean
#install dependencies for ansible
RUN	apt-get -y -q update && apt-get -y clean &&\
	apt-get -y install 	\
	 git 			\
	 python-setuptools 	\
	 build-essential 	\
	 libssl-dev 		\
#	 libffi-dev 		\
	 python-dev
RUN     easy_install pip 
RUN     pip install 	\
	 paramiko 	\
	 PyYAML 	\
	 Jinja2 	\
	 httplib2 	\
	 six 		\
	 pycrypto

#clone ansible 2.1.0.0 (mysql in other versions is buggy)
RUN	git clone git://github.com/ansible/ansible.git --recursive &&\
	 cd ansible &&\
	 git checkout tags/v2.1.0.0-1 &&\
	 git submodule update --init

#Clone and install MISO 
RUN	git clone https://github.com/TGAC/miso-lims.git
RUN	apt-get -y clean && apt-get -y install 	\
	 openjdk-7-jdk 				\
	 maven
RUN	cd miso-lims &&\
	mvn package -P external


RUN	echo "INVALIDATOR"
COPY	miso-ansible/ /root/miso-ansible/ 
#/bin/sh is a symlink to /bin/dash, which does not support 'source' command
RUN	rm /bin/sh && ln -s /bin/bash /bin/sh
RUN	source /ansible/hacking/env-setup &&\
	 export ANSIBLE_INVENTORY=/root/miso-ansible/hosts &&\
	 ansible-playbook /root/miso-ansible/miso.yml

RUN	chmod +x /root/miso-ansible/misoStart.sh
EXPOSE	8080

CMD	["/root/miso-ansible/misoStart.sh"]

