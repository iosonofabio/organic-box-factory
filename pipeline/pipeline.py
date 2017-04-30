#!/usr/bin/env python
# vim: fdm=indent
'''
author:     Fabio Zanini
date:       20/06/16
content:    Analyze the reads: map against human transcriptome (and virus)
            and count the number of reads per gene.
'''
# Modules
import os
import sys
import argparse


class Pipeline:
    '''Single cell RNA seq pipeline'''
    def __init__(
            self,
            raw_reads_filenames,
            genome_foldername,
            annotation_filename,
            output_foldername,
            verbose=0,
            log_foldername=None,
            nthreads=1,
            steps=()):

        self.raw_reads_filenames = raw_reads_filenames
        self.genome_foldername = genome_foldername.rstrip('/')+'/'
        self.annotation_filename = annotation_filename
        self.output_foldername = output_foldername
        if self.output_foldername is not None:
            self.output_foldername = self.output_foldername.rstrip('/')+'/'
        self.verbose = verbose
        self.log_foldername = log_foldername
        if self.log_foldername is not None:
            self.log_foldername = self.log_foldername.rstrip('/')+'/'
        self.log = log_foldername is not None
        self.nthreads = nthreads
        self.steps = steps

    def __call__(self):
        if self.verbose:
            print('Pipeline: start')

        if 'star' in self.steps:
            self.map_star()

        if 'htseq-count' in self.steps:
            self.count_genes()

        if self.verbose:
            print('Pipeline: end')

    def check_done(self):
        '''Check the presence of the .done file for a step'''
        from datetime import datetime

        for step in self.steps:
            fn = self.get_log_done_filename(step)
            if os.path.isfile(fn):
                dt = (datetime.fromtimestamp(os.path.getmtime(fn))
                              .strftime('%Y-%m-%d %H:%M:%S'))
                print(self.sample.name, step, 'OK', dt)
            else:
                print(self.sample.name, step, 'FAIL')
        self.steps = ()

    def get_log_done_filename(self, step):
        return self.log_foldername+step+'.done'

    def get_star_mapped_filename(self):
        return self.output_foldername+'Aligned.out.bam'

    def get_star_unaligned_filenames(self):
        return (self.output_foldername+'Unmapped.out.mate1',
                self.output_foldername+'Unmapped.out.mate2')[:len(self.raw_reads_filenames)]

    def get_htseq_count_output_filename(self):
        return self.output_foldername+'counts.tsv'

    def map_star(self):
        '''Map reads against human transcriptome'''
        import subprocess as sp
        from pathlib import Path

        if self.verbose:
            print('Map star: start')

        os.makedirs(self.output_foldername, exist_ok=True)

        if self.verbose:
            print('Map star: folder created')

        star_exec = os.getenv('STAR', default=None)
        if star_exec is None:
            for star_exec in ['STAR', 'star-seq-alignment']:
                try:
                    sp.call([star_exec, '--version'])
                except FileNotFoundError:
                    continue
                else:
                    break
            else:
                raise FileNotFoundError('STAR aligner not found!')

        call = [star_exec,
                '--genomeDir', self.genome_foldername.rstrip('/'),
                '--readFilesIn'] + self.raw_reads_filenames + [
                '--readFilesCommand', 'zcat',
                '--outFilterType', 'BySJout',
                '--outFilterMultimapNmax', '20',
                '--alignSJoverhangMin', '8',
                '--alignSJDBoverhangMin', '1',
                '--outFilterMismatchNmax', '999',
                '--outFilterMismatchNoverLmax', '0.04',
                '--alignIntronMin', '20',
                '--alignIntronMax', '1000000',
                '--alignMatesGapMax', '1000000',
                '--outSAMstrandField', 'intronMotif',
                '--runThreadN', str(self.nthreads),
                '--outSAMtype', 'BAM', 'Unsorted',
                '--outSAMattributes', 'NH', 'HI', 'AS', 'NM', 'MD',
                '--outFilterMatchNminOverLread', '0.4',
                '--outFilterScoreMinOverLread', '0.4',
                '--outFileNamePrefix', self.output_foldername,
                '--clip3pAdapterSeq', 'CTGTCTCTTATACACATCT',
                '--outReadsUnmapped', 'Fastx',
                ]

        if self.verbose:
            print('Map star: call:')
            print(' '.join(call))

        sp.call(call)

        if self.log:
            Path(self.get_log_folder()+'star.done').touch()

        self.steps = [s for s in self.steps if s != 'star']

        if self.verbose:
            print('Map star: end')


    def count_genes(self):
        import subprocess as sp
        from pathlib import Path

        if self.verbose:
            print('Count htseq-count: start')

        os.makedirs(self.output_foldername, exist_ok=True)

        if self.verbose:
            print('Count htseq-count: folder created')

        samtools_exec = os.getenv('SAMTOOLS', 'samtools')
        htseqcount_exec = os.getenv('HTSEQ-COUNT', default='htseq-count')
        call1 = [samtools_exec,
                 'view', self.get_star_mapped_filename(),
                 ]
        call2 = [htseqcount_exec,
                 '-m', 'intersection-nonempty',
                 '-s', 'no',
                 '-', self.annotation_filename,
                 ]

        if self.verbose:
            print('Count htseq-count: call:')
            print(' '.join(call1)+' | '+' '.join(call2))

        p1 = sp.Popen(call1, stdout=sp.PIPE)
        p2 = sp.Popen(call2, stdin=p1.stdout, stdout=sp.PIPE)
        p1.stdout.close()
        output = (p2.communicate()[0]
                    .decode()
                    .rstrip('\n')
                    .split('\n'))

        # Add the unmapped read pair count
        fn_um = self.get_star_unaligned_filenames()[0]
        with open(fn_um, 'rt') as f:
            n_um = sum(1 for line in f) // 4
        output[-2] = output[-2].split('\t')[0]+'\t'+str(n_um)
        output = '\n'.join(output)+'\n'

        with open(self.get_htseq_count_output_filename(), 'w') as f:
            f.write('feature\tcount\n')
            f.write(output)

        if self.log:
            Path(self.get_log_folder()+'htseq-count.done').touch()

        self.steps = [s for s in self.steps if s != 'htseq-count']

        if self.verbose:
            print('Count htseq-count: end')


# Script
if __name__ == '__main__':

    pa = argparse.ArgumentParser(description='scRNA-Seq pipeline')
    pa.add_argument('--readfilenames', nargs='+', required=True,
                    help='Path to the file(s) containing the fastq files')
    pa.add_argument('--genomefolder', required=True,
                    help='Path to the genome folder for mapping. ' +
                    'It may or may not contain the STAR hashes ' +
                    '(if it does not, hashes will be generated there).')
    pa.add_argument('--annotationfilename', required=True,
                    help='Path to the GTF file containing the annotations')
    pa.add_argument('--outputfolder', required='True',
                    help='Path to output results to')
    pa.add_argument('--steps', nargs='+', default=('star', 'htseq-count'),
                    choices=['star', 'htseq-count'],
                    help='steps to execute')
    pa.add_argument('--verbose', type=int, choices=[0, 1, 2], default=1,
                    help='verbosity level')
    pa.add_argument('--nthreads', type=int, default=1,
                    help='Number of threads for STAR')
    pa.add_argument('--logfolder', default=None,
                    help='Folder where to store a log of the processing')
    pa.add_argument('--check-done', action='store_true',
                    help='check whether the steps are done as opposed to run the actual steps')

    args = pa.parse_args()

    pip = Pipeline(
            raw_reads_filenames=args.readfilenames,
            genome_foldername=args.genomefolder,
            annotation_filename=args.annotationfilename,
            output_foldername=args.outputfolder,
            log_foldername=args.logfolder,
            verbose=args.verbose,
            nthreads=args.nthreads,
            steps=args.steps)
    if args.check_done:
        pip.check_done()
    else:
        pip()
