[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

![Logo](logo.png)
# Organic Box Factory
https://iosonofabio.github.io/organic-box-factory/

High-throughput sequencing applications often involve computationally costly operations that cannot be performed on a local computer (e.g. a laptop); instead, they require a cluster of computers that work in parallel. Two cluster architectures are common in 2017: physical clusters, for instance Stanford's [Sherlock](http://sherlock.stanford.edu/mediawiki/index.php/Main_Page), and cloud-based services such as [Amazon Web Services](https://aws.amazon.com/) and [Google Computing Engine](https://cloud.google.com/compute/). Either way, access to high-throughput clusters is restricted, and installing and configuring all necessary software on every different platform can be (and typically is) a time-consuming and frustrating task. Thanks to light virtualization technologies like [Docker](https://www.docker.com/), preconfigured *images* can be prepared and tested ahead of time. Whereas cloud systems virtualize the hardware and give customers superuser access to their computing instances and can run Docker without issues, physical clusters typically distribute only non-priviledged accounts and require a different virtualization scheme, a need that was recently filled by [Singularity](http://singularity.lbl.gov/).

This repository offers access to a number of Docker and Singularity images to execute high-throughput sequencing pipelines as they are typically done in the Quake lab at Stanford, eliminating the need to install and configure the single programs and software libraries every time. Moreover, the repository tries to standardize and expose the *common* recipe used to build simultaneously both a Docker and a Singularity image, so each pipeline can be lifted to the cloud or grounded to a local cluster without any further configuration. Finally, each recipe is built and validated via continuous integration (CI) using [Travis CI](https://travis-ci.org/), to guarantee that the software works as planned.


At the moment the following pipelines are available - each pipeline is a different branch (the `master` branch is just an empty skeleton):

 - [![Build Status](https://travis-ci.org/iosonofabio/organic-box-factory.svg?branch=singlecell)](https://travis-ci.org/iosonofabio/organic-box-factory) [singlecell](https://github.com/iosonofabio/organic-box-factory/tree/singlecell): scRNA-Seq on full-length transcripts (e.g. via SmartSeq2 libraries)
 - [![Build Status](https://travis-ci.org/iosonofabio/organic-box-factory.svg?branch=singlecell-10X)](https://travis-ci.org/iosonofabio/organic-box-factory) [singlecell-10X](https://github.com/iosonofabio/organic-box-factory/tree/singlecell-10X): scRNA-Seq on 3'-end of transcripts using 10X Genomics libraries and `cellranger` software
 - [![Build Status](https://travis-ci.org/iosonofabio/organic-box-factory.svg?branch=bcl2fastq)](https://travis-ci.org/iosonofabio/organic-box-factory) [bcl2fastq-2.19](https://github.com/iosonofabio/organic-box-factory/tree/bcl2fastq): demultiplex and call FastQ from illumina machines (version 2.19)
 - [![Build Status](https://travis-ci.org/iosonofabio/organic-box-factory.svg?branch=bcl2fastq-2.20)](https://travis-ci.org/iosonofabio/organic-box-factory) [bcl2fastq-2.20](https://github.com/iosonofabio/organic-box-factory/tree/bcl2fastq-2.20): demultiplex and call FastQ from illumina machines (version 2.20)
 - [![Build Status](https://travis-ci.org/iosonofabio/organic-box-factory.svg?branch=cellfreeRNA)](https://travis-ci.org/iosonofabio/organic-box-factory) [cell-free RNA-Seq](https://github.com/iosonofabio/organic-box-factory/tree/cellfreeRNA): cell-free RNA including picard-tools (for duplicate removal) and fastqc.
 - [metagenomics](https://github.com/iosonofabio/organic-box-factory/tree/metagenomics): environmental samples including non-culturable organisms
 - [![Build Status](https://travis-ci.org/iosonofabio/organic-box-factory.svg?branch=stampy)](https://travis-ci.org/iosonofabio/organic-box-factory) [stampy](https://github.com/iosonofabio/organic-box-factory/tree/stampy): map reads against highly variable genomic references.

## Usage
If you are a user that would like to run a pipeline without bothering about operating systems, clusters, et al., just install the image from docker-hub or singularity-hub and run it.

### Install an image
 - [Docker](https://hub.docker.com/r/iosonofabio/organic-box-factory/): `docker pull iosonofabio/organic-box-factory:<branch name>`
 - [Singularity](https://singularity-hub.org/collections/141/): `singularity pull shub://iosonofabio/organic-box-factory:<branch name>`

where `<branch name>` is the name of the git branch/pipeline you want to install.

**NOTE**: you may need a development version of singularity to use the command `pull`.

### Run software on the image
After installing an image:
 - Docker: `docker run -v $(pwd)/projectdata:/data/projectdata --name imagename --rm iosonofabio/organic-box-factory:<branch name> <command>`
 - Singularity: `singularity exec <img filename> <command>`

### Run the default pipeline
Some images (e.g. `singlecell`) ship with a default `pipeline` command:
 - Docker: `docker run -v $(pwd)/projectdata:/data/projectdata --name imagename --rm iosonofabio/organic-box-factory:<branch name> pipeline --help`
 - Singularity: `singularity exec <img filename> pipeline --help`

### Contributing/developers
If you are a developer searching for working examples of a pipeline:
1. clone the repo from the branch you like
2. if you cloned from `master`, rename `travis.yml` into `.travis.yml` (notice the dot)
3. edit `.travis.yml`, `consigure_image.sh`, `Dockerfile`, `Singularity`, and `tests/test.sh`!

If you want to contribute to this repo, just open an issue on github. PRs always welcome!
