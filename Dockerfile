FROM finalduty/archlinux:latest
MAINTAINER Fabio Zanini <fabio DOT zanini AT stanford DOT edu>
# Change pacman mirror
RUN echo 'Server = http://mirror.us.leaseweb.net/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist; echo 'Server = http://archlinux.polymorf.fr/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
# Create uncompressed packages
RUN sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar'/" /etc/makepkg.conf
# Update packages
RUN pacman -Syu --noconfirm
# Update basic deps
RUN pacman --noconfirm -S make gcc binutils gzip abs fakeroot wget python python-numpy python-matplotlib cython swig
# Make nonroot userfor makepkg
RUN useradd -m -g users -G wheel -s /bin/bash singleceller
# Install aura for AUR packages
RUN cd /home/singleceller; mkdir -p packages/aura; cd packages/aura; wget https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz; tar -xvf aura-bin.tar.gz; cd aura-bin; chmod -R a+wrX /home/singleceller/packages/aura; su singleceller -c makepkg; pacman -U aura-bin-1.3.8-1-x86_64.pkg.tar --noconfirm
# Install packages from AUR
RUN for PKGNAME in 'star-seq-alignment' 'python-pysam' 'python-htseq' 'htslib' 'samtools'; do cd /home/singleceller; mkdir -p packages/${PKGNAME}; cd packages/${PKGNAME}; aura -Aw ${PKGNAME}; tar -xf ${PKGNAME}.tar.gz; chmod -R a+wrX /home/singleceller/packages/${PKGNAME}; cd ${PKGNAME}; su singleceller -c makepkg; pacman -U $(ls "${PKGNAME}"-*.pkg.tar) --noconfirm; done
# Delete package manager cache
RUN pacman -Scc --noconfirm; rm -rf /home/singleceller/packages
# Create an empty folder to bind singularity folders for systems that don't support overlay filesystems
RUN mkdir /mnt/singularity_bind
# Add pipeline to image
COPY pipeline/pipeline.py /usr/bin/pipeline
# Set ENTRYPOINT to run the Docker/Singularity image
#ENTRYPOINT /usr/bin/pipeline
