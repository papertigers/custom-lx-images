FROM ghcr.io/linuxserver/radarr:latest
COPY helpers /helpers
RUN cd /helpers; sh build.sh; cd /; rm -rf helpers
