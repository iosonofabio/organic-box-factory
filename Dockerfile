FROM finalduty/archlinux:latest
MAINTAINER Fabio Zanini <fabio DOT zanini AT stanford DOT edu>
RUN pacman -Syu vim --noconfirm; pacman -Scc --noconfirm
