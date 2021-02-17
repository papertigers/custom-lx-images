#!/usr/bin/env bash

# $1 should be the image subdir
dp=$1

docker_img_raw=$(head -1 $dp/Dockerfile)
docker_img=${docker_img_raw/FROM /}

docker pull "$docker_img"

workingdir=$(docker inspect $docker_img -f '{{.Config.WorkingDir}}')
entrypoint=$(paste -sd ' ' < <(docker inspect $docker_img -f '{{range .Config.Entrypoint}}{{println .}}{{end}}'))
cmd=$(paste -sd ' ' < <(docker inspect $docker_img -f '{{range .Config.Cmd}}{{println .}}{{end}}'))
docker_env=$(docker inspect $docker_img -f '{{range .Config.Env}}{{println .}}{{end}}' | awk 'NF {print "export " $0}')

mkdir -p "$dp/helpers"
build_script="$dp/helpers/build.sh"

# basic setup for /sbin/init
cat <<EOF > "$build_script"
#!/bin/sh

exec </dev/null
exec 1> /var/log/lxinit.log
exec 2> /var/log/lxinit.log

set -ex

# this is a hack until the lx brand scripts get modified
echo "nameserver 10.0.1.2" > /etc/resolv.conf

EOF

cat <<< "$docker_env" >> "$build_script"
echo >> "$build_script"
echo "cd $workingdir" >> "$build_script"
echo "exec $entrypoint $cmd" >> "$build_script"




