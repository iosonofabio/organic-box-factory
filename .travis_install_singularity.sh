#!/bin/bash
pkgname='singularity-container'
pkgver=2.2.1

echo "Download"
mkdir ${pkgname}
cd ${pkgname}
wget https://github.com/gmkurtzer/singularity/archive/${pkgver}.tar.gz

echo "Extract tar.gz"
tar -xvf ${pkgver}.tar.gz

echo "Configure"
cd singularity-${pkgver}
./autogen.sh
./configure --prefix='/usr/local'

echo "Compile"
make

echo "Install"
sudo make install
