#!/bin/bash
# chfn workaround - Known issue within Dockers
ln -s -f /bin/true /usr/bin/chfn

dpkg --add-architecture i386
sed 's#archive.ubuntu.com#us.archive.ubuntu.com#' -i /etc/apt/sources.list
apt-get -q update
apt-get install -qy wget libc6:i386 libncurses5:i386 libstdc++6:i386 unzip

TWONKY_URL=$(curl -sL http://twonky.com/downloads/ | sed -nr 's#.*href="(.+?/twonky-i686-glibc-.+?\.zip)".*#\1#p')
TWONKY_VERSION=$(echo $TWONKY_URL | sed -nr 's#.*twonky-i686-glibc-.+?-(.+?)\.zip.*#\1#p')
TWONKY_ZIP=/tmp/twonkyserver_${TWONKY_VERSION}.zip
TWONKY_DIR=/usr/local/twonky

wget -q "$TWONKY_URL" -O $TWONKY_ZIP

if [ $? -eq 0 ]; then
    mkdir -p $TWONKY_DIR
    unzip -d $TWONKY_DIR -o $TWONKY_ZIP
    rm -f $TWONKY_ZIP
    chmod 700 $TWONKY_DIR/twonkys* $TWONKY_DIR/cgi-bin/* $TWONKY_DIR/plugins/* $TWONKY_DIR/twonky.sh
    echo $TWONKY_VERSION > /tmp/version
fi

# Add Twonyserver to runit
mkdir -p /etc/service/twonky
cat <<'EOT' > /etc/service/twonky/run
#!/bin/bash
exec /usr/local/twonky/twonky.sh start
EOT
chmod +x /etc/service/twonky/run
