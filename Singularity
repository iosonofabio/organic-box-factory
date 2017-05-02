# Fabio Zanini <fabio DOT zanini AT stanford DOT edu>
bootstrap:docker
From:finalduty/archlinux:latest

%setup
    cp configure_image.sh "$SINGULARITY_ROOTFS/configure_image.sh"
    cp pipeline/pipeline.py "$SINGULARITY_ROOTFS/usr/bin/pipeline"

%post
    bash /configure_image.sh
    mkdir /mnt/singularity_bind

%runscript
    exec /usr/bin/pipeline "$@"
