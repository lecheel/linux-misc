#! /bin/bash
/sbin/ifconfig eth0 > /tmp/leip2
echo "public IP" >> /tmp/leip2
/usr/bin/curl ifconfig.me >> /tmp/leip2
date >> /tmp/leip2

#scp /tmp/leip lesrc.dyndns.org:/tmp
scp /tmp/leip2 lecheel.dyndns.org:/tmp/lesrc.ip
echo "send le ip address daily"

