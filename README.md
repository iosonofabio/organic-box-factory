[![Build Status](https://travis-ci.org/iosonofabio/singlecell_container.svg?branch=master)](https://travis-ci.org/iosonofabio/singlecell_container)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# singlecell-container
This repository allows you to build a Docker image **and** a singularity image for single cell RNA-Seq a la SmartSeq2 ([STAR](https://github.com/alexdobin/STAR) mapping, [htseq-count](https://github.com/simon-anders/htseq) gene counting).

## How to use this repo
If you are a singlecell user that would like to run the pipeline without bothering about operating systems, clusters, et al., just install the image and run it (see below). If you are a developer searching for working examples of this pipeline, including the continuous integration and deployment to docker-hub and singularity-hub, clone the repo and start coding away from the `Dockerfile` and `.travis.yml`!

## Image istallation
The current images are hosted here:

 - [Docker](https://hub.docker.com/r/iosonofabio/singlecell-container/): `docker pull iosonofabio/singlecell-container`
 - [Singularity](https://singularity-hub.org/collections/132/): `singularity pull shub://iosonofabio/singlecell_container:master`

**NOTE**: you may need a development version of singularity to use the command `pull`.

## Usage

 - Docker: `docker run -v $(pwd)/projectdata:/data/projectdata --name singlecell --rm iosonofabio/singlecell-container /pipeline/pipeline.py --help`
 - Singularity: `singularity exec 188c0373e1d5b8a58e89e2f5e4fc355307b75909.img pipeline/pipeline.py --help` (under testing ATM)

## Examples

 - Docker: `docker run -v $(pwd)/example_data:/data/example_data --name singlecell --rm iosonofabio/singlecell-container /pipeline/pipeline.py --readfilenames /data/example_data/yeast_RNASeq_excerpt.fastq.gz --genomefolder /data/example_data/STAR --annotationfilename /data/example_data/Saccharomyces_cerevisiae.R64-1-1.88.gtf --outputfolder /data/example_data/output`
 - Singularity: `working on it`
