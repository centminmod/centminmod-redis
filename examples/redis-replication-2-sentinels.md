Example
=========

Example of using [redis-generator.sh](https://github.com/centminmod/centminmod-redis) to create 2 redis server master + slave replication on ports 6479 and 6480 + enable auto [redis sentinel](https://redis.io/topics/sentinel) setup which is tied to the redis master instance on `STARTPORT` by enabling `SENTINEL_SETUP='y'` prior to running replication command.

Usage:
=======

Default is to create the redis servers via TCP ports.

    ./redis-generator.sh
    
    * Usage: where X equal postive integer for number of redis
    servers to create with incrementing TCP redis ports
    starting at STARTPORT=6479.
    * prep - standalone prep command installs redis-cluster-tool
    * prepupdate - standalone prep update command updates redis-cluster-tool
    * multi X - no. of standalone redis instances to create
    * clusterprep X - no. of cluster enabled config instances
    * clustermake 6 - to enable cluster mode + create cluster
    * clustermake 9 - flag to enable cluster mode + create cluster
    * replication X - create redis replication
    * replication X 6579 - create replication with custom start port 6579
    * delete X - no. of redis instances to delete
    * delete X 6579 - no. of redis instances to delete + custom start port 6579
    
    ./redis-generator.sh prep
    ./redis-generator.sh prepupdate
    ./redis-generator.sh multi X
    ./redis-generator.sh clusterprep X
    ./redis-generator.sh clustermake 6
    ./redis-generator.sh clustermake 9
    ./redis-generator.sh replication X
    ./redis-generator.sh replication X 6579
    ./redis-generator.sh delete X
    ./redis-generator.sh delete X 6579

Example would create

* sentinel config file `/root/tools/redis-sentinel/sentinel-6479.conf` where `STARTPORT` is 6479
* sentinel port is `STARTPORT` + 10000 = 6479 + 10000 = `16479`
* sentinel init.d startup script is at `/etc/init.d/sentinel_16479` 
* sentinel directory /var/lib/redis/sentinel_6479
* sentinel log /var/log/redis/sentinel-6479.log
* sentinel pid file /var/run/redis/redis-sentinel-6479.pid
* quorum is set to 1 as each replication run only creates one master redis instanced paired to redis slaves.

Output

    ./redis-generator.sh replication 2
    
    Creating redis servers starting at TCP = 6479...
    -------------------------------------------------------
    creating redis server: redis6479.service [increment value: 0]
    redis TCP port: 6479
    create systemd redis6479.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6479.service
    create /etc/redis6479/redis6479.conf config file
    mkdir -p /etc/redis6479
    cp -a /etc/redis.conf /etc/redis6479/redis6479.conf
    -rw-r----- 1 redis root 46K Feb 13 08:07 /etc/redis6479/redis6479.conf
    -rw-r--r-- 1 root  root 249 Sep 14  2016 /usr/lib/systemd/system/redis6479.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6479.service to /usr/lib/systemd/system/redis6479.service.
    ## Redis TCP 6479 Info ##
    redis_version:3.2.8
    redis_mode:standalone
    process_id:28968
    tcp_port:6479
    uptime_in_seconds:0
    uptime_in_days:0
    executable:/etc/redis6479/redis-server
    config_file:/etc/redis6479/redis6479.conf
    # Replication
    role:master
    connected_slaves:0
    master_repl_offset:0
    repl_backlog_active:0
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:0
    repl_backlog_histlen:0
    
    -----------------
    creating /root/tools/redis-sentinel/sentinel-6479.conf ...
    
    sentinel sentinel-6479.conf contents
    
    port 16479
    daemonize yes
    dir /var/lib/redis/sentinel_6479
    pidfile /var/run/redis/redis-sentinel-6479.pid
    sentinel monitor master-6479 127.0.0.1 6479 1
    sentinel down-after-milliseconds master-6479 3000
    sentinel failover-timeout master-6479 6000
    sentinel parallel-syncs master-6479 1
    logfile /var/log/redis/sentinel-6479.log
    starting Redis sentinel (sentinel-6479.conf)
    Starting sentinel_16479 ...
                `-.__.-'                                               
    
    29035:X 17 Mar 23:03:24.758 # Sentinel ID is 6a0509340d3d75262f1ff123f3734bf37f4ec3ff
    29035:X 17 Mar 23:03:24.758 # +monitor master master-6479 127.0.0.1 6479 quorum 1
    -------------------------------------------------------
    creating redis server: redis6480.service [increment value: 1]
    redis TCP port: 6480
    create systemd redis6480.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6480.service
    create /etc/redis6480/redis6480.conf config file
    mkdir -p /etc/redis6480
    cp -a /etc/redis.conf /etc/redis6480/redis6480.conf
    -rw-r----- 1 redis root 46K Feb 13 08:07 /etc/redis6480/redis6480.conf
    -rw-r--r-- 1 root  root 249 Sep 14  2016 /usr/lib/systemd/system/redis6480.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6480.service to /usr/lib/systemd/system/redis6480.service.
    ## Redis TCP 6480 Info ##
    redis_version:3.2.8
    redis_mode:standalone
    process_id:29085
    tcp_port:6480
    uptime_in_seconds:1
    uptime_in_days:0
    executable:/etc/redis6480/redis-server
    config_file:/etc/redis6480/redis6480.conf
    # Replication
    role:slave
    master_host:127.0.0.1
    master_port:6479
    master_link_status:up
    master_last_io_seconds_ago:1
    master_sync_in_progress:0
    slave_repl_offset:160
    slave_priority:100
    slave_read_only:1
    connected_slaves:0
    master_repl_offset:0
    repl_backlog_active:0
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:0
    repl_backlog_histlen:0

Sentinel log

    tail -30 /var/log/redis/sentinel-6479.log
                    _._                                                  
            _.-``__ ''-._                                             
        _.-``    `.  `_.  ''-._           Redis 3.2.8 (00000000/0) 64 bit
    .-`` .-```.  ```\/    _.,_ ''-._                                   
    (    '      ,       .-`  | `,    )     Running in sentinel mode
    |`-._`-...-` __...-.``-._|'` _.-'|     Port: 16479
    |    `-._   `._    /     _.-'    |     PID: 29035
    `-._    `-._  `-./  _.-'    _.-'                                   
    |`-._`-._    `-.__.-'    _.-'_.-'|                                  
    |    `-._`-._        _.-'_.-'    |           http://redis.io        
    `-._    `-._`-.__.-'_.-'    _.-'                                   
    |`-._`-._    `-.__.-'    _.-'_.-'|                                  
    |    `-._`-._        _.-'_.-'    |                                  
    `-._    `-._`-.__.-'_.-'    _.-'                                   
        `-._    `-.__.-'    _.-'                                       
            `-._        _.-'                                           
                `-.__.-'                                               
    
    29035:X 17 Mar 23:03:24.758 # Sentinel ID is 6a0509340d3d75262f1ff123f3734bf37f4ec3ff
    29035:X 17 Mar 23:03:24.758 # +monitor master master-6479 127.0.0.1 6479 quorum 1
    29035:X 17 Mar 23:03:34.816 * +slave slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479

Querying sentinel listening on port `16479`

    redis-cli -h 127.0.0.1 -p 16479 sentinel master master-6479
    1) "name"
    2) "master-6479"
    3) "ip"
    4) "127.0.0.1"
    5) "port"
    6) "6479"
    7) "runid"
    8) "3df44c68f8b9c8bf20fa51684589638046d343e6"
    9) "flags"
    10) "master"
    11) "link-pending-commands"
    12) "0"
    13) "link-refcount"
    14) "1"
    15) "last-ping-sent"
    16) "0"
    17) "last-ok-ping-reply"
    18) "14"
    19) "last-ping-reply"
    20) "14"
    21) "down-after-milliseconds"
    22) "3000"
    23) "info-refresh"
    24) "9324"
    25) "role-reported"
    26) "master"
    27) "role-reported-time"
    28) "662803"
    29) "config-epoch"
    30) "1"
    31) "num-slaves"
    32) "1"
    33) "num-other-sentinels"
    34) "0"
    35) "quorum"
    36) "1"
    37) "failover-timeout"
    38) "6000"
    39) "parallel-syncs"
    40) "1"

Processes

    ps aufxw | grep redis | grep -v grep
    redis    29610  0.2  0.1 142896  2608 ?        Ssl  23:42   0:00 /etc/redis6479/redis-server 127.0.0.1:6479
    root     29677  0.3  0.1  39308  2084 ?        Ssl  23:42   0:00 /etc/redis6479/redis-server *:16479 [sentinel]
    redis    29727  0.2  0.1 142896  2552 ?        Ssl  23:42   0:00 /etc/redis6480/redis-server 127.0.0.1:6480

Simulate Redis master on port 6479 failure

    kill -9 $(cat /var/run/redis/redis_6479.pid)

Check replication info for failed redis master

    redis-cli -h 127.0.0.1 -p 6479 INFO REPLICATION
    Could not connect to Redis at 127.0.0.1:6479: Connection refused

Check replication info for promoted redis slave 6480 to master

    redis-cli -h 127.0.0.1 -p 6480 INFO REPLICATION  
    # Replication
    role:master
    connected_slaves:0
    master_repl_offset:0
    repl_backlog_active:0
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:0
    repl_backlog_histlen:0

Checking sentinel log

    tail -50 /var/log/redis/sentinel-6479.log 
                    _._                                                  
            _.-``__ ''-._                                             
        _.-``    `.  `_.  ''-._           Redis 3.2.8 (00000000/0) 64 bit
    .-`` .-```.  ```\/    _.,_ ''-._                                   
    (    '      ,       .-`  | `,    )     Running in sentinel mode
    |`-._`-...-` __...-.``-._|'` _.-'|     Port: 16479
    |    `-._   `._    /     _.-'    |     PID: 29677
    `-._    `-._  `-./  _.-'    _.-'                                   
    |`-._`-._    `-.__.-'    _.-'_.-'|                                  
    |    `-._`-._        _.-'_.-'    |           http://redis.io        
    `-._    `-._`-.__.-'_.-'    _.-'                                   
    |`-._`-._    `-.__.-'    _.-'_.-'|                                  
    |    `-._`-._        _.-'_.-'    |                                  
    `-._    `-._`-.__.-'_.-'    _.-'                                   
        `-._    `-.__.-'    _.-'                                       
            `-._        _.-'                                           
                `-.__.-'                                               
    
    29677:X 17 Mar 23:42:24.224 # Sentinel ID is e4a06cca515c15bc1fa002c2ce4959105000163a
    29677:X 17 Mar 23:42:24.224 # +monitor master master-6479 127.0.0.1 6479 quorum 1
    29677:X 17 Mar 23:42:34.265 * +slave slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479
    29677:X 17 Mar 23:45:53.734 # +sdown master master-6479 127.0.0.1 6479
    29677:X 17 Mar 23:45:53.734 # +odown master master-6479 127.0.0.1 6479 #quorum 1/1
    29677:X 17 Mar 23:45:53.734 # +new-epoch 1
    29677:X 17 Mar 23:45:53.734 # +try-failover master master-6479 127.0.0.1 6479
    29677:X 17 Mar 23:45:53.737 # +vote-for-leader e4a06cca515c15bc1fa002c2ce4959105000163a 1
    29677:X 17 Mar 23:45:53.737 # +elected-leader master master-6479 127.0.0.1 6479
    29677:X 17 Mar 23:45:53.737 # +failover-state-select-slave master master-6479 127.0.0.1 6479
    29677:X 17 Mar 23:45:53.796 # +selected-slave slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479
    29677:X 17 Mar 23:45:53.796 * +failover-state-send-slaveof-noone slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479
    29677:X 17 Mar 23:45:53.872 * +failover-state-wait-promotion slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479
    29677:X 17 Mar 23:45:54.805 # +promoted-slave slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479
    29677:X 17 Mar 23:45:54.805 # +failover-state-reconf-slaves master master-6479 127.0.0.1 6479
    29677:X 17 Mar 23:45:54.858 # +failover-end master master-6479 127.0.0.1 6479
    29677:X 17 Mar 23:45:54.858 # +switch-master master-6479 127.0.0.1 6479 127.0.0.1 6480
    29677:X 17 Mar 23:45:54.858 * +slave slave 127.0.0.1:6479 127.0.0.1 6479 @ master-6479 127.0.0.1 6480
    29677:X 17 Mar 23:45:57.868 # +sdown slave 127.0.0.1:6479 127.0.0.1 6479 @ master-6479 127.0.0.1 6480

Restart Redis 6479 port instance will currently be set to redis slave

    systemctl start redis6479

redis 6479 replication info

    redis-cli -h 127.0.0.1 -p 6479 INFO REPLICATION
    # Replication
    role:slave
    master_host:127.0.0.1
    master_port:6480
    master_link_status:up
    master_last_io_seconds_ago:1
    master_sync_in_progress:0
    slave_repl_offset:296
    slave_priority:100
    slave_read_only:1
    connected_slaves:0
    master_repl_offset:0
    repl_backlog_active:0
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:0
    repl_backlog_histlen:0

Two additional entries in sentinel log at `/var/log/redis/sentinel-6479.log `

    tail -2 /var/log/redis/sentinel-6479.log 
    29677:X 17 Mar 23:51:21.109 # -sdown slave 127.0.0.1:6479 127.0.0.1 6479 @ master-6479 127.0.0.1 6480
    29677:X 17 Mar 23:51:31.132 * +convert-to-slave slave 127.0.0.1:6479 127.0.0.1 6479 @ master-6479 127.0.0.1 6480

When you run delete command it will wipe the redis instances including sentinel setups

    ./redis-generator.sh delete 2