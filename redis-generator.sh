#!/bin/bash
######################################################
# for centos 7 only
# written by George Liu (eva2000) centminmod.com
######################################################
# variables
#############
VER=0.2
DT=`date +"%d%m%y-%H%M%S"`

STARTPORT=6479
DEBUG_REDISGEN='y'
INSTALLDIR='/svr-setup'
######################################################
# functions
#############
if [ ! -d "$INSTALLDIR" ]; then
  mkdir -p "$INSTALLDIR"
fi

if [ ! -f /usr/lib/systemd/system/redis.service ]; then
  echo
  echo "/usr/lib/systemd/system/redis.service not found"
  echo "Script is for CentOS 7 only and requires redis"
  echo "server installed first"
  echo
  exit
fi

if [[ -f /etc/systemd/system/redis.service.d/limit.conf && ! "$(grep 262144 /etc/systemd/system/redis.service.d/limit.conf)" ]]; then
  sed -i 's|LimitNOFILE=.*|LimitNOFILE=262144|' /etc/systemd/system/redis.service.d/limit.conf
fi

redis_cluster_install() {
  UPDATE=$1
  if [[ ! -f /usr/local/bin/redis-cluster-tool || "$UPDATE" = 'update' ]]; then
    echo
    echo "install redis-cluster-tool"
    echo "https://github.com/deep011/redis-cluster-tool"
    echo
    echo "hiredis-vip install"
    cd "$INSTALLDIR"
    rm -rf hiredis-vip
    git clone https://github.com/vipshop/hiredis-vip.git
    cd hiredis-vip
    make -s clean
    make -s >/dev/null 2>&1
    make install
    ldconfig
    
    echo
    echo "redis-cluster-tool install"
    cd "$INSTALLDIR"
    rm -rf redis-cluster-tool
    git clone https://github.com/deep011/redis-cluster-tool.git
    cd redis-cluster-tool
    make -s clean
    make -s >/dev/null 2>&1
    make install
    echo "redis-cluster-tool -h"
    redis-cluster-tool -h
  else
    echo "redis-cluster-tool already installed"
  fi
}

genredis_del() {
  # increment starts at 0
  NUMBER=$(($1-1))
  if [[ "$NUMBER" -le '1' ]]; then
    NUMBER=1
  fi
  echo
  # echo "Deleting redis servers starting at TCP = $STARTPORT..."
  for (( p=0; p <= $NUMBER; p++ ))
    do
      REDISPORT=$(($STARTPORT+$p))
    if [ -f "/usr/lib/systemd/system/redis${REDISPORT}.service" ]; then
      echo "-------------------------------------------------------"
      echo "Deleting redis${REDISPORT}.service ..."
      systemctl disable redis${REDISPORT}.service
      systemctl stop redis${REDISPORT}.service
      rm -rf "/usr/lib/systemd/system/redis${REDISPORT}.service"
    fi
    if [ -f "/etc/redis${REDISPORT}/redis${REDISPORT}.conf" ]; then
      rm -rf "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
    fi
    if [ -f "/var/log/redis/redis${REDISPORT}.log" ]; then
      rm -rf "/var/log/redis/redis${REDISPORT}.log"
    fi
    if [ -f "/var/lib/redis/dump${REDISPORT}.rdb" ]; then
      rm -rf "/var/lib/redis/dump${REDISPORT}.rdb"
    fi
    if [ -f "/var/lib/redis/appendonly${REDISPORT}.aof" ]; then
      rm -rf "/var/lib/redis/appendonly${REDISPORT}.aof"
    fi
    rm -rf "/var/lib/redis${REDISPORT}"
  done
  echo "Deletion completed"
  exit
}

genredis() {
  CLUSTER=$2
  # increment starts at 0
  NUMBER=$(($1-1))
  if [[ "$NUMBER" -le '1' ]]; then
    NUMBER=1
  fi
  echo
  echo "Creating redis servers starting at TCP = $STARTPORT..."
  for (( p=0; p <= $NUMBER; p++ ))
    do
      REDISPORT=$(($STARTPORT+$p))
      echo "-------------------------------------------------------"
      echo "creating redis server: redis${REDISPORT}.service [increment value: $p]"
      echo "redis TCP port: $REDISPORT"
      if [[ "$DEBUG_REDISGEN" = [yY] ]]; then
        if [ ! -f "/usr/lib/systemd/system/redis${REDISPORT}.service" ]; then
          echo "create systemd redis${REDISPORT}.service"
          echo "cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis${REDISPORT}.service"
        else
          echo "/usr/lib/systemd/system/redis${REDISPORT}.service already exists"
        fi
        if [ ! -f "/etc/redis${REDISPORT}/redis${REDISPORT}.conf" ]; then
          echo "create /etc/redis${REDISPORT}/redis${REDISPORT}.conf config file"
          echo "mkdir -p "/etc/redis${REDISPORT}""
          echo "cp -a /etc/redis.conf /etc/redis${REDISPORT}/redis${REDISPORT}.conf"
        else
          echo "/etc/redis${REDISPORT}/redis${REDISPORT}.conf already exists"
        fi
        if [ -f /etc/systemd/system/redis.service.d/limit.conf ]; then
          echo "mkdir -p "/etc/systemd/system/redis${REDISPORT}.service.d/""
          echo "\cp -af /etc/systemd/system/redis.service.d/limit.conf "/etc/systemd/system/redis${REDISPORT}.service.d/limit.conf""
        fi
        if [[ -f "/etc/redis${REDISPORT}/redis${REDISPORT}.conf" && ! "$(grep "dump${REDISPORT}.rdb" /etc/redis${REDISPORT}/redis${REDISPORT}.conf)" ]] || [[ "$DEBUG_REDISGEN" = [yY] ]]; then
          echo "sed -i \"s|^port 6379|port $REDISPORT|\" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
          echo "mkdir -p "/var/lib/redis${REDISPORT}""
          echo "chown -R redis:redis "/var/lib/redis${REDISPORT}""
          echo "\cp -af /usr/bin/redis-server "/etc/redis${REDISPORT}/redis-server""
          echo "sed -i \"s|\/usr\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|\" "/usr/lib/systemd/system/redis${REDISPORT}.service""
          echo "sed -i \"s|dir \/var\/lib\/redis\/|dir \/var\/lib\/redis${REDISPORT}|\" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
          echo "sed -i 's|^daemonize no|daemonize yes|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
          echo "sed -i \"s|cluster-config-file nodes-6379.conf|cluster-config-file nodes-${REDISPORT}.conf|\" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
          echo "sed -i \"s|unixsocket \/tmp\/redis.sock|unixsocket \/var\/run\/redis\/redis${REDISPORT}.sock|\" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
          echo "sed -i \"s|pidfile \/var\/run\/redis_6379.pid|pidfile \/var\/run\/redis\/redis_${REDISPORT}.pid|\" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
          echo "sed -i \"s|\/var\/log\/redis\/redis.log|\/var\/log\/redis\/redis${REDISPORT}.log|\" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
          echo "sed -i \"s|dbfilename dump.rdb|dbfilename dump${REDISPORT}.rdb|\" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
          echo "sed -i \"s|appendfilename \"appendonly.aof\"|appendfilename \"appendonly${REDISPORT}.aof\"|\" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
          echo "echo \"#masterauth abc123\" >> "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
          echo "sed -i \"s|\/etc\/redis.conf|\/etc\/redis${REDISPORT}\/redis${REDISPORT}.conf|\" "/usr/lib/systemd/system/redis${REDISPORT}.service""
          # enable redis cluster settings
          if [[ "$CLUSTER" = 'cluster' ]]; then
            echo "\cp -af /usr/bin/redis-server "/etc/redis${REDISPORT}/redis-server""
            echo "sed -i \"s|\/usr\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|\" "/usr/lib/systemd/system/redis${REDISPORT}.service""
            echo "sed -i 's|^# cluster-enabled yes|cluster-enabled yes|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
            echo "sed -i \"s|^# cluster-config-file nodes-${REDISPORT}.conf|cluster-config-file nodes-${DT}.conf|\" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
            echo "sed -i \"s|^# cluster-node-timeout 15000|cluster-node-timeout 5000|\" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
            echo "sed -i 's|^appendonly no|appendonly yes|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
            echo "enabled cluster mode with cluster-config-file nodes-${DT}.conf"
          fi
          echo "systemctl daemon-reload"
          echo "systemctl restart redis${REDISPORT}"
          echo "systemctl enable redis${REDISPORT}"
          echo "Redis TCP $REDISPORT Info:"
          echo "redis-cli -h 127.0.0.1 -p $REDISPORT INFO SERVER"
          if [[ "$CLUSTER" = 'cluster' ]]; then
            echo "redis-cli -h 127.0.0.1 -p $REDISPORT INFO CLUSTER"
          fi
        fi
      else
        if [ ! -f "/usr/lib/systemd/system/redis${REDISPORT}.service" ]; then
          echo "create systemd redis${REDISPORT}.service"
          echo "cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis${REDISPORT}.service"
          cp -a /usr/lib/systemd/system/redis.service "/usr/lib/systemd/system/redis${REDISPORT}.service"
        else
          echo "/usr/lib/systemd/system/redis${REDISPORT}.service already exists"
        fi
        if [ ! -f "/etc/redis${REDISPORT}/redis${REDISPORT}.conf" ]; then
          echo "create /etc/redis${REDISPORT}/redis${REDISPORT}.conf config file"
          echo "mkdir -p "/etc/redis${REDISPORT}""
          echo "cp -a /etc/redis.conf /etc/redis${REDISPORT}/redis${REDISPORT}.conf"
          mkdir -p "/etc/redis${REDISPORT}"
          cp -a /etc/redis.conf "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
        else
          echo "/etc/redis${REDISPORT}/redis${REDISPORT}.conf already exists"
        fi
        if [ -f /etc/systemd/system/redis.service.d/limit.conf ]; then
          mkdir -p "/etc/systemd/system/redis${REDISPORT}.service.d/"
          \cp -af /etc/systemd/system/redis.service.d/limit.conf "/etc/systemd/system/redis${REDISPORT}.service.d/limit.conf"
        fi
        ls -lah "/usr/lib/systemd/system/redis${REDISPORT}.service" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
        if [[ -f "/etc/redis${REDISPORT}/redis${REDISPORT}.conf" && ! "$(grep "dump${REDISPORT}.rdb" /etc/redis${REDISPORT}/redis${REDISPORT}.conf)" ]]; then
          sed -i "s|^port 6379|port $REDISPORT|" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
          mkdir -p "/var/lib/redis${REDISPORT}"
          chown -R redis:redis "/var/lib/redis${REDISPORT}"
          \cp -af /usr/bin/redis-server "/etc/redis${REDISPORT}/redis-server"
          sed -i "s|\/usr\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|" "/usr/lib/systemd/system/redis${REDISPORT}.service"
          sed -i "s|dir \/var\/lib\/redis\/|dir \/var\/lib\/redis${REDISPORT}|" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
          sed -i 's|^daemonize no|daemonize yes|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
          sed -i "s|cluster-config-file nodes-6379.conf|cluster-config-file nodes-${REDISPORT}.conf|" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
          sed -i "s|unixsocket \/tmp\/redis.sock|unixsocket \/var\/run\/redis\/redis${REDISPORT}.sock|" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
          sed -i "s|pidfile \/var\/run\/redis_6379.pid|pidfile \/var\/run\/redis\/redis_${REDISPORT}.pid|" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
          sed -i "s|\/var\/log\/redis\/redis.log|\/var\/log\/redis\/redis${REDISPORT}.log|" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
          sed -i "s|dbfilename dump.rdb|dbfilename dump${REDISPORT}.rdb|" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
          sed -i "s|appendfilename \"appendonly.aof\"|appendfilename \"appendonly${REDISPORT}.aof\"|" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
          echo "#masterauth abc123" >> "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
          sed -i "s|\/etc\/redis.conf|\/etc\/redis${REDISPORT}\/redis${REDISPORT}.conf|" "/usr/lib/systemd/system/redis${REDISPORT}.service"
          # enable redis cluster settings
          if [[ "$CLUSTER" = 'cluster' ]]; then
            \cp -af /usr/bin/redis-server "/etc/redis${REDISPORT}/redis-server"
            sed -i "s|\/usr\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|" "/usr/lib/systemd/system/redis${REDISPORT}.service"
            sed -i 's|^# cluster-enabled yes|cluster-enabled yes|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
            sed -i "s|^# cluster-config-file nodes-${REDISPORT}.conf|cluster-config-file nodes-${DT}.conf|" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
            sed -i "s|^# cluster-node-timeout 15000|cluster-node-timeout 5000|" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
            sed -i 's|^appendonly no|appendonly yes|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
            echo "enabled cluster mode with cluster-config-file nodes-${DT}.conf"
          fi
          systemctl daemon-reload
          systemctl restart redis${REDISPORT}
          systemctl enable redis${REDISPORT}
          echo "## Redis TCP $REDISPORT Info ##"
          redis-cli -h 127.0.0.1 -p $REDISPORT INFO SERVER
          if [[ "$CLUSTER" = 'cluster' ]]; then
            redis-cli -h 127.0.0.1 -p $REDISPORT INFO CLUSTER
          fi
        fi
      fi
  done
}

######################################################
NUM=$1
WIPE=$2
CLUSTER=$2

if [[ "$NUM" = 'prep' && "$WIPE" = 'update' ]]; then
  redis_cluster_install update
  PREP=y
elif [[ "$NUM" = 'prep' ]]; then
  redis_cluster_install
  PREP=y
fi

if [[ "$NUM" != 'prep' ]] && [[ "$CLUSTER" = 'cluster' ]] && [[ ! -z "$NUM" && "$NUM" -eq "$NUM" ]]; then
  if [ "$NUM" -lt '6' ]; then
    echo
    echo "minimum of 3 master nodes are required for redis"
    echo "cluster configuration so minimum 6 redis servers"
    echo "i.e. 3x master/slave redis nodes"
    echo
    echo "$0 6 cluster"
    exit
  fi
  genredis $NUM cluster
elif [[ "$NUM" != 'prep' ]] && [[ "$WIPE" = 'delete' ]] && [[ ! -z "$NUM" && "$NUM" -eq "$NUM" ]]; then
  genredis_del $NUM
elif [[ "$NUM" != 'prep' ]] && [[ ! -z "$NUM" && "$NUM" -eq "$NUM" ]]; then
  # NUM is a number
  genredis $NUM
elif [[ "$PREP" != 'y' ]]; then
  echo
  echo "* Usage where X equal postive integer for number of redis"
  echo "  servers to create with incrementing TCP redis ports"
  echo "  starting at STARTPORT=6479."
  echo "* Append delete flag to remove"
  echo "* Append cluster flag to enable cluster mode"
  echo "* standalone prep command installs redis-cluster-tool"
  echo "* standalone prep update command updates redis-cluster-tool"
  echo
  echo "$0 X"
  echo "$0 X delete"
  echo "$0 X cluster"
  echo "$0 prep"
  echo "$0 prep update"
fi