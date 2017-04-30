#!/usr/bin/bash
# NOTE: this script tests both Docker and singularity, but the data is mounted on different folders
FAILED=0
echo "Prepare folders"
if [ -d /data/example_data ]; then
  CONTAINER_TYPE=docker
  DATA_ROOT=/data/
else
  CONTAINER_TYPE=singularity
  DATA_ROOT=''
fi
EXAMPLE_DATA=${DATA_ROOT}example_data
cd ${EXAMPLE_DATA}
gunzip Saccharomyces_cerevisiae.R64-1-1.88.gtf.gz
gunzip Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz

# TEST 1: call the programs directly from within the container
mkdir STAR output
cp Saccharomyces_cerevisiae.R64-1-1.88.gtf STAR/
cp Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa STAR/

echo "Compile yeast genome with STAR"
star-seq-alignment --runMode genomeGenerate --runThreadN 1 --genomeDir STAR --genomeFastaFiles Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa --sjdbGTFfile Saccharomyces_cerevisiae.R64-1-1.88.gtf

echo "Map reads to yeast genome"
star-seq-alignment --runMode alignReads --runThreadN 1 --genomeDir STAR --readFilesIn yeast_RNASeq_excerpt.fastq.gz --readFilesCommand zcat --outFileNamePrefix output/

echo "Count genes"
htseq-count -m intersection-nonempty output/Aligned.out.sam Saccharomyces_cerevisiae.R64-1-1.88.gtf > output/counts.tsv

echo "Compare with original counts"
cmp output/counts.tsv yeast_RNASeq_excerpt_htseq_counts.tsv
if [ -z $? ]; then
  echo "SUCCESS"
else
  echo "FAIL"
  FAILED=1
fi
rm -rf STAR output
# END OF TEST 1

# TEST 2: call the pipeline script
mkdir STAR output
echo "Run pipeline"
pipeline --readfilenames yeast_RNASeq_excerpt.fastq.gz --genomefolder STAR --annotationfilename Saccharomyces_cerevisiae.R64-1-1.88.gtf --outputfolder output

echo "Compare with original counts"
cmp output_pipeline/counts.tsv yeast_RNASeq_excerpt_htseq_counts_withheader.tsv
if [ -z $? ]; then
  echo "SUCCESS"
else
  echo "FAIL"
  FAILED=2
fi

rm -rf STAR output
# END OF TEST 2

gzip Saccharomyces_cerevisiae.R64-1-1.88.gtf
gzip Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa

exit $FAILED
