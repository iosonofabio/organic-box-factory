FROM finalduty/archlinux:latest
MAINTAINER Fabio Zanini <fabio DOT zanini AT stanford DOT edu>
# Update packages
RUN pacman -Syu --noconfirm
# Update basic deps
RUN pacman --noconfirm -S wget python python-numpy cython python-matplotlib swig
# Make nonroot userfor makepkg
RUN useradd -m -g users -G wheel -s /bin/bash singleceller
# Install aura for AUR packages
RUN su singleceller; cd /home/singleceller; mkdir aura; cd aura; wget https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz; tar -xvf aura-bin.tar.gz; cd aura-bin; makepkg; exit; pacman -U aura-bin-1.3.8-1-x86_64.pkg.tar.xz --noconfirm
# Install STAR
RUN aura -A star-seq-alignment
# Install HTSeq
RUN aura -A python-sampy python-htseq
# Delete package manager cache
RUN pacman -Scc --noconfirm
