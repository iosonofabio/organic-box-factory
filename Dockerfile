FROM finalduty/archlinux:latest
MAINTAINER Fabio Zanini <fabio DOT zanini AT stanford DOT edu>
# Update packages
RUN pacman -Syu --noconfirm
# Update basic deps
RUN pacman -S wget python python-numpy cython python-matplotlib swig
# Install aura for AUR packages
RUN mkdir aura; cd aura; wget https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz; tar -xvf aura-bin.tar.gz; cd aura-bin; makepkg; pacman -U aura-bin-1.3.8-1-x86_64.pkg.tar.xz --noconfirm
# Install STAR
RUN aura -A star-seq-alignment
# Install HTSeq
RUN aura -A python-sampy python-htseq
# Delete package manager cache
RUN pacman -Scc --noconfirm
