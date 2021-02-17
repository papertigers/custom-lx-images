FROM tautulli/tautulli:latest
COPY helpers /helpers
RUN cd /helpers; sh build.sh; cd /; rm -rf helpers
