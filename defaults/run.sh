#!/bin/bash
echo '    __                                              _ '
echo '   / /_  ____ _____  __  ______ _____  ____ __   __(_)'
echo '  / __ \/ __ `/ __ \/ / / / __ `/_  / / __ `/ | / / / '
echo ' / /_/ / /_/ / / / / /_/ / /_/ / / /_/ /_/ /| |/ / /  '
echo '/_.___/\__,_/_/ /_/\__, /\__,_/ /___/\__,_/ |___/_/   '
echo '                  /____/                              '
echo "TSharp: It's torr!-torrssen2-Transmission combined package"
echo

# Initial settings
if [ ! -d /home/banya/ ]; then
  ## Create user:group
  echo "Create a user as PUID=$PUID PGID=$PGID"
  echo "zavi:x:$PGID:" >> /etc/group
  echo "banya:x:$PUID:$PGID:banya:/home/banya:/bin/bash" >> /etc/passwd
  echo "banya:!::0:::::" >> /etc/shadow
  mkdir -p /home/banya
  chown banya:zavi -R /home/banya /root
  chmod 0755 -R /home/banya /root
fi
if [ ! -f /root/data/settings.json ]; then
  echo "Create Transmission settings"
  cp /defaults/settings.json /root/data/settings.json
  chown banya:zavi /root/data/settings.json
fi
if [ ! -f /var/www/html/torr/torr.php ]; then
  echo "Create It's torr!"
  wget https://raw.githubusercontent.com/banyazavi/tsharp/main/defaults/torr.php -O /var/www/html/torr/torr.php
fi
if [ -d /var/www/html/torr ]; then
  chown -R www-data:www-data /var/www/html/torr
  chmod -R 0777 /var/www/html/torr
fi
if [ ! -f /root/data/h2.mv.db ]; then
  echo "Create torrssen2 database for TSharp"
  wget https://github.com/banyazavi/tsharp/raw/main/defaults/h2.mv.db -O /root/data/h2.mv.db
  chown banya:zavi /root/data/h2.mv.db
fi

# Run Transmission & Nginx (PHP7)
su - banya -c "transmission-daemon -g /root/data"
service php7.4-fpm start
service nginx start

# Delete update cache & Refresh
if [ -f /tmp/torr.updatecheck ]; then
  echo "Delete the update checker of It's torr!"
  rm /tmp/torr.updatecheck
fi
echo "Refresh It's torr!"
wget -q --spider http://localhost/torr/torr.php

# Bootstrap torr
if [ arch == "x86_64" ]; then
  java -Xshareclasses -Xquickstart -jar /torrssen2.jar
else
  java -jar /torrssen2.jar
fi
