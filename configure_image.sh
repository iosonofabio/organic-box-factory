#!/bin/sh
# Use bash strict mode
set -euo pipefail

PACMAN_PACKAGES=('binutils' 'gcc' 'gzip' 'fakeroot' 'wget' 'make' 'python2')
AUR_PACKAGES=('bcl2fastq')

# Install pacman packages
echo 'Server = http://mirror.us.leaseweb.net/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist; echo 'Server = http://archlinux.polymorf.fr/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar'/" /etc/makepkg.conf
pacman -Syu --noconfirm
echo 'Install pacman packages...'
pacman --noconfirm -S ${PACMAN_PACKAGES[@]}
echo 'pacman packages installed'

# Prepare nonroot user for makepkg
useradd -m -g users -G wheel -s /bin/bash aur

# Install aura
cd /home/aur; mkdir -p packages/aura; cd packages/aura; wget https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz; tar -xvf aura-bin.tar.gz; cd aura-bin; chmod -R a+wrX /home/aur/packages/aura; su aur -c makepkg; pacman -U aura-bin-*.pkg.tar --noconfirm

# Install AUR packages
for PKGNAME in ${AUR_PACKAGES[@]}; do cd /home/aur; mkdir -p packages/${PKGNAME}; cd packages/${PKGNAME}; aura -Aw ${PKGNAME}; tar -xf ${PKGNAME}.tar.gz; chmod -R a+wrX /home/aur/packages/${PKGNAME}; cd ${PKGNAME}; su aur -c makepkg; pacman -U $(ls "${PKGNAME}"-*.pkg.tar) --noconfirm; done

# Remove cache and tmp files
pacman -Scc --noconfirm; rm -rf /home/aur/packages
