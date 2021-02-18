FROM alpine:latest
RUN mkdir -p /channels-dvr/data && mkdir -p /shares/DVR
RUN apk add --update\
	curl \
	tzdata && rm -rf /var/cache/apk/*
COPY run.sh /
COPY init /sbin
