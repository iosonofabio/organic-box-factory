[![Build Status](https://travis-ci.org/iosonofabio/organic-box-factory.svg?branch=ExpressionMatrix2)](https://travis-ci.org/iosonofabio/quakelab_containers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Organic Box Factory: ExpressionMatrix2
This repository allows you to build a Docker image **and** a singularity image for using [ExpressionMatrix2](https://github.com/chanzuckerberg/ExpressionMatrix2).

## How to use this repo
If you are a singlecell user that would like to run the pipeline without bothering about operating systems, clusters, et al., just install the image and run it (see below). If you are a developer searching for working examples of this pipeline, including the continuous integration and deployment to docker-hub and singularity-hub, clone the repo and start coding away from the `Dockerfile` and `.travis.yml`!

## Image istallation
The current images are hosted here:

 - [Docker](https://hub.docker.com/r/iosonofabio/organic-box-factory/): `docker pull iosonofabio/organic-box-factory:ExpressionMatrix2`
 - [Singularity](https://singularity-hub.org/collections/141/): `singularity pull shub://iosonofabio/quakelab_containers:ExpressionMatrix2`

## Usage

 - Docker: `docker run -v $(pwd)/projectdata:/data/projectdata --name ExpressionMatrix2 --rm iosonofabio/expressionmatrix2-container bash`
 - Singularity: `singularity exec <img filename> bash`

## Examples
TODO
