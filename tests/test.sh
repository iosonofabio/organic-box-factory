#!/usr/bin/bash
# NOTE: this script tests both Docker and singularity, but the data is mounted on different folders
FAILED=0
if [ -d /data/example_data ] || [ -f /.dockerenv ]; then
  CONTAINER_TYPE=docker
  DATA_ROOT=/data/
else
  CONTAINER_TYPE=singularity
  DATA_ROOT=''
fi

echo "Container type: ${CONTAINER_TYPE}"

echo "Test executables"
EXECUTABLES=('conda --version')
for EXE in "${EXECUTABLES[@]}"; do echo "Testing ${EXE}"; ${EXE}; if [ $? -ne 0 ]; then exit 1; fi; done
