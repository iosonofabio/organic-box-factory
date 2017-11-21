#!/bin/sh
# Install pacman packages
echo 'Server = http://mirror.us.leaseweb.net/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist; echo 'Server = http://archlinux.polymorf.fr/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar'/" /etc/makepkg.conf
pacman -Syu --noconfirm
pacman --noconfirm -S make gcc binutils gzip fakeroot wget python2 python2-numpy

# Install aura
useradd -m -g users -G wheel -s /bin/bash nonroot
cd /home/nonroot; mkdir -p packages/aura; cd packages/aura; wget https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz; tar -xvf aura-bin.tar.gz; cd aura-bin; chmod -R a+wrX /home/nonroot/packages/aura; su nonroot -c makepkg; pacman -U $(ls aura-bin-*-x86_64.pkg.tar) --noconfirm

# Install STAMPY
for PKGNAME in 'stampy'; do cd /home/nonroot; mkdir -p packages/${PKGNAME}; cd packages/${PKGNAME}; aura -Aw ${PKGNAME}; tar -xf ${PKGNAME}.tar.gz; chmod -R a+wrX /home/nonroot/packages/${PKGNAME}; cd ${PKGNAME}; su nonroot -c makepkg; pacman -U $(ls "${PKGNAME}"-*.pkg.tar) --noconfirm; done
pacman -Scc --noconfirm; rm -rf /home/nonroot/packages
# This is a bug in stampy makepkg
unlink /usr/bin/stampy; ln -s /opt/$(ls /opt)/stampy.py /usr/bin/stampy
