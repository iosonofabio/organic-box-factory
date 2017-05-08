#!/bin/sh
PACMAN_PACKAGES=('binutils' 'gcc' 'gzip' 'abs' 'fakeroot' 'wget' 'make' 'python2')
AUR_PACKAGES=('bcl2fastq')
AUR_PACKAGES_FIXED=('cellranger')

# Install pacman packages
echo 'Server = http://mirror.us.leaseweb.net/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist; echo 'Server = http://archlinux.polymorf.fr/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar'/" /etc/makepkg.conf
pacman -Syu --noconfirm
echo 'Install pacman packages...'
pacman --noconfirm -S ${PACMAN_PACKAGES[@]}
echo 'pacman packages installed'

# Install aura
useradd -m -g users -G wheel -s /bin/bash singleceller
cd /home/singleceller; mkdir -p packages/aura; cd packages/aura; wget https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz; tar -xvf aura-bin.tar.gz; cd aura-bin; chmod -R a+wrX /home/singleceller/packages/aura; su singleceller -c makepkg; pacman -U aura-bin-1.3.8-1-x86_64.pkg.tar --noconfirm

# Install AUR packages
for PKGNAME in ${AUR_PACKAGES[@]}; do cd /home/singleceller; mkdir -p packages/${PKGNAME}; cd packages/${PKGNAME}; aura -Aw ${PKGNAME}; tar -xf ${PKGNAME}.tar.gz; chmod -R a+wrX /home/singleceller/packages/${PKGNAME}; cd ${PKGNAME}; su singleceller -c makepkg; pacman -U $(ls "${PKGNAME}"-*.pkg.tar) --noconfirm; done

# Install AUR packages with fixed and split assets
for PKGNAME in ${AUR_PACKAGES_FIXED[@]}; do cd /home/singleceller; mkdir -p packages/${PKGNAME}; cd packages/${PKGNAME}; mkdir ${PKGNAME}; mv /assets/${PKGNAME}/PKGBUILD ${PKGNAME}/PKGBUILD; zcat /assets/${PKGNAME}/xa*.tar.gz > ${PKGNAME}/${PKGNAME}.tar.gz; chmod -R a+wrX /home/singleceller/packages/${PKGNAME}; cd ${PKGNAME}; su singleceller -c makepkg; pacman -U $(ls "${PKGNAME}"-*.pkg.tar) --noconfirm; done

# Remove cache and tmp files
pacman -Scc --noconfirm; rm -rf /home/singleceller/packages

