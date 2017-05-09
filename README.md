[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# quakelab-containers
High-throughput sequencing applications often involve computationally costly operations that cannot be performed on a local computer (e.g. a laptop); instead, they require a cluster of computers that work in parallel. Two cluster architectures are common in 2017: physical clusters, for instance Stanford's [Sherlock](http://sherlock.stanford.edu/mediawiki/index.php/Main_Page), and cloud-based services such as [Amazon Web Services](https://aws.amazon.com/) and [Google Computing Engine](https://cloud.google.com/compute/). Either way, access to high-throughput clusters is restricted, and installing and configuring all necessary software on every different platform can be (and typically is) a time-consuming and frustrating task. Thanks to light virtualization technologies like [Docker](https://www.docker.com/), preconfigured *images* can be prepared and tested ahead of time. Whereas cloud systems virtualize the hardware and give customers superuser access to their computing instances and can run Docker without issues, physical clusters typically distribute only non-priviledged accounts and require a different virtualization scheme, a need that was recently filled by [Singularity](http://singularity.lbl.gov/).

This repository offers access to a number of Docker and Singularity images to execute high-throughput sequencing pipelines as they are typically done in the Quake lab at Stanford, eliminating the need to install and configure the single programs and software libraries every time. Moreover, the repository tries to standardize and expose the *common* recipe used to build simultaneously both a Docker and a Singularity image, so each pipeline can be lifted to the cloud or grounded to a local cluster without any further configuration. Finally, each recipe is built and validated via continuous integration (CI) using [Travis CI](https://travis-ci.org/), to guarantee that the software works as planned.


At the moment the following pipelines are available - each pipeline is a different branch (the `master` branch is just an empty skeleton):

 - [singlecell](https://github.com/iosonofabio/quakelab-containers/tree/singlecell): scRNA-Seq on full-length transcripts (e.g. via SmartSeq2 libraries)
 - [singlecell-10X](https://github.com/iosonofabio/quakelab-containers/tree/singlecell-10X): scRNA-Seq on 3'-end of transcripts using 10X Genomics libraries and `cellranger` software
 - [cell-free RNA-Seq](https://github.com/iosonofabio/quakelab-containers/tree/cellfreeRNA): cell-free RNA including picard-tools (for duplicate removal) and fastqc.

## Usage
If you are a user that would like to run a pipeline without bothering about operating systems, clusters, et al., just install the image from docker-hub or singularity-hub and run it.

### Install an image
 - [Docker](https://hub.docker.com/r/iosonofabio/quakelab-containers/): `docker pull iosonofabio/quakelab-containers:<branch name>`
 - [Singularity](https://singularity-hub.org/collections/141/): `singularity pull shub://iosonofabio/quakelab-containers:<branch name>`

where `<branch name>` is the name of the git branch/pipeline you want to install.

**NOTE**: you may need a development version of singularity to use the command `pull`.

### Run software on the image
After installing an image:
 - Docker: `docker run -v $(pwd)/projectdata:/data/projectdata --name imagename --rm iosonofabio/quakelab-containers:<branch name> <command>`
 - Singularity: `singularity exec <img filename> <command>`

### Run the default pipeline
Some images (e.g. `singlecell`) ship with a default `pipeline` command:
 - Docker: `docker run -v $(pwd)/projectdata:/data/projectdata --name imagename --rm iosonofabio/quakelab-containers:<branch name> pipeline --help`
 - Singularity: `singularity exec <img filename> pipeline --help`

### Contributing/developers
If you are a developer searching for working examples of a pipeline, clone the repo and start coding away from the `Dockerfile` and `.travis.yml`! If you want to contribute to this repo, just open an issue on github.

