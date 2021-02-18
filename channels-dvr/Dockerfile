FROM alpine:latest
RUN mkdir -p /channels-dvr/data && mkdir -p /shares/DVR
RUN apk add --update\
	curl
COPY run.sh /
COPY init /sbin
