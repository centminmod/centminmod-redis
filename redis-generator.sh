#!/bin/bash
######################################################
# https://github.com/centminmod/centminmod-redis
# for centos 7 only
# written by George Liu (eva2000) centminmod.com
######################################################
# variables
#############
VER=0.9
DT=`date +"%d%m%y-%H%M%S"`

STARTPORT=6479
DEBUG_REDISGEN='y'
UNIXSOCKET='n'
SENTINEL_SETUP='n'
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
    if [ -f "${SENTDIR}/sentinel-${REDISPORT}.conf" ]; then
      rm -rf "${SENTDIR}/sentinel-${REDISPORT}.conf"
    fi
    if [ -d "/var/lib/redis/sentinel_${REDISPORT}" ]; then
      rm -rf "/var/lib/redis/sentinel_${REDISPORT}"
    fi
    rm -rf "/var/lib/redis${REDISPORT}"
  done
  echo "Deletion completed"
  exit
}

genredis() {
  CLUSTER=$2
  CLUSTER_CREATE=$3
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
          if [[ "$SENTINEL_SETUP" && "$CLUSTER" = 'replication' && "$REDISPORT" = "$STARTPORT" ]]; then
            SPORT="$STARTPORT"
            SENTPORT=$((SPORT+10000))
            echo
            echo "-----------------"
            echo "creating ${SENTDIR}/sentinel-${SPORT}.conf ..."
            echo "mkdir -p "/var/lib/redis/sentinel_${SPORT}""
            echo "create sentinel config: ${SENTDIR}/sentinel-${SPORT}.conf"
            echo
            echo "------------------------------------------"
            echo "port $SENTPORT"
            echo "daemonize yes"
            echo "dir /var/lib/redis/sentinel_${SPORT}"
            echo "pidfile /var/run/redis/redis-sentinel-${SPORT}.pid"
            echo "sentinel monitor master-${SPORT} 127.0.0.1 ${SPORT} 1"
            echo "sentinel down-after-milliseconds master-${SPORT} 3000"
            echo "sentinel failover-timeout master-${SPORT} 6000"
            echo "sentinel parallel-syncs master-${SPORT} 1"
            echo "logfile /var/log/redis/sentinel-${SPORT}.log"
            echo "------------------------------------------"
            echo
            echo "create startup scrip: "/etc/init.d/sentinel_$SENTPORT""
            echo
echo "
#!/bin/bash
# chkconfig: - 55 45
# Start/Stop/restart script for Redis Sentinel

NAME=\$(basename \${0})
EXEC=/etc/redis${SPORT}/redis-server
PIDFILE=/var/run/redis/redis-sentinel-${SPORT}.pid
CONF=${SENTDIR}/sentinel-${SPORT}.conf

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
            echo "systemctl enable "sentinel_$SENTPORT""
            echo "systemctl start "sentinel_$SENTPORT""
            echo "tail -3 "/var/log/redis/sentinel-${SPORT}.log""
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
          if [[ "$SENTINEL_SETUP" && "$CLUSTER" = 'replication' && "$REDISPORT" = "$STARTPORT" ]]; then
            SPORT="$STARTPORT"
            SENTPORT=$((SPORT+10000))
            echo
            echo "-----------------"
            echo "creating ${SENTDIR}/sentinel-${SPORT}.conf ..."
            mkdir -p "/var/lib/redis/sentinel_${SPORT}"
cat > "${SENTDIR}/sentinel-${SPORT}.conf" <<JJJ
port $SENTPORT
daemonize yes
dir /var/lib/redis/sentinel_${SPORT}
pidfile /var/run/redis/redis-sentinel-${SPORT}.pid
sentinel monitor master-${SPORT} 127.0.0.1 ${SPORT} 1
sentinel down-after-milliseconds master-${SPORT} 3000
sentinel failover-timeout master-${SPORT} 6000
sentinel parallel-syncs master-${SPORT} 1
logfile /var/log/redis/sentinel-${SPORT}.log
JJJ

            if [ -f "${SENTDIR}/sentinel-${SPORT}.conf" ]; then
              echo "sentinel sentinel-${SPORT}.conf contents"
              echo
              cat "${SENTDIR}/sentinel-${SPORT}.conf"
            
              echo "starting Redis sentinel (sentinel-${SPORT}.conf)"
              # /etc/redis${SPORT}/redis-server "${SENTDIR}/sentinel-${SPORT}.conf" --sentinel

cat > "/etc/init.d/sentinel_$SENTPORT" <<TTT
#!/bin/bash
# chkconfig: - 55 45
# Start/Stop/restart script for Redis Sentinel

NAME=\$(basename \${0})
EXEC=/etc/redis${SPORT}/redis-server
PIDFILE=/var/run/redis/redis-sentinel-${SPORT}.pid
CONF=${SENTDIR}/sentinel-${SPORT}.conf

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
            systemctl enable "sentinel_$SENTPORT"
            systemctl start "sentinel_$SENTPORT"
            tail -3 "/var/log/redis/sentinel-${SPORT}.log"

            fi
          fi
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
    genredis_del $NUM
    ;;
  * )
    echo
    echo "* Usage: where X equal postive integer for number of redis"
    echo "  servers to create with incrementing TCP redis ports"
    echo "  starting at STARTPORT=6479."

    echo "* prep - standalone prep command installs redis-cluster-tool"
    echo "* prepupdate - standalone prep update command updates redis-cluster-tool"
    echo "* multi X - number of standalone redis instances to create"
    echo "* clusterprep X - number of cluster enabled config instances"
    echo "* clustermake 6 - to enable cluster mode + create cluster"
    echo "* clustermake 9 - flag to enable cluster mode + create cluster"
    echo "* replication X - create redis replication"
    echo "* replication X 6579 - create replication with custom start port 6579"
    echo "* delete X - number of redis instances to delete"
    echo
    echo "$0 prep"
    echo "$0 prepupdate"
    echo "$0 multi X"
    echo "$0 clusterprep X"
    echo "$0 clustermake 6"
    echo "$0 clustermake 9"
    echo "$0 replication X"
    echo "$0 replication X 6579"
    echo "$0 delete X"
    ;;
esac
exit
