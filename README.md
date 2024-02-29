# SCANOSS Engine

A containerized environment for the SCANOSS Platform

## Introduction

The SCANOSS Platform can be easily deployed as a Docker container, comprising essential software components and their dependencies:

- [LDB](https://github.com/scanoss/ldb)
- [Engine](https://github.com/scanoss/engine)
- [API](https://github.com/scanoss/api.gob)

## Quick Start

To initiate SCANOSS using the sample Knowledge Base [test-kb](https://github.com/scanoss/test-kb), follow these steps:

1. Clone this repository

    ```sh
    git clone https://github.com/scanoss/scanoss-engine
    ```

2.  Execute the `start.sh` script. This script pulls our test Knowledge Base (~40GB uncompressed) containing example components and starts the SCANOSS container. 
    
    ```sh
    cd scanoss-engine/
    ./start.sh
    ```
    
    Notes:
    - The example KB will be downloaded in the `./ldb` folder and the download will be skipped if the `ldb` folder exists. 
    - The API is configured to listen on port 5443. 
    - Please review the script for further reference.

3. Test your environment by running a scan request using the [Python CLI](https://github.com/scanoss/scanoss.py):

    ```sh
    curl -LO https://github.com/madler/zlib/raw/master/inflate.c
    scanoss-py scan --apiurl http://localhost:5443/api/scan/direct inflate.c 
    ```

    If the scan was successfull, you will receive the match output.

## Customization

Customization options are available through scripts and configuration files found under the `scripts` folder:

- `app-config-prod.json`: API Configuration
- `env-setup.sh`: Custom OS and API setup

## Usage Guide

1. Clone this repository or download and extract the repository source package.

    ```sh
    git clone https://github.com/scanoss/scanoss-engine
    cd scanoss-engine/
    ```

2. Pull (or build) the container image:

    To build the image, use the following command:

    ```sh
    docker build -t scanoss-engine .
    ```

    This command creates an image named "scanoss-engine".

3. Run a container:

    Once the image is built, run the container with all required components available out of the box.

    Ensure sufficient disk storage for mining required components. It's recommended to map volumes to the default destinations to reuse the generated Knowledge Base once built. Replace `<DATA_DIR>` with a local directory of the Docker host in the command below.

    ```sh
      docker run --rm \
        -e SCANOSS_API_URL=http://localhost:5443/api \
        -p 5443:5443 \
        -v <DATA_DIR>:/var/lib/ldb \
        -it scanoss-engine
    ```

    By default, the API is exposed at port 5443. The KB is internally located at `/var/lib/ldb/`. The environment variable `SCANOSS_API_URL` defines the base url for the source file url present in the output response.

4. Test your environment:

    Once the container is running and mining is completed, query the API and run scans against the new Knowledge Base.

    To verify the installation, scan a component from the mining list using the Python CLI:

    ```sh
    curl -LO https://github.com/madler/zlib/raw/master/inflate.c
    scanoss-py scan --apiurl http://localhost:5443/api/scan/direct inflate.c 
    ```

    The scanning results will include matches to the mined component.
