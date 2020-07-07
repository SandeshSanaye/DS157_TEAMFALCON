# Copy the config files
cp docker  /etc/default
cp docker.service /lib/systemd/system/
systemctl daemon-reload
systemctl restart docker
service docker restart