#!/usr/bin/env bash

set -ex

# $1 should be the image subdir
dp=$1

# Allow images to set custom inits
[[ -f "$dp/init" ]] && exit 0

docker_img_raw=$(head -1 $dp/Dockerfile)
docker_img=${docker_img_raw/FROM /}

docker pull "$docker_img"

workingdir=$(docker inspect $docker_img -f '{{.Config.WorkingDir}}')
entrypoint=$(paste -sd ' ' < <(docker inspect $docker_img -f '{{range .Config.Entrypoint}}{{println .}}{{end}}'))
cmd=$(paste -sd ' ' < <(docker inspect $docker_img -f '{{range .Config.Cmd}}{{println .}}{{end}}'))
docker_env=$(docker inspect $docker_img -f '{{range .Config.Env}}{{println .}}{{end}}' | awk 'NF {print "export " $0}')

lx_init="$dp/init"

# basic setup for /sbin/init
cat <<EOF > "$lx_init"
#!/bin/sh

exec </dev/null
exec 1>> /var/log/lxinit.log
exec 2>> /var/log/lxinit.log

echo "====== booting $(/bin/date) ======"

set -ex

# this is a hack until the lx brand scripts get modified
echo "nameserver 10.0.1.2" > /etc/resolv.conf

EOF

cat <<< "$docker_env" >> "$lx_init"

# Allow images to set custom env variables
if [[ -f "$dp/env" ]]; then
	echo "---- custom env overrides ----" >> "$lx_init"
	cat "$dp/env" >> "$lx_init"
fi

echo >> "$lx_init"
echo "cd $workingdir" >> "$lx_init"
echo "exec $entrypoint $cmd" >> "$lx_init"

chmod +x "$lx_init"
