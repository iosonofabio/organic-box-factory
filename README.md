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

**NOTE**: docker requires both root privileges and an app running in the background:
- For **Linux** users, that's typically a daemon (start it via systemctl is that's your cup of tea).
- For **OSX** users, that's still a daemon but it has a friendly name: "Docker App" - start the "Docker App" before calling `docker pull`.

## Fire up container
 - Docker: `docker run -it -p 127.0.0.1:17100:17100 -v $(pwd)/projectdata:/data/projectdata --name ExpressionMatrix2 --rm iosonofabio/organic-box-factory:ExpressionMatrix2 bash`
 - Singularity: `singularity exec <img filename> bash`

**NOTE**: singularity does not support port mapping [yet](https://groups.google.com/a/lbl.gov/forum/#!topic/singularity/znwthR5K0dA).

## Usage
Once you are shelling into the container:
```bash
[root@<magic number> /]# python
Python 3.6.4 (default, Jan  5 2018, 02:35:40) 
[GCC 7.2.1 20171224] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import ExpressionMatrix2
>>> 
```
This shows that you can import the `ExpressionMatrix2` Python module, follow the examples on [Paolo's repo](https://github.com/chanzuckerberg/ExpressionMatrix2).

## Basic example
Make a folder on your local machine called `projectdata`:
```bash
mkdir projectdata
```

Copy your counts CSV table and metadata CSV table into that folder, say called `counts.csv` and `meta.csv`.
```bash
cp ... projectdata/counts.csv
cp ... projectdata/meta.csv
```

Run the docker/singularity container as of above:
```bash
docker run -it -p 127.0.0.1:17100:17100 -v $(pwd)/projectdata:/data/projectdata --name ExpressionMatrix2 --rm iosonofabio/organic-box-factory:ExpressionMatrix2 bash
```

Now you're inside the container. Go inside `projectdata` and download the input script from Paolo's:
```bash
cd /data/projectdata
wget https://raw.githubusercontent.com/chanzuckerberg/ExpressionMatrix2/master/tests/CaseStudy1/input.py
```

Using an editor of your choice (inside or outside the container), edit the script to use `counts.csv` and `meta.csv`. Then, from inside the container run the script:
```bash
python input.py
```

Now you have a subfolder called `data`.

**NOTE**: If the `input.py` script failed for any reason, you have to delete this folder to retry (**dangerous command!!**):
```bash
rm -rf ./data
```

Now download the webserver script from Paolo's:
```bash
wget https://raw.githubusercontent.com/chanzuckerberg/ExpressionMatrix2/master/tests/CaseStudy1/runServer.py
```

and finally run it:
```bash
python runServer.py
```

Now you can point your browser on the local machine to `http://127.0.0.1:17100` or (equivalently) `http://localhost:17100` to see the result. Happy graphing!
