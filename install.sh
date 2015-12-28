#!/bin/bash
# chfn workaround - Known issue within Dockers
ln -s -f /bin/true /usr/bin/chfn

sed 's#archive.ubuntu.com#us.archive.ubuntu.com#' -i /etc/apt/sources.list
apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"
apt-get install -qy wget unzip

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
    chmod 700 $TWONKY_DIR/twonkys* $TWONKY_DIR/cgi-bin/* $TWONKY_DIR/plugins/*
    useradd twonky -c "Twonkyserver" -d /config -g 100 -M -u 99 -s /bin/bash -p $(openssl rand -base64 32)
    chown -R twonky:users $TWONKY_DIR
    mkdir -p /config/.twonky
    chown -R twonky:users /config
    echo $TWONKY_VERSION > /tmp/version
fi

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man

# End
