#!/usr/bin/bash

echo "Prepare folders"
cd /data/example_data 
mkdir STAR
gunzip Saccharomyces_cerevisiae.R64-1-1.88.gtf.gz
gunzip Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz
cp Saccharomyces_cerevisiae.R64-1-1.88.gtf STAR/
cp Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa STAR/
cd STAR

echo "Compile yeast genome with STAR"
star-seq-alignment --runMode genomeGenerate --runThreadN 1 --genomeDir . --genomeFastaFiles Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa --sjdbGTFfile Saccharomyces_cerevisiae.R64-1-1.88.gtf

echo "Map reads to yeast genome"
star-seq-alignment --runMode alignReads --runThreadN 1 --genomeDir . --readFilesIn ../yeast_RNASeq_excerpt.fastq.gz --readFilesCommand zcat

echo "Count genes"
htseq-count -m intersection-nonempty Aligned.out.sam Saccharomyces_cerevisiae.R64-1-1.88.gtf > /data/example_data/yeast_htseq_count_test.tsv

echo "Compare with original counts"
cmp /data/example_data/yeast_htseq_count_test.tsv /data/example_data/yeast_RNASeq_excerpt_htseq_counts.tsv
