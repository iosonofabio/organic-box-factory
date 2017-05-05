[![Build Status](https://travis-ci.org/iosonofabio/quakelab_containers.svg?branch=master)](https://travis-ci.org/iosonofabio/quakelab_containers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# singlecell-container
This repository allows you to build a Docker image **and** a singularity image for various pipelines in the Quake lab at Stanford. Each pipeline is a different branch; the `master` branch is just an empty skeleton.

## How to use this repo
If you are a singlecell user that would like to run the pipeline without bothering about operating systems, clusters, et al., just install the image and run it (see below). If you are a developer searching for working examples of this pipeline, including the continuous integration and deployment to docker-hub and singularity-hub, clone the repo and start coding away from the `Dockerfile` and `.travis.yml`!

## Image istallation
The current images are hosted here:

 - [Docker](https://hub.docker.com/r/iosonofabio/singlecell-container/): `docker pull iosonofabio/quakelab-containers:master`
 - [Singularity](https://singularity-hub.org/collections/132/): `singularity pull shub://iosonofabio/quakelab_containers:master`

**NOTE**: you may need a development version of singularity to use the command `pull`.

## Usage

 - Docker: `docker run -v $(pwd)/projectdata:/data/projectdata --name imagename --rm iosonofabio/quakelab-containers pipeline --help`
 - Singularity: `singularity exec <img filename> pipeline --help`
