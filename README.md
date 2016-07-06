# miso-lims-docker

Docker container for [miso-lims](https://github.com/TGAC/miso-lims).

## Prerequisites

* Docker 1.9+
* Internet connection

## Build

To build any of the miso-lims containers, you first need to build the miso-base container:

    docker build -t miso-base -f miso-base .

And then you can build either the stable release:
 
    docker build -t miso-stable -f miso-stable .

Or build the latest from develop:

    docker build -t miso-develop -f miso-develop .


## Running

To run, launch the container with the appropriate ports open:

    sudo docker run -p 8090:8080 -d -t miso-stable

Navigate to http://localhost:8090 to login to miso with the credentials admin/admin.



