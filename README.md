[![Build Status](https://travis-ci.org/iosonofabio/organic-box-factory.svg?branch=stampy)](https://travis-ci.org/iosonofabio/organic-box-factory)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Organic Box Factory: stampy
This repository allows you to build a Docker image **and** a singularity image for the mapper [Stampy](http://www.well.ox.ac.uk/project-stampy).

## How to use this repo
If you are a stampy user that would like to run the pipeline without bothering about operating systems, clusters, et al., just install the image and run it (see below). If you are a developer searching for working examples of this pipeline, including the continuous integration and deployment to docker-hub and singularity-hub, clone the repo and start coding away from the `Dockerfile` and `.travis.yml`!

## Image istallation
The current images are hosted here:

 - [Docker](https://hub.docker.com/r/iosonofabio/organic-box-factory/): `docker pull iosonofabio/organic-box-factory:stampy`
 - [Singularity](https://singularity-hub.org/collections/141/): `singularity pull shub://iosonofabio/quakelab_containers:stampy`

**NOTE**: you may need a development version of singularity to use the command `pull`.

## Usage

 - Docker: `docker run -v $(pwd)/projectdata:/data/projectdata --name stampy --rm iosonofabio/stampy-container stampy --help`
 - Singularity: `singularity exec <img filename> stampy --help`

## Examples
TODO
