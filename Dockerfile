FROM finalduty/archlinux:latest
MAINTAINER Fabio Zanini <fabio DOT zanini AT stanford DOT edu>
# Add assets to image
COPY assets /assets
# Configure image
COPY configure_image.sh /configure_image.sh
RUN /usr/bin/bash configure_image.sh
# Set ENTRYPOINT to run the Docker/Singularity image
ENTRYPOINT ["/usr/bin/bcl2fastq"]
