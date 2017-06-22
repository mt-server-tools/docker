. /etc/lsb-release
echo "deb https://apt.dockerproject.org/repo ubuntu-$DISTRIB_CODENAME main" | sudo tee /etc/apt/sources.list.d/docker.list

KEYNAME=$(sudo apt-get update 2>&1 | grep -o -P "NO_PUBKEY .+" | cut -d' ' -f2|sort|uniq)
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$KEYNAME"

sudo apt-get update && sudo apt-get install -y docker-engine
sudo systemctl status docker
