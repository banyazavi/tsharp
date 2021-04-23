#!/bin/bash
echo '    __                                              _ '
echo '   / /_  ____ _____  __  ______ _____  ____ __   __(_)'
echo '  / __ \/ __ `/ __ \/ / / / __ `/_  / / __ `/ | / / / '
echo ' / /_/ / /_/ / / / / /_/ / /_/ / / /_/ /_/ /| |/ / /  '
echo '/_.___/\__,_/_/ /_/\__, /\__,_/ /___/\__,_/ |___/_/   '
echo '                  /____/                              '
echo "T#: It's torr!-torrssen2-Transmission combined package"
echo

# Initial settings
if [ ! -d /home/banya/ ]; then
  ## Create user:group
  echo "zavi:x:$PGID:" >> /etc/group
  echo "banya:x:$PUID:$PGID:banya:/home/banya:/bin/bash" >> /etc/passwd
  echo "banya:!::0:::::" >> /etc/shadow

  mkdir -p /home/banya
  chown banya:zavi -R /home/banya /root
  chmod 0755 -R /home/banya /root
fi
if [ ! -f /root/data/settings.json ]; then
  cp /defaults/settings.json /root/data/settings.json
  chown banya:zavi /root/data/settings.json
fi
if [ ! -f /root/data/h2.mv.db ]; then
  cp /defaults/h2.mv.db /root/data/h2.mv.db
  chown banya:zavi /root/data/h2.mv.db
fi
if [ -f /var/www/html/torr/UserConfig.php ]; then
  chown www-data:www-data /var/www/html/torr/UserConfig.php
  chmod 0777 /var/www/html/torr/UserConfig.php
fi

# Run Transmission & Nginx (PHP7)
su - banya -c "/usr/bin/transmission-daemon -g /root/data"
service php7.4-fpm start
service nginx start

# Delete update cache & Refresh
rm /tmp/torr.updatecheck
rm /tmp/torr-userconfig.updatecheck
wget -q --spider http://localhost/torr/torr.php

# Bootstrap torr
/opt/java/openjdk/bin/java -Xshareclasses -Xquickstart -jar /torrssen2.jar
