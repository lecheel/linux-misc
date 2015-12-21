#! /bin/bash
DATE=`date +%Y%m%d%H`+---
echo -n $DATE >> /var/www/lenum/daily.log
echo -n `head -1 /var/www/lenum/hits01.txt` >> /var/www/lenum/daily.log
DATE1=`date +%d/%b`
grep -E -o ".{0,40}vchun_banner03" /var/log/apache2/access.log|grep $DATE1|wc -l >> /var/www/lenum/daily.log

