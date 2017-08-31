#!/bin/bash
######################################################
# redis installer
# written by George Liu (eva2000) centminmod.com
######################################################
# variables
#############
DT=$(date +"%d%m%y-%H%M%S")
REDIS_SOURCEVER='4.0.1'

OSARCH=$(uname -m)
SRCDIR=/svr-setup
######################################################
# functions
#############
if [ ! -d "$SRCDIR" ]; then
  mkdir -p "$SRCDIR"
fi

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

if [ -f /proc/user_beancounters ]; then
    CPUS=$(grep -c "processor" /proc/cpuinfo)
    if [[ "$CPUS" -gt '8' ]]; then
        CPUS=$(echo $(($CPUS+2)))
    else
        CPUS=$(echo $(($CPUS+1)))
    fi
    MAKETHREADS=" -j$CPUS"
else
    CPUS=$(grep -c "processor" /proc/cpuinfo)
    if [[ "$CPUS" -gt '8' ]]; then
        CPUS=$(echo $(($CPUS+4)))
    elif [[ "$CPUS" -eq '8' ]]; then
        CPUS=$(echo $(($CPUS+2)))
    else
        CPUS=$(echo $(($CPUS+1)))
    fi
    MAKETHREADS=" -j$CPUS"
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
  if [ -f /sys/kernel/mm/transparent_hugepage/enabled ]; then
    echo never > /sys/kernel/mm/transparent_hugepage/enabled
    if [[ -z "$(grep 'transparent_hugepage\/enabled' /etc/rc.local)" ]]; then
      echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local
    fi
  fi
  sysctl -p
  echo "redis server installled"
}

redisinstall_source() {
  echo "source install redis server..."
  export OPT=-03
  export CFLAGS="-march=native -pipe -funroll-loops -fvisibility=hidden -flto -fuse-ld=gold -gsplit-dwarf"
  export CXXFLAGS="$CFLAGS"
  cd "$SRCDIR"
  rm -rf redis-${REDIS_SOURCEVER}*
  wget http://download.redis.io/releases/redis-${REDIS_SOURCEVER}.tar.gz
  tar xzf redis-${REDIS_SOURCEVER}.tar.gz
  cd redis-${REDIS_SOURCEVER}
  make distclean
  make clean
  make${MAKETHREADS}
  make install
  echo "redis server source installled" 
}

######################################################

case "$1" in
  install )
    redisinstall
    ;;
  install-source )
    redisinstall_source
    ;;
  * )
    echo
    echo "Usage:"
    echo
    echo "$0 {install|install-source}"
    echo
    ;;
esac

exit