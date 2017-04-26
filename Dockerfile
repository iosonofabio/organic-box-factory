FROM finalduty/archlinux:latest
MAINTAINER Fabio Zanini <fabio DOT zanini AT stanford DOT edu>
# Change pacman mirror
RUN echo 'Server = http://mirror.us.leaseweb.net/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist; echo 'Server = http://archlinux.polymorf.fr/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
# Create uncompressed packages
RUN sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar'/" /etc/makepkg.conf
# Update packages
RUN pacman -Syu --noconfirm
# Update basic deps
RUN pacman --noconfirm -S make gcc binutils gzip abs fakeroot wget python python-numpy cython python-matplotlib swig
# Make nonroot userfor makepkg
RUN useradd -m -g users -G wheel -s /bin/bash singleceller
# Install aura for AUR packages
RUN cd /home/singleceller; mkdir -p packages/aura; cd packages/aura; wget https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz; tar -xvf aura-bin.tar.gz; cd aura-bin; chmod -R a+wrX /home/singleceller/packages/aura; su singleceller -c makepkg; pacman -U aura-bin-1.3.8-1-x86_64.pkg.tar --noconfirm
# Install packages from AUR
RUN for PKGNAME in 'star-seq-alignment' 'python-pysam' 'python-htseq'; do export PKGNAME='star-seq-alignment'; cd /home/singleceller; mkdir -p packages/${PKGNAME}; cd packages/${PKGNAME}; aura -Aw ${PKGNAME}; tar -xf ${PKGNAME}.tar.gz; chmod -R a+wrX /home/singleceller/packages/${PKGNAME}; cd ${PKGNAME}; su singleceller -c makepkg; pacman -U $(ls "${PKGNAME}"-*.pkg.tar) --noconfirm; done
# Delete package manager cache
RUN pacman -Scc --noconfirm

# Tests
## Compile yeast genome with STAR
#RUN cd example_data; mkdir STAR; gunzip Saccharomyces_cerevisiae.R64-1-1.88.gtf.gz; gunzip Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz; cp Saccharomyces_cerevisiae.R64-1-1.88.gtf STAR/; cp Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa STAR/; cd STAR; star-seq-alignment --runMode genomeGenerate --runThreadN 1 --genomeDir . --genomeFastaFiles Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa --sjdbGTFfile Saccharomyces_cerevisiae.R64-1-1.88.gtf
## Map reads to yeast genome
#RUN cd example_data/STAR; star-seq-alignment --runMode alignReads --runThreadN 1 --genomeDir . --readFilesIn ../yeast_RNASeq_excerpt.fastq.gz --readFilesCommand zcat
## Count genes
#RUN htseq-count -m intersection-nonempty Aligned.out.sam Saccharomyces_cerevisiae.R64-1-1.88.gtf
