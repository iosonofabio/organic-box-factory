FROM finalduty/archlinux:latest
MAINTAINER Fabio Zanini <fabio DOT zanini AT stanford DOT edu>
# Change pacman mirror
RUN echo 'Server = http://mirror.us.leaseweb.net/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist; echo 'Server = http://archlinux.polymorf.fr/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
# Create uncompressed packages
RUN sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar'/" /etc/makepkg.conf
# Update packages
RUN pacman -Syu --noconfirm
# Update basic deps
RUN pacman --noconfirm -S make gcc binutils abs fakeroot wget python python-numpy cython python-matplotlib swig
# Make nonroot userfor makepkg
RUN useradd -m -g users -G wheel -s /bin/bash singleceller
# Install aura for AUR packages
RUN cd /home/singleceller; mkdir aura; cd aura; wget https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz; tar -xvf aura-bin.tar.gz; cd aura-bin; chmod -R a+wrX /home/singleceller/aura; su singleceller -c makepkg; pacman -U aura-bin-1.3.8-1-x86_64.pkg.tar --noconfirm
# Install STAR
RUN cd /home/singleceller; mkdir star-seq-alignment; cd star-seq-alignment; aura -Aw star-seq-alignment; tar -xf star-seq-alignment.tar.gz; chmod -R a+wrX /home/singleceller/star-seq-alignment; cd star-seq-alignment; su singleceller -c makepkg; pacman -U star-seq-alignment-v2.5-1-x86_64.pkg.tar --noconfirm
# Install HTSeq
RUN su root -c "aura -A python-sampy python-htseq"
# Delete package manager cache
RUN pacman -Scc --noconfirm
