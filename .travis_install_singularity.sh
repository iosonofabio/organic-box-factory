#!/bin/bash
pkgname='singularity-container'
pkgver=2.4.2

echo "Install deps"
sudo apt-get install squashfs-tools

echo "Download"
mkdir ${pkgname}
cd ${pkgname}
wget https://github.com/singularityware/singularity/releases/download/${pkgver}/singularity-${pkgver}.tar.gz

echo "Extract tar.gz"
tar -xvf singularity-${pkgver}.tar.gz

echo "Configure"
cd singularity-${pkgver}
./autogen.sh
./configure --prefix='/usr/local'

echo "Compile"
make

echo "Install"
sudo make install
