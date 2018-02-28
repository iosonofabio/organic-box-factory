#!/bin/sh
# Install pacman packages
echo 'Server = http://mirror.us.leaseweb.net/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist; echo 'Server = http://archlinux.polymorf.fr/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar'/" /etc/makepkg.conf
pacman -Syu --noconfirm
pacman --noconfirm -S make gcc binutils gzip abs fakeroot wget python python-numpy python-matplotlib cmake python-pytest doxygen python-setuptools python-sphinx

# Install aura
useradd -m -g users -G wheel -s /bin/bash obf
cd /home/obf; mkdir -p packages/aura; cd packages/aura; wget https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz; tar -xvf aura-bin.tar.gz; cd aura-bin; chmod -R a+wrX /home/obf/packages/aura; su obf -c makepkg; pacman -U aura-bin-*-x86_64.pkg.tar --noconfirm

# Install AUR packages
for PKGNAME in 'python-breathe' 'pybind11' 'expressionmatrix2-git'; do cd /home/obf; mkdir -p packages/${PKGNAME}; cd packages/${PKGNAME}; aura -Aw ${PKGNAME}; tar -xf ${PKGNAME}.tar.gz; chmod -R a+wrX /home/obf/packages/${PKGNAME}; cd ${PKGNAME}; su obf -c makepkg; pacman -U $(ls "${PKGNAME}"-*.pkg.tar) --noconfirm; done
pacman -Scc --noconfirm; rm -rf /home/obf/packages

