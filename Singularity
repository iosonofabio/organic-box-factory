# Fabio Zanini <fabio DOT zanini AT stanford DOT edu>
bootstrap:docker
From:finalduty/archlinux:latest

%setup
    cp -r assets "$SINGULARITY_ROOTFS/"
    cp configure_image.sh "$SINGULARITY_ROOTFS/configure_image.sh"

%post
    bash /configure_image.sh
    mkdir /mnt/singularity_bind

%runscript
    exec /usr/bin/bcl2fastq "$@"
