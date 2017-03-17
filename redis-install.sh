#!/bin/bash
######################################################
# redis installer
# written by George Liu (eva2000) centminmod.com
######################################################
# variables
#############
DT=`date +"%d%m%y-%H%M%S"`

OSARCH=$(uname -m)
######################################################
# functions
#############

if [ "$OSARCH" != 'x86_64' ]; then
  echo
  echo "64bit OS only"
  echo "aborting..."
  exit
fi

if [ ! -d /etc/systemd/system ]; then
  echo
  echo "systemd not detected aborting..."
  echo
  exit
fi

if [ ! -f /etc/yum.repos.d/remi.repo ]; then
  echo
  echo "redis REMI YUM repo not installed"
  echo "installing..."
  wget -cnv https://rpms.remirepo.net/enterprise/remi-release-7.rpm
  rpm -Uvh remi-release-7.rpm
fi

if [ ! -f /etc/yum.repos.d/epel.repo ]; then
  echo
  echo "epel YUM repo not installed"
  echo "installing..."
  yum -y install epel-release
fi

redisinstall() {
  echo "install redis server..."
  if [[ -f /etc/yum/pluginconf.d/priorities.conf && "$(grep 'enabled = 1' /etc/yum/pluginconf.d/priorities.conf)" ]]; then
    yum -y install redis --enablerepo=remi --disableplugin=priorities
  else
    yum -y install redis --enablerepo=remi
  fi
  sed -i 's|LimitNOFILE=.*|LimitNOFILE=262144|' /etc/systemd/system/redis.service.d/limit.conf
  echo "d      /var/run/redis/         0755 redis redis" > /etc/tmpfiles.d/redis.conf
  mkdir -p /var/run/redis
  chown redis:redis /var/run/redis
  chmod 755 /var/run/redis
  systemctl daemon-reload
  systemctl start redis
  systemctl enable redis
  if [[ "$(sysctl -n vm.overcommit_memory)" -ne '1' ]]; then
    echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
  fi
  echo never > /sys/kernel/mm/transparent_hugepage/enabled
  if [[ -z "$(grep 'transparent_hugepage\/enabled' /etc/rc.local)" ]]; then
    echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local
  fi
  sysctl -p
  echo "redis server installled"
}

######################################################

case "$1" in
  install )
    redisinstall
    ;;
  * )
    echo
    echo "Usage:"
    echo
    echo "$0 {install}"
    echo
    ;;
esac

exit