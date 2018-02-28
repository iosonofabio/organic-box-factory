#!/usr/bin/env python
import os

# NOTE: this script tests both Docker and singularity, but the data is mounted
# on different folders
if os.getenv('CONTAINER_TYPE') == 'docker':
    os.environ['DATA_ROOT'] = '/data/'
elif os.getenv('CONTAINER_TYPE') == 'singularity':
    os.environ['DATA_ROOT'] = ''
else:
    raise ValueError('CONTAINER_TYPE variable not set!')

print("Container type: {:}".format(os.getenv('CONTAINER_TYPE')))

os.chdir('{:}example_data'.format(os.getenv('DATA_ROOT')))

print("Make memory mapped folder")
os.makedirs('data')

print('Import ExpressionMatrix2')
import ExpressionMatrix2

print("Process input CSV data into memory-mapped folder")
print("Mock")
