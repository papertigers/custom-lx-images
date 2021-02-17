FROM ghcr.io/linuxserver/sonarr:latest
COPY helpers /helpers
RUN cd /helpers; sh build.sh; cd /; rm -rf helpers
