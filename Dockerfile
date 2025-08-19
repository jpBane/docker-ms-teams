# References:
#   https://github.com/mdouchement/docker-zoom-us
FROM debian:bullseye
LABEL maintainer="slithy"

ENV DEBIAN_FRONTEND=noninteractive

# Refresh package lists
RUN apt update
RUN apt -qy full-upgrade
RUN apt install -qy software-properties-common curl libcanberra-gtk-module libcanberra-gtk3-module pulseaudio epiphany-browser

# Add MS Teams repo
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
RUN apt-add-repository 'deb https://packages.microsoft.com/repos/ms-teams stable main'
RUN apt update

# Install teams
RUN apt install -qy teams

# Copy scripts
COPY scripts/ /var/cache/ms-teams/
RUN mv /var/cache/ms-teams/teams /usr/bin/teams
RUN chmod 755 /usr/bin/teams
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
