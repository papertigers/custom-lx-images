#!/bin/sh
set -e
if [ ! -x /channels-dvr/latest/channels-dvr ]; then
  echo Installing Channels DVR..
  curl -f -s https://getchannels.com/dvr/setup.sh | DOWNLOAD_ONLY=1 sh
fi
cd /channels-dvr/data
echo Running Channels DVR..
exec ../latest/channels-dvr >> channels-dvr.log 2>&1
