#!/usr/bin/bash

echo "Prepare folders"
cd /data/example_data || cd example_data
mkdir STAR output
gunzip Saccharomyces_cerevisiae.R64-1-1.88.gtf.gz
gunzip Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz
cp Saccharomyces_cerevisiae.R64-1-1.88.gtf STAR/
cp Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa STAR/

echo "Compile yeast genome with STAR"
star-seq-alignment --runMode genomeGenerate --runThreadN 1 --genomeDir STAR --genomeFastaFiles Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa --sjdbGTFfile Saccharomyces_cerevisiae.R64-1-1.88.gtf

echo "Map reads to yeast genome"
star-seq-alignment --runMode alignReads --runThreadN 1 --genomeDir STAR --readFilesIn yeast_RNASeq_excerpt.fastq.gz --readFilesCommand zcat --outFileNamePrefix output/

echo "Count genes"
htseq-count -m intersection-nonempty output/Aligned.out.sam Saccharomyces_cerevisiae.R64-1-1.88.gtf > output/yeast_htseq_count_test.tsv

echo "Compare with original counts"
cmp output/yeast_htseq_count_test.tsv yeast_RNASeq_excerpt_htseq_counts.tsv

echo "Run pipeline"
pipeline --readfilenames yeast_RNASeq_excerpt.fastq.gz --genomefolder STAR --annotationfilename Saccharomyces_cerevisiae.R64-1-1.88.gtf --outputfolder output_pipeline

echo "Compare with original counts"
cmp output_pipeline/counts.tsv yeast_RNASeq_excerpt_htseq_counts_withheader.tsv
