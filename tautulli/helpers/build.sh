#!/bin/sh

#echo "setting entry point at /sbin/init"
cat <<EOF > /sbin/init
#!/bin/sh

# this is a hack until the lx brand scripts get modified
echo "nameserver 10.0.1.2" > /etc/resolv.conf

cd /app
exec /bin/bash -c "./start.sh" >> /dev/console 2>&1
EOF

chmod +x /sbin/init
