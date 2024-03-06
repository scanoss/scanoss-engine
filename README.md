# SCANOSS Platform: Containerized Environment

The scanoss-engine repository offers a containerized environment, simplifying deployment with essential software components and dependencies encapsulated within a single Docker container. These components include:

- [LDB](https://github.com/scanoss/ldb)
- [Engine](https://github.com/scanoss/engine)
- [API](https://github.com/scanoss/api.go)

# Quick start

To initiate SCANOSS using our sample Knowledge Base [test-kb](https://github.com/scanoss/test-kb), follow these steps:

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
    - The API is configured to listen on port 8083. 
    - Please review the script for further reference.

3. Test your environment by running a scan request using the [Python CLI](https://github.com/scanoss/scanoss.py):

    From another terminal you can run a scan against the container. If the scan was successfull, you will receive the match output.
    
    ```sh
    scanoss-py scan --apiurl http://localhost:8083/api/scan/direct test-data/
    ```

# Customization

Customization options are available through scripts and configuration files found under the `scripts` folder:

- `app-config-prod.json`: API Configuration. See [api.go](https://github.com/scanoss/api.go) for reference
- `env-setup.sh`: Container-optimized API setup script.

# Building your own container image

Follow these steps if you want to build your own image. 

Pre-requisites:

- A Knowledge Base. You may reuse the example KB downloaded in the [Quick Start](#quick-start) section or mine your own components following the [minr guide](https://github.com/scanoss/minr) and the [test kb](https://github.com/scanoss/test-kb/blob/master/util/kb-mine.sh) mining script. Ensure sufficient disk storage for mining required components. 

Steps:

1. Clone this repository or download and extract the repository source package.

    ```sh
    git clone https://github.com/scanoss/scanoss-engine
    cd scanoss-engine/
    ```

2. Build the container image:

    To build the image, use the following command:

    ```sh
    docker build -t scanoss-engine .
    ```

    This command creates an image named "scanoss-engine".

3. Run a container:

    Once the image is built, run the container with all required components available out of the box.

    Replace `<LDB_DATA_DIR>` with a local directory containing the Knowledge Base in the Docker host.

    ```sh
      docker run --rm \
        -p 8083:8083 \
        -v <LDB_DATA_DIR>:/var/lib/ldb \
        -it scanoss-engine
    ```
    
    - The API is configured to listen on port 8083.
    
    - The SCANOSS engine looks for databases in `/var/lib/ldb/`. 
    
    - The configuration variable `ScanningURL` defines the base URL for the source file's URL present in the output response.

4. Test your environment:

    Once the container is running, query the API and run scans against the new Knowledge Base.

    To verify the installation, scan a component from the mining list using the Python CLI:

    ```sh
    
    scanoss-py scan --apiurl http://localhost:8083/api/scan/direct test-data/
    ```

    The scanning results will include matches to the mined component.


Note: The Docker image is based on amd64 binaries. On non-amd64 processors you need to pass the option: `--platform linux/amd64` to the `docker run` command to enable compatibility:

```sh
docker run --platform linux/amd64 ...
```

# License

The Scanoss Platform is entirely released under the GPL 2.0 license. Please check the LICENSE file for more information.

Copyright (C) 2018-2020 SCANOSS.COM
