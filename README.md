# miso-lims-docker

Base Docker container for [miso-lims](https://github.com/TGAC/miso-lims). This container is built from Tomcat 8.0 and installs MySQL 5.7, nginx, and a number of libraries that miso-lims needs. 

## Prerequisites

* Docker 1.9+
* Internet connection

## Build and Deploy

    docker build -t misolims/miso-base .


Once the container is built, push it to Docker Hub:

    docker login
    docker push misolims/miso-base


This image is used in the [miso-lims](https://github.com/TGAC/miso-lims) Dockerfile.

