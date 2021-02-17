FROM ghcr.io/linuxserver/unifi-controller:latest
COPY helpers /helpers
RUN cd /helpers; sh build.sh; cd /; rm -rf helpers
