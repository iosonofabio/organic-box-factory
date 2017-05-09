[![Build Status](https://travis-ci.org/iosonofabio/quakelab-containers.svg?branch=metagenomics)](https://travis-ci.org/iosonofabio/quakelab-containers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# quakelab-containers: metagenomics
This repository allows you to build a Docker image **and** a singularity image for the metagenomics pipeline.

## How to use this repo
If you are a user that would like to run the pipeline without bothering about operating systems, clusters, et al., just install the image and run it (see below). If you are a developer searching for working examples of this pipeline, including the continuous integration and deployment to docker-hub and singularity-hub, clone the repo and start coding away from the `Dockerfile` and `.travis.yml`!

## Image istallation
The current images are hosted here:

 - [Docker](https://hub.docker.com/r/iosonofabio/quakelab-containers/): `docker pull iosonofabio/quakelab-containers:metagenomics`
 - [Singularity](https://singularity-hub.org/collections/141/): `singularity pull shub://iosonofabio/quakelab-containers:metagenomics`

**NOTE**: you may need a development version of singularity to use the command `pull`.

## Usage

 - Docker: `docker run -v $(pwd)/projectdata:/data/projectdata --name imagename --rm iosonofabio/quakelab-containers:metagenomics pipeline --help`
 - Singularity: `singularity exec <img filename> pipeline --help`
