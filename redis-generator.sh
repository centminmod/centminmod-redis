#!/bin/bash
######################################################
# https://github.com/centminmod/centminmod-redis
# for centos 7 only
# written by George Liu (eva2000) centminmod.com
######################################################
# variables
#############
VER=1.2
DT=`date +"%d%m%y-%H%M%S"`

STARTPORT=6479
DEBUG_REDISGEN='y'
UNIXSOCKET='n'
SENTINEL_SETUP='y'

# redis source install supported variables where
# redis-server binary at /usr/local/bin/redis-server
USE_SOURCEREDIS='n'

INSTALLDIR='/svr-setup'
SENTDIR='/root/tools/redis-sentinel'
######################################################
# functions
#############
if [ ! -d "$INSTALLDIR" ]; then
  mkdir -p "$INSTALLDIR"
fi

if [ ! -d ${SENTDIR} ]; then
  mkdir -p ${SENTDIR}
fi

if [ ! -f /bin/bc ]; then
  yum -q -y install bc
fi

if [[ "$USE_SOURCEREDIS" = [yY] && -f /usr/local/bin/redis-server && /usr/libexec/redis-shutdown ]]; then
  REDISBINARY='/usr/local/bin/redis-server'
  if [ -f /usr/libexec/redis-shutdown ]; then
    \cp -af /usr/libexec/redis-shutdown /usr/local/bin/redis-shutdown
    sed -i 's|REDIS_CLI=\/usr\/bin\/redis-cli|REDIS_CLI=\/usr\/local\/bin\/redis-cli|' /usr/local/bin/redis-shutdown
  fi
else
  REDISBINARY='/usr/bin/redis-server'
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
  NUMBER_SENTINELS=2
  if [[ "$NUMBER" -le '1' ]]; then
    NUMBER=1
  fi
  echo
  # echo "Deleting redis servers starting at TCP = $STARTPORT..."
  for (( p=0; p <= $NUMBER; p++ ))
    do
      REDISPORT=$(($STARTPORT+$p))
      SENTPORT=$(($REDISPORT+10000))
    if [ -f "/usr/lib/systemd/system/redis${REDISPORT}.service" ]; then
      echo "-------------------------------------------------------"
      echo "Deleting redis${REDISPORT}.service ..."
      if [[ "$DEBUG_REDISGEN" = [yY] ]]; then
        echo "systemctl disable redis${REDISPORT}.service"
        echo "systemctl stop redis${REDISPORT}.service"
        echo "rm -rf "/usr/lib/systemd/system/redis${REDISPORT}.service""
      else
        systemctl disable redis${REDISPORT}.service
        systemctl stop redis${REDISPORT}.service
        rm -rf "/usr/lib/systemd/system/redis${REDISPORT}.service"
      fi
    fi
    if [ -f "/etc/redis${REDISPORT}/redis${REDISPORT}.conf" ]; then
      if [[ "$DEBUG_REDISGEN" = [yY] ]]; then
        echo "rm -rf "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
      else
        rm -rf "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
      fi
    fi
    if [ -f "/var/log/redis/redis${REDISPORT}.log" ]; then
      if [[ "$DEBUG_REDISGEN" = [yY] ]]; then
        echo "rm -rf "/var/log/redis/redis${REDISPORT}.log""
      else
        rm -rf "/var/log/redis/redis${REDISPORT}.log"
      fi
    fi
    if [ -f "/var/lib/redis/dump${REDISPORT}.rdb" ]; then
      if [[ "$DEBUG_REDISGEN" = [yY] ]]; then
        echo "rm -rf "/var/lib/redis/dump${REDISPORT}.rdb""
      else
        rm -rf "/var/lib/redis/dump${REDISPORT}.rdb"
      fi
    fi
    if [ -f "/var/lib/redis/appendonly${REDISPORT}.aof" ]; then
      if [[ "$DEBUG_REDISGEN" = [yY] ]]; then
        echo "rm -rf "/var/lib/redis/appendonly${REDISPORT}.aof""
      else
        rm -rf "/var/lib/redis/appendonly${REDISPORT}.aof"
      fi
    fi
    for (( sp=0; sp <= $NUMBER_SENTINELS; sp++ ))
      do
      SENTPORT=$(($REDISPORT+10000+$sp))
    if [ -f "${SENTDIR}/sentinel-${SENTPORT}.conf" ]; then
      if [[ "$DEBUG_REDISGEN" = [yY] ]]; then
        echo "rm -rf "${SENTDIR}/sentinel-${SENTPORT}.conf""
      else
        rm -rf "${SENTDIR}/sentinel-${SENTPORT}.conf"
      fi
    fi
    if [ -d "/var/lib/redis/sentinel_${SENTPORT}" ]; then
      if [[ "$DEBUG_REDISGEN" = [yY] ]]; then
        echo "rm -rf "/var/lib/redis/sentinel_${SENTPORT}""
      else
        rm -rf "/var/lib/redis/sentinel_${SENTPORT}"
      fi
    fi
    if [ -f "/var/log/redis/sentinel-${SENTPORT}.log" ]; then
      if [[ "$DEBUG_REDISGEN" = [yY] ]]; then
        echo "rm -rf "/var/log/redis/sentinel-${SENTPORT}.log""
      else
        rm -rf "/var/log/redis/sentinel-${SENTPORT}.log"
      fi
    fi
    if [ -f "/var/run/redis/redis-sentinel-${SENTPORT}.pid" ]; then
      if [[ "$DEBUG_REDISGEN" = [yY] ]]; then
        echo "kill -9 $(cat "/var/run/redis/redis-sentinel-${SENTPORT}.pid")"
        echo "rm -rf "/var/run/redis/redis-sentinel-${SENTPORT}.pid""
      else
        kill -9 $(cat "/var/run/redis/redis-sentinel-${SENTPORT}.pid")
        rm -rf "/var/run/redis/redis-sentinel-${SENTPORT}.pid"
      fi
    fi
    if [ -f "/etc/init.d/sentinel_${SENTPORT}" ]; then
      if [[ "$DEBUG_REDISGEN" = [yY] ]]; then
        echo "rm -rf "/etc/init.d/sentinel_${SENTPORT}""
      else
        rm -rf "/etc/init.d/sentinel_${SENTPORT}"
      fi
    fi
    done

    if [ -d "/var/lib/redis${REDISPORT}" ]; then
      if [[ "$DEBUG_REDISGEN" = [yY] ]]; then
        echo "rm -rf "/var/lib/redis${REDISPORT}""
      else
        rm -rf "/var/lib/redis${REDISPORT}"
      fi
    fi
  done
  echo "Deletion completed"
  exit
}

genredis() {
  CLUSTER=$2
  CLUSTER_CREATE=$3
  # increment starts at 0
  NUMBER=$(($1-1))
  NUMBER_SENTINELS=2
  QUORUM=2
  # QUORUM=$(echo "$1*0.5045" | bc)
  # QUORUM=$(printf "%1.f\n" $QUORUM)
  if [[ "$NUMBER" -le '1' ]]; then
    NUMBER=1
  fi
  # if [[ "$QUORUM" -eq '1' ]]; then
  #   QUORUM=2
  # fi
  echo
  if [[ "$CLUSTER_CREATE" = 'repcache' ]]; then
    echo "Creating redis servers (with ondisk persistence disabled) starting at TCP = $STARTPORT..."
  else
    echo "Creating redis servers starting at TCP = $STARTPORT..."
  fi
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
          echo "\cp -af "$REDISBINARY" "/etc/redis${REDISPORT}/redis-server""
          if [[ "$USE_SOURCEREDIS" = [Yy] ]]; then
            # echo "sed -i \"s|\/usr\/local\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|\" "/usr/lib/systemd/system/redis${REDISPORT}.service""
            echo "sed -i \"s|\/usr\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|\" "/usr/lib/systemd/system/redis${REDISPORT}.service""
            echo "sed -i 's|\/usr\/libexec\/redis-shutdown|\/usr\/local\/bin\/redis-shutdown|' "/usr/lib/systemd/system/redis${REDISPORT}.service""
          else
            echo "sed -i \"s|\/usr\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|\" "/usr/lib/systemd/system/redis${REDISPORT}.service""
          fi
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
            echo "\cp -af "$REDISBINARY" "/etc/redis${REDISPORT}/redis-server""
            if [[ "$USE_SOURCEREDIS" = [Yy] ]]; then
              # echo "sed -i \"s|\/usr\/local\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|\" "/usr/lib/systemd/system/redis${REDISPORT}.service""
              echo "sed -i \"s|\/usr\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|\" "/usr/lib/systemd/system/redis${REDISPORT}.service""
              echo "sed -i 's|\/usr\/libexec\/redis-shutdown|\/usr\/local\/bin\/redis-shutdown|' "/usr/lib/systemd/system/redis${REDISPORT}.service""
            else
              echo "sed -i \"s|\/usr\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|\" "/usr/lib/systemd/system/redis${REDISPORT}.service""
            fi
            echo "sed -i 's|^# cluster-enabled yes|cluster-enabled yes|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
            echo "sed -i \"s|^# cluster-config-file nodes-${REDISPORT}.conf|cluster-config-file nodes-${DT}.conf|\" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
            echo "sed -i \"s|^# cluster-node-timeout 15000|cluster-node-timeout 5000|\" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
            echo "sed -i 's|^appendonly no|appendonly yes|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
            echo "enabled cluster mode with cluster-config-file nodes-${DT}.conf"
          fi
          if [[ "$CLUSTER" = 'replication' ]]; then
            # only add slaveof parameter when increment
            # value not equal to 0 as 0 is master
            if [[ "$p" != '0' ]]; then
              echo "echo \"slaveof 127.0.0.1 $STARTPORT\" >> "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
            fi
          fi
          if [[ "$UNIXSOCKET" = [Yy] ]]; then
            echo "sed -i \"s|port $REDISPORT|port 0|\" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
            echo "sed -i \"s|^# unixsocket \/var\/run\/redis\/redis${REDISPORT}.sock|unixsocket \/var\/run\/redis\/redis${REDISPORT}.sock|\" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
            echo "sed -i 's|^# unixsocketperm 700|unixsocketperm 700|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
          fi
          if [[ "$CLUSTER_CREATE" = 'repcache' ]]; then
            echo "sed -i 's|^save 900|#save 900|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
            echo "sed -i 's|^save 300|#save 300|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
            echo "sed -i 's|^save 60|#save 60|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
            echo "sed -i 's|^appendonly .*|appendonly no|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf""
          fi
          echo "systemctl daemon-reload"
          echo "systemctl restart redis${REDISPORT}"
          echo "systemctl enable redis${REDISPORT}"
          echo "Redis TCP $REDISPORT Info:"
          if [[ "$UNIXSOCKET" = [Yy] ]]; then
            echo "redis-cli -s /var/run/redis/redis${REDISPORT}.sock INFO SERVER | egrep 'redis_version|redis_mode|process_id|tcp_port|uptime|executable|config_file'"
          else
            echo "redis-cli -h 127.0.0.1 -p $REDISPORT INFO SERVER | egrep 'redis_version|redis_mode|process_id|tcp_port|uptime|executable|config_file'"
          fi
          if [[ "$CLUSTER" = 'cluster' ]]; then
            if [[ "$UNIXSOCKET" = [Yy] ]]; then
              echo "redis-cli -s /var/run/redis/redis${REDISPORT}.sock INFO CLUSTER"
            else
              echo "redis-cli -h 127.0.0.1 -p $REDISPORT INFO CLUSTER"
            fi
          fi
          if [[ "$CLUSTER" = 'replication' ]]; then
            if [[ "$UNIXSOCKET" = [Yy] ]]; then
              echo "redis-cli -s /var/run/redis/redis${REDISPORT}.sock INFO REPLICATION"
            else
              echo "redis-cli -h 127.0.0.1 -p $REDISPORT INFO REPLICATION"
            fi
          fi
          # sentinel setup for redis replication
          # create as many sentinels as replication nodes
          for (( sp=0; sp <= $NUMBER_SENTINELS; sp++ ))
            do
          if [[ "$SENTINEL_SETUP" = [yY] && "$CLUSTER" = 'replication' && "$REDISPORT" = "$STARTPORT" ]]; then
            SPORT="$STARTPORT"
            SENTPORT=$(($SPORT+10000+$sp))
            echo
            echo "-----------------"
            echo "creating ${SENTDIR}/sentinel-${SENTPORT}.conf ..."
            echo "mkdir -p "/var/lib/redis/sentinel_${SENTPORT}""
            echo "touch "/var/log/redis/sentinel-${SENTPORT}.log""
            echo "chown redis:redis "/var/log/redis/sentinel-${SENTPORT}.log""
            echo "create sentinel config: ${SENTDIR}/sentinel-${SENTPORT}.conf"
            echo
            echo "------------------------------------------"
            echo "port $SENTPORT"
            echo "daemonize yes"
            echo "dir /var/lib/redis/sentinel_${SENTPORT}"
            echo "pidfile /var/run/redis/redis-sentinel-${SENTPORT}.pid"
            echo "sentinel monitor master-${SPORT} 127.0.0.1 ${SPORT} $QUORUM"
            echo "sentinel down-after-milliseconds master-${SPORT} 3000"
            echo "sentinel failover-timeout master-${SPORT} 6000"
            echo "sentinel parallel-syncs master-${SPORT} 1"
            echo "logfile /var/log/redis/sentinel-${SENTPORT}.log"
            echo "------------------------------------------"
            echo
            echo "create startup script: "/etc/init.d/sentinel_${SENTPORT}""
            echo
echo "
#!/bin/bash
# chkconfig: - 55 45
# Start/Stop/restart script for Redis Sentinel

NAME=\$(basename \${0})
EXEC=/etc/redis${SPORT}/redis-server
PIDFILE=/var/run/redis/redis-sentinel-${SENTPORT}.pid
CONF=${SENTDIR}/sentinel-${SENTPORT}.conf

PID=\$(cat \$PIDFILE 2> /dev/null)
case "\$1" in
     start)
         echo \"Starting \$NAME ...\"
         touch \$PIDFILE
         exec \$EXEC \$CONF --sentinel --pidfile \$PIDFILE
         ;;
     stop)
         echo \"Stopping \$NAME PID: \$PID ...\"
         kill \$PID
         ;;
     restart)
         echo \"Restarting \$NAME ...\"
         \$0 stop
         sleep 2
         \$0 start
         ;;
     *)
         echo \"Usage \$0 {start|stop|restart}\"
         ;;
esac
"
            echo
            echo "chmod +x "/etc/init.d/sentinel_$SENTPORT""
            echo "chkconfig "sentinel_$SENTPORT on""
            echo "service "sentinel_$SENTPORT" start"
            echo "sleep 2"
            echo "tail -4 "/var/log/redis/sentinel-${SENTSENTPORT.log""
          fi
          done #sp
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
          \cp -af "$REDISBINARY" "/etc/redis${REDISPORT}/redis-server"
          if [[ "$USE_SOURCEREDIS" = [Yy] ]]; then
            # sed -i "s|\/usr\/local\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|" "/usr/lib/systemd/system/redis${REDISPORT}.service"
            sed -i "s|\/usr\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|" "/usr/lib/systemd/system/redis${REDISPORT}.service"
            sed -i 's|\/usr\/libexec\/redis-shutdown|\/usr\/local\/bin\/redis-shutdown|' "/usr/lib/systemd/system/redis${REDISPORT}.service"
          else
            sed -i "s|\/usr\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|" "/usr/lib/systemd/system/redis${REDISPORT}.service"
          fi
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
            \cp -af "$REDISBINARY" "/etc/redis${REDISPORT}/redis-server"
            if [[ "$USE_SOURCEREDIS" = [Yy] ]]; then
              # sed -i "s|\/usr\/local\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|" "/usr/lib/systemd/system/redis${REDISPORT}.service"
              sed -i "s|\/usr\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|" "/usr/lib/systemd/system/redis${REDISPORT}.service"
              sed -i 's|\/usr\/libexec\/redis-shutdown|\/usr\/local\/bin\/redis-shutdown|' "/usr/lib/systemd/system/redis${REDISPORT}.service"
            else
              sed -i "s|\/usr\/bin\/redis-server|\/etc\/redis${REDISPORT}\/redis-server|" "/usr/lib/systemd/system/redis${REDISPORT}.service"
            fi
            sed -i 's|^# cluster-enabled yes|cluster-enabled yes|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
            sed -i "s|^# cluster-config-file nodes-${REDISPORT}.conf|cluster-config-file nodes-${DT}.conf|" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
            sed -i "s|^# cluster-node-timeout 15000|cluster-node-timeout 5000|" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
            sed -i 's|^appendonly no|appendonly yes|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
            echo "enabled cluster mode with cluster-config-file nodes-${DT}.conf"
          fi
          if [[ "$CLUSTER" = 'replication' ]]; then
            # only add slaveof parameter when increment
            # value not equal to 0 as 0 is master
            if [[ "$p" != '0' ]]; then
              echo "slaveof 127.0.0.1 $STARTPORT" >> "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
            fi
          fi
          if [[ "$UNIXSOCKET" = [Yy] ]]; then
            sed -i "s|port $REDISPORT|port 0|" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
            sed -i "s|^# unixsocket \/var\/run\/redis\/redis${REDISPORT}.sock|unixsocket \/var\/run\/redis\/redis${REDISPORT}.sock|" "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
            sed -i 's|^# unixsocketperm 700|unixsocketperm 700|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
          fi
          if [[ "$CLUSTER_CREATE" = 'repcache' ]]; then
            sed -i 's|^save 900|#save 900|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
            sed -i 's|^save 300|#save 300|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
            sed -i 's|^save 60|#save 60|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
            sed -i 's|^appendonly .*|appendonly no|' "/etc/redis${REDISPORT}/redis${REDISPORT}.conf"
          fi
          systemctl daemon-reload
          systemctl restart redis${REDISPORT}
          systemctl enable redis${REDISPORT}
          echo "## Redis TCP $REDISPORT Info ##"
          if [[ "$UNIXSOCKET" = [Yy] ]]; then
            redis-cli -s /var/run/redis/redis${REDISPORT}.sock INFO SERVER| egrep 'redis_version|redis_mode|process_id|tcp_port|uptime|executable|config_file'
          else
            redis-cli -h 127.0.0.1 -p $REDISPORT INFO SERVER| egrep 'redis_version|redis_mode|process_id|tcp_port|uptime|executable|config_file'
          fi
          if [[ "$CLUSTER" = 'cluster' ]]; then
            if [[ "$UNIXSOCKET" = [Yy] ]]; then
              redis-cli -s /var/run/redis/redis${REDISPORT}.sock INFO CLUSTER
            else
              redis-cli -h 127.0.0.1 -p $REDISPORT INFO CLUSTER
            fi
          fi
          if [[ "$CLUSTER" = 'replication' ]]; then
            sleep 2
            if [[ "$UNIXSOCKET" = [Yy] ]]; then
              redis-cli -s /var/run/redis/redis${REDISPORT}.sock INFO REPLICATION
            else
              redis-cli -h 127.0.0.1 -p $REDISPORT INFO REPLICATION
            fi
          fi
          # sentinel setup for redis replication
          # create as many sentinels as replication nodes
          for (( sp=0; sp <= $NUMBER_SENTINELS; sp++ ))
            do
          if [[ "$SENTINEL_SETUP" = [yY] && "$CLUSTER" = 'replication' && "$REDISPORT" = "$STARTPORT" ]]; then
            SPORT="$STARTPORT"
            SENTPORT=$(($SPORT+10000+$sp))
            echo
            echo "-----------------"
            echo "creating ${SENTDIR}/sentinel-${SENTPORT}.conf ..."
            mkdir -p "/var/lib/redis/sentinel_${SENTPORT}"
            touch "/var/log/redis/sentinel-${SENTPORT}.log"
            chown redis:redis "/var/log/redis/sentinel-${SENTPORT}.log"
cat > "${SENTDIR}/sentinel-${SENTPORT}.conf" <<JJJ
port $SENTPORT
daemonize yes
dir /var/lib/redis/sentinel_${SENTPORT}
pidfile /var/run/redis/redis-sentinel-${SENTPORT}.pid
sentinel monitor master-${SPORT} 127.0.0.1 ${SPORT} $QUORUM
sentinel down-after-milliseconds master-${SPORT} 3000
sentinel failover-timeout master-${SPORT} 6000
sentinel parallel-syncs master-${SPORT} 1
logfile /var/log/redis/sentinel-${SENTPORT}.log
JJJ
          echo

            if [ -f "${SENTDIR}/sentinel-${SENTPORT}.conf" ]; then
              echo "sentinel sentinel-${SENTPORT}.conf contents"
              echo
              cat "${SENTDIR}/sentinel-${SENTPORT}.conf"
            
              echo "starting Redis sentinel (sentinel-${SENTPORT}.conf)"
              # /etc/redis${SPORT}/redis-server "${SENTDIR}/sentinel-${SENTPORT}.conf" --sentinel

cat > "/etc/init.d/sentinel_$SENTPORT" <<TTT
#!/bin/bash
# chkconfig: - 55 45
# Start/Stop/restart script for Redis Sentinel

NAME=\$(basename \${0})
EXEC=/etc/redis${SPORT}/redis-server
PIDFILE=/var/run/redis/redis-sentinel-${SENTPORT}.pid
CONF=${SENTDIR}/sentinel-${SENTPORT}.conf

PID=\$(cat \$PIDFILE 2> /dev/null)
case "\$1" in
     start)
         echo "Starting \$NAME ..."
         touch \$PIDFILE
         exec \$EXEC \$CONF --sentinel --pidfile \$PIDFILE
         ;;
     stop)
         echo "Stopping \$NAME PID: \$PID ..."
         kill \$PID
         ;;
     restart)
         echo "Restarting \$NAME ..."
         \$0 stop
         sleep 2
         \$0 start
         ;;
     *)
         echo "Usage \$0 {start|stop|restart}"
         ;;
esac
TTT
            chmod +x "/etc/init.d/sentinel_$SENTPORT"
            chkconfig "sentinel_$SENTPORT" on
            service "sentinel_$SENTPORT" start
            sleep 2
            tail -4 "/var/log/redis/sentinel-${SENTPORT}.log"

            fi
          fi
          done #sp
        fi
      fi
  done
  if [[ "$CLUSTER" = 'cluster' && "$CLUSTER_CREATE" -eq '6' ]]; then
    echo
    echo "Join created 6 node cluster enabled redis instances to cluster"
    echo "using redis-cluster-tool: 3x 1x master + 1x slaves"
    echo
    echo "redis-cluster-tool -C \"cluster_create 127.0.0.1:6479[127.0.0.1:6480] 127.0.0.1:6481[127.0.0.1:6482] 127.0.0.1:6483[127.0.0.1:6484]\""
    if [[ "$DEBUG_REDISGEN" = [nN] ]]; then
      sleep 2
      redis-cluster-tool -C "cluster_create 127.0.0.1:6479[127.0.0.1:6480] 127.0.0.1:6481[127.0.0.1:6482] 127.0.0.1:6483[127.0.0.1:6484]"
    fi
    echo
    echo "redis-cluster-tool -a 127.0.0.1:6479 -C cluster_state -r master"
    if [[ "$DEBUG_REDISGEN" = [nN] ]]; then
      sleep 3
      redis-cluster-tool -a 127.0.0.1:6479 -C cluster_state -r master
    fi
    echo
    echo "redis-cluster-tool -a 127.0.0.1:6479 -C cluster_state -r slave"
    if [[ "$DEBUG_REDISGEN" = [nN] ]]; then
      sleep 3
      redis-cluster-tool -a 127.0.0.1:6479 -C cluster_state -r slave
    fi
  fi
  if [[ "$CLUSTER" = 'cluster' && "$CLUSTER_CREATE" -eq '9' ]]; then
    echo
    echo "Join created 9 node cluster enabled redis instances to cluster"
    echo "using redis-cluster-tool: 3x 1x master + 2x slaves"
    echo
    echo "redis-cluster-tool -C \"cluster_create 127.0.0.1:6479[127.0.0.1:6480|127.0.0.1:6481] 127.0.0.1:6482[127.0.0.1:6483|127.0.0.1:6484] 127.0.0.1:6485[127.0.0.1:6486|127.0.0.1:6487]\""
    if [[ "$DEBUG_REDISGEN" = [nN] ]]; then
      sleep 2
      redis-cluster-tool -C "cluster_create 127.0.0.1:6479[127.0.0.1:6480|127.0.0.1:6481] 127.0.0.1:6482[127.0.0.1:6483|127.0.0.1:6484] 127.0.0.1:6485[127.0.0.1:6486|127.0.0.1:6487]"
    fi
    echo
    echo "redis-cluster-tool -a 127.0.0.1:6479 -C cluster_state -r master"
    if [[ "$DEBUG_REDISGEN" = [nN] ]]; then
      sleep 3
      redis-cluster-tool -a 127.0.0.1:6479 -C cluster_state -r master
    fi
    echo
    echo "redis-cluster-tool -a 127.0.0.1:6479 -C cluster_state -r slave"
    if [[ "$DEBUG_REDISGEN" = [nN] ]]; then
      sleep 3
      redis-cluster-tool -a 127.0.0.1:6479 -C cluster_state -r slave
    fi
  fi
}

######################################################

case "$1" in
  multi )
    NUM=$2
    genredis $NUM
    ;;
  prep )
    redis_cluster_install
    PREP=y
    ;;
  prepupdate )
    redis_cluster_install update
    PREP=y
    ;;
  replication )
    NUM=$2
    CUSTOM_STARTPORT=$3
    # allow users to create redis replication with custom STARTPORTs
    # i.e. ./redis-generator.sh replication 2 6579
    # would create master + slave 2x redis replication starting on TCP
    # port 6579 if available, or it will provide the next available TCP
    # port in the sequence starting at 6579
    if [[ ! -z "$CUSTOM_STARTPORT" ]]; then
      CHECK_PORT=$(netstat -nt | grep -q $CUSTOM_STARTPORT; echo $?)
      if [[ "$CHECK_PORT" -ne '0' ]]; then
        STARTPORT=$CUSTOM_STARTPORT
      else
        echo
        echo "Error: TCP port $CUSTOM_STARTPORT in use, try another port"
        echo
        exit
      fi
    fi
    if [ "$NUM" -lt '2' ]; then
      echo
      echo "minimum of 2 nodes are required for redis"
      echo "replication configuration"
      echo "i.e. 1x master + 1x slave"
      echo
      echo "$0 replication X"
      exit
    fi
    UNIXSOCKET='n'
    genredis $NUM replication
    ;;
  replication-cache )
    NUM=$2
    CUSTOM_STARTPORT=$3
    # allow users to create redis replication with custom STARTPORTs
    # i.e. ./redis-generator.sh replication 2 6579
    # would create master + slave 2x redis replication starting on TCP
    # port 6579 if available, or it will provide the next available TCP
    # port in the sequence starting at 6579
    if [[ ! -z "$CUSTOM_STARTPORT" ]]; then
      CHECK_PORT=$(netstat -nt | grep -q $CUSTOM_STARTPORT; echo $?)
      if [[ "$CHECK_PORT" -ne '0' ]]; then
        STARTPORT=$CUSTOM_STARTPORT
      else
        echo
        echo "Error: TCP port $CUSTOM_STARTPORT in use, try another port"
        echo
        exit
      fi
    fi
    if [ "$NUM" -lt '2' ]; then
      echo
      echo "minimum of 2 nodes are required for redis"
      echo "replication configuration"
      echo "i.e. 1x master + 1x slave"
      echo
      echo "$0 replication X"
      exit
    fi
    UNIXSOCKET='n'
    genredis $NUM replication repcache
    ;;
  clusterprep )
    NUM=$2
    if [ "$NUM" -lt '6' ]; then
      echo
      echo "minimum of 3 master nodes are required for redis"
      echo "cluster configuration so minimum 6 redis servers"
      echo "i.e. 3x master/slave redis nodes"
      echo
      echo "$0 clusterprep 6"
      exit
    fi
    CLUSTER=cluster
    genredis $NUM cluster
    ;;
  clustermake )
    NUM=$2
    if [ "$NUM" -lt '6' ]; then
      echo
      echo "minimum of 3 master nodes are required for redis"
      echo "cluster configuration so minimum 6 redis servers"
      echo "i.e. 3x master/slave redis nodes"
      echo
      echo "$0 clustermake 6"
      echo "or"
      echo "$0 clustermake 9"
      exit
    fi
    if [ "$NUM" -eq '6' ]; then
      CLUSTER_CREATE=6
      CLUSTER=cluster
      genredis 6 cluster 6
    fi
    if [ "$NUM" -eq '9' ]; then
      CLUSTER_CREATE=9
      CLUSTER=cluster
      genredis 9 cluster 9
    fi
    ;;
  delete )
    NUM=$2
    CUSTOM_STARTPORT=$3
    if [[ ! -z "$CUSTOM_STARTPORT" ]]; then
      STARTPORT=$CUSTOM_STARTPORT
    fi
    genredis_del $NUM
    ;;
  * )
    echo
    echo "* Usage: where X equal postive integer for number of redis"
    echo "  servers to create with incrementing TCP redis ports"
    echo "  starting at STARTPORT=6479."

    echo "* prep - standalone prep command installs redis-cluster-tool"
    echo "* prepupdate - standalone prep update command updates redis-cluster-tool"
    echo "* multi X - no. of standalone redis instances to create"
    echo "* clusterprep X - no. of cluster enabled config instances"
    echo "* clustermake 6 - to enable cluster mode + create cluster"
    echo "* clustermake 9 - flag to enable cluster mode + create cluster"
    echo "* replication X - create redis replication"
    echo "* replication X 6579 - create replication with custom start port 6579"
    echo "* replication-cache X - create redis replication + disable ondisk persistence"
    echo "* replication-cache X 6579 - create replication with custom start port 6579"
    echo "* delete X - no. of redis instances to delete"
    echo "* delete X 6579 - no. of redis instances to delete + custom start port 6579"
    echo
    echo "$0 prep"
    echo "$0 prepupdate"
    echo "$0 multi X"
    echo "$0 clusterprep X"
    echo "$0 clustermake 6"
    echo "$0 clustermake 9"
    echo "$0 replication X"
    echo "$0 replication X 6579"
    echo "$0 replication-cache X"
    echo "$0 replication-cache X 6579"
    echo "$0 delete X"
    echo "$0 delete X 6579"
    ;;
esac
exit
