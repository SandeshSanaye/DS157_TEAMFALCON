export DEBIAN_FRONTEND=noninteractive

# ----------------------------------------------------------------
# Install docker
# ----------------------------------------------------------------
apt-get -qq update
apt-get install -y docker.io

curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# ----------------------------------------------------------------
# Allow vagrant user to access docker
# ----------------------------------------------------------------
usermod -a -G docker vagrant