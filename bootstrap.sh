echo "*** Boostratpping... ***"

export DEBIAN_FRONTEND=noninteractive
apt-get install -q -y git > /dev/null
mkdir -p /srv
cd /srv
git clone -q https://github.com/intelmix/chef.git
cd /srv/chef
echo "*** Boostrap finished. ***"
source provision.sh

