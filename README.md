[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# quakelab-containers
This repository allows you to build a Docker image **and** a singularity image for various pipelines in the Quake lab at Stanford. Each pipeline is a different branch (the `master` branch is just an empty skeleton):

 - [singlecell](https://github.com/iosonofabio/quakelab_containers/tree/singlecell): scRNA-Seq on full-length transcripts (e.g. via SmartSeq2 libraries)
 - [singlecell-10X](https://github.com/iosonofabio/quakelab_containers/tree/singlecell-10X): scRNA-Seq on 3'-end of transcripts using 10X Genomics libraries and `cellranger` software
 - **cell-free RNA-Seq** (planned)

## How to use this repo
If you are a user that would like to run a pipeline without bothering about operating systems, clusters, et al., just install the image from docker-hub or singularity-hub and run it (see below). If you are a developer searching for working examples of a pipeline, including the continuous integration and deployment to docker-hub and singularity-hub, clone the repo and start coding away from the `Dockerfile` and `.travis.yml`!

## Image istallation
The current images are hosted here:

 - [Docker](https://hub.docker.com/r/iosonofabio/quakelab-containers/): `docker pull iosonofabio/quakelab-containers:<branch name>`
 - [Singularity](https://singularity-hub.org/collections/141/): `singularity pull shub://iosonofabio/quakelab_containers:<branch name>`

where `<branch name>` is the name of the git branch/pipeline you want to install.

**NOTE**: you may need a development version of singularity to use the command `pull`.

## Usage

 - Docker: `docker run -v $(pwd)/projectdata:/data/projectdata --name imagename --rm iosonofabio/quakelab-containers pipeline --help`
 - Singularity: `singularity exec <img filename> pipeline --help`
