#!/bin/bash
echo -e "sudo ./lesql \033[91mup/\033[92mdown\033[0m v0.1"

currentdir=`echo $PWD`

if [ "$1" = "up" ];then
#  cd /etc/apache2/conf.d/
#  ln -s -T /etc/phpmyadmin/apache.conf phpmyadmin.conf
  cd /etc/apache2/conf-enabled/
  ln -s -T /etc/phpmyadmin/apache.conf phpmyadmin.conf
  service apache2 reload
else if [ "$1" = "down" ];then
#  rm /etc/apache2/conf.d/phpmyadmin.conf
  rm /etc/apache2/conf-enabled/phpmyadmin.conf
  service apache2 reload

  else
    echo -e "\033[91mShutdown\033[0m lesql phpmyadmin "   
#    rm /etc/apache2/conf.d/phpmyadmin.conf
    rm /etc/apache2/conf-enabled/phpmyadmin.conf
    service apache2 reload
  fi
fi
cd `echo "$currentdir"`

exit 0
