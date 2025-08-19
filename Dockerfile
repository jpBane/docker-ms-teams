# References:
#   https://github.com/mdouchement/docker-zoom-us
FROM debian:bookworm
LABEL maintainer="slithy"

ENV DEBIAN_FRONTEND=noninteractive

# Refresh package lists
RUN apt-get update
RUN apt-get -qy dist-upgrade
RUN apt-get install -qy software-properties-common wget gnupg2 libcanberra-gtk-module libcanberra-gtk3-module pulseaudio epiphany-browser

# Add MS Teams repo
RUN wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted/gpg.d/
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
RUN apt-get update

# Install teams
RUN apt-get install -qy teams

# Copy scripts
COPY scripts/ /var/cache/ms-teams/
RUN mv /var/cache/ms-teams/teams /usr/bin/teams
RUN chmod 755 /usr/bin/teams
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
