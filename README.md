[![Build Status](https://travis-ci.org/iosonofabio/singlecell_container.svg?branch=master)](https://travis-ci.org/iosonofabio/singlecell_container)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# singlecell-container
... allows you to build a Docker image **and** a singularity image for single cell RNA-Seq a la SmartSeq2 (STAR mapping, htseq-count gene counting).

## Installation
The current images are hosted here:

 - [Docker](https://hub.docker.com/r/iosonofabio/singlecell-container/): `docker pull iosonofabio/singlecell-container`
 - [Singularity](https://singularity-hub.org/collections/132/): `singularity pull shub://iosonofabio/singlecell_container:master`

**NOTE**: you may need a development version of singularity to use the command `pull`.

## Usage

 - Docker: `docker run -v $(pwd)/projectdata:/data/projectdata --name singlecell --rm iosonofabio/singlecell-container /pipeline/pipeline.py --help`
 - Singularity: `singularity exec 188c0373e1d5b8a58e89e2f5e4fc355307b75909.img pipeline/pipeline.py --help` (under testing ATM)
