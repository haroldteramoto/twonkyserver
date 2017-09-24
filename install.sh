#!/bin/bash

# Configure user nobody to match unRAID's settings
export DEBIAN_FRONTEND="noninteractive"
groupmod -g 100 users
usermod -u 99 nobody
usermod -g 100 nobody
usermod -d /config nobody
chown -R nobody:users /config

# Disable SSH
rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

#########################################
##  FILES, SERVICES AND CONFIGURATION  ##
#########################################
# Twonkyserver
mkdir -p /etc/service/twonky
cat <<'EOT' > /etc/service/twonky/run
#!/bin/bash
exec /sbin/setuser nobody /usr/local/twonky/twonkyserver
EOT

chmod -R +x /etc/service/ /etc/my_init.d/

#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################
add-apt-repository -y ppa:jonathonf/ffmpeg-3
apt-get update -qq
apt-get install -qy --force-yes wget unzip
apt-get install -y libavfilter6 libopencv-core2.4 libavdevice57 ffmpeg

TWONKY_URL=$(curl -sL http://twonky.com/downloads/ | sed -nr 's#.*href="(.+?/twonky-i686-glibc-.+?\.zip)".*#\1#p')
TWONKY_VERSION=$(echo $TWONKY_URL | sed -nr 's#.*twonky-i686-glibc-.+?-(.+?)\.zip.*#\1#p')
TWONKY_URL=$(curl -sL http://twonkyforum.com/downloads/$TWONKY_VERSION/ | sed -nr 's#.*href="(twonky-x86-64-glibc-.+?\.zip)".*#http://twonkyforum.com/downloads/'$TWONKY_VERSION'/\1#p')
TWONKY_ZIP=/tmp/twonkyserver_$TWONKY_VERSION.zip
TWONKY_DIR=/usr/local/twonky

wget -q "$TWONKY_URL" -O $TWONKY_ZIP

if [ $? -eq 0 ]; then
    mkdir -p $TWONKY_DIR
    unzip -d $TWONKY_DIR -o $TWONKY_ZIP
    rm -f $TWONKY_ZIP
    cp /usr/bin/ffmpeg $TWONKY_DIR/cgi-bin/.
    chmod -R +x $TWONKY_DIR
    chown -R nobody:users $TWONKY_DIR
    mkdir -p /config/.twonky
    chown -R nobody:users /config
fi

#########################################
##                 CLEANUP             ##
#########################################
# Clean APT install files
apt-get clean -y
rm -rf /var/lib/apt/lists/* /var/cache/* /var/tmp/* /tmp/*
