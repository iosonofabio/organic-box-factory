#!/usr/bin/bash
set -euo pipefail
IFS=$'\n\t'

# NOTE: this script tests both Docker and singularity, but the data is mounted on different folders
if [ -d /data/example_data ]; then
  CONTAINER_TYPE=docker
  DATA_ROOT=/data/
else
  CONTAINER_TYPE=singularity
  DATA_ROOT=''
fi

echo "Container type: ${CONTAINER_TYPE}"

cd ${DATA_ROOT}example_data

echo "Make memory mapped folder"
mkdir data

echo "Process input CSV data into memory-mapped folder"
echo "Mock"
# python ./input.py
