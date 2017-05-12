[![Build Status](https://travis-ci.org/iosonofabio/organic-box-factory.svg?branch=singlecell)](https://travis-ci.org/iosonofabio/quakelab_containers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Organic Box Factory: singlecell RNA-Seq
This repository allows you to build a Docker image **and** a singularity image for single cell RNA-Seq a la SmartSeq2 ([STAR](https://github.com/alexdobin/STAR) mapping, [htseq-count](https://github.com/simon-anders/htseq) gene counting).

## How to use this repo
If you are a singlecell user that would like to run the pipeline without bothering about operating systems, clusters, et al., just install the image and run it (see below). If you are a developer searching for working examples of this pipeline, including the continuous integration and deployment to docker-hub and singularity-hub, clone the repo and start coding away from the `Dockerfile` and `.travis.yml`!

## Image istallation
The current images are hosted here:

 - [Docker](https://hub.docker.com/r/iosonofabio/organic-box-factory/): `docker pull iosonofabio/organic-box-factory:singlecell`
 - [Singularity](https://singularity-hub.org/collections/141/): `singularity pull shub://iosonofabio/quakelab_containers:singlecell`

**NOTE**: you may need a development version of singularity to use the command `pull`.

## Usage

 - Docker: `docker run -v $(pwd)/projectdata:/data/projectdata --name singlecell --rm iosonofabio/singlecell-container pipeline --help`
 - Singularity: `singularity exec <img filename> pipeline --help` (under testing ATM)

## Examples

 - Docker: `docker run -v $(pwd)/example_data:/data/example_data --name singlecell --rm iosonofabio/singlecell-container pipeline --readfilenames /data/example_data/yeast_RNASeq_excerpt.fastq.gz --genomefolder /data/example_data/STAR --annotationfilename /data/example_data/Saccharomyces_cerevisiae.R64-1-1.88.gtf --outputfolder /data/example_data/output`
 - Singularity: `singularity exec <img filename> pipeline --readfilenames example_data/yeast_RNASeq_excerpt.fastq.gz --genomefolder example_data/STAR --annotationfilename example_data/Saccharomyces_cerevisiae.R64-1-1.88.gtf --outputfolder example_data/output`

