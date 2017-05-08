#!/bin/sh
PACMAN_PACKAGES=('gcc' 'libxml')
AUR_PACKAGES=('bcl2fastq' 'cellranger')

# Install pacman packages
echo 'Server = http://mirror.us.leaseweb.net/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist; echo 'Server = http://archlinux.polymorf.fr/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar'/" /etc/makepkg.conf
pacman -Syu --noconfirm
pacman --noconfirm -S ${PACMAN_PACKAGES}

# Install aura
useradd -m -g users -G wheel -s /bin/bash singleceller
cd /home/singleceller; mkdir -p packages/aura; cd packages/aura; wget https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz; tar -xvf aura-bin.tar.gz; cd aura-bin; chmod -R a+wrX /home/singleceller/packages/aura; su singleceller -c makepkg; pacman -U aura-bin-1.3.8-1-x86_64.pkg.tar --noconfirm

# Copy cellranger into package folder
mkdir -p /home/singleceller/packages/cellranger
mv /assets/cellranger*.tar.gz /home/singleceller/packages/cellranger

# Install AUR packages
for PKGNAME in ${AUR_PACKAGES}; do cd /home/singleceller; mkdir -p packages/${PKGNAME}; cd packages/${PKGNAME}; aura -Aw ${PKGNAME}; tar -xf ${PKGNAME}.tar.gz; chmod -R a+wrX /home/singleceller/packages/${PKGNAME}; cd ${PKGNAME}; su singleceller -c makepkg; pacman -U $(ls "${PKGNAME}"-*.pkg.tar) --noconfirm; done
pacman -Scc --noconfirm; rm -rf /home/singleceller/packages

