# SCANOSS Docker Development Environment


## Introduction


The Complete SCANOSS Platform is deployable as a Docker container including the following components:


* LDB
* Minr
* Engine
* WAYUU
* API


Files included in the package:


* Dockerfile
* mining_commands.sh


The Dockerfile contains the installation of each component and adds a convenience script to run mining of requested components into the KB. 


The script mining_commands.sh file is added inside the Docker image.


ATTN: This setup is not supported nor recommended for production environments and should only be used for testing purposes.


## Installation guide


### 1) Clone this repository or download and extract the repository source package.


```sh
git clone https://github.com/scanoss/infra-test-docker
cd infra-test-docker/
```


### 2) Build the Docker image

In order to build the image, run the following command:


```sh
docker build -t scanoss .
```

An image named "scanoss" will be created.


### 3) Run the Docker container

Once your image is built, you can run the container with all required components available out of the box.


Please, verify you have sufficient disk storage to mine the required components. It’s recommended to map volumes to the default destinations to reuse the generated Knowledge Base once it is built. In the following command, replace <DATA_DIR> with a local directory of the Docker host.


```sh
sudo docker run --rm --name scanoss -v <DATA_DIR>:/var/lib/ldb/ -v <TMP_DIR>:/tmp -p 4443:4443 -d scanoss
```


By default, the API is exposed at the port 4443 and the KB is internally located at /var/lib/ldb/. Optionally, you may map the /tmp directory for debugging purposes by replacing <TMP_DIR>.


### 4) Run the mining process


Step into the running container and run the convenience script mining_commands.sh


a) Open a bash terminal into the container:

```sh
docker exec -ti scanoss bash
```


b) Run the mining script

```sh
./mining_command.sh
```

At this step, you may find messages indicating the files that are being ignored due to file size limits. 

```
File size out of bound: /dev/shm/minr-27/folder/item
```

### 5) Test your environment

When the container is up and running and mining is done, you will be able to query the API and run scans against the new Knowledge Base.


To verify the installation, you can grab a component from the mining list and run a scan using the Python CLI, as shown in the following example:


The scanning results will include matches to the mined component.
