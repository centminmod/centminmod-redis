Example
=========

Example of using [redis-generator.sh](https://github.com/centminmod/centminmod-redis) to create 2 redis server master + slave replication on ports 6479 and 6480 + enable auto [redis sentinel](https://redis.io/topics/sentinel) setup (3x sentinel with quorum of 2) which is tied to the redis master instance on `STARTPORT` by enabling `SENTINEL_SETUP='y'` prior to running replication command.

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
    * replication-cache X - create redis replication + disable ondisk persistence
    * replication-cache X 6579 - create replication with custom start port 6579
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
    ./redis-generator.sh replication-cache X
    ./redis-generator.sh replication-cache X 6579
    ./redis-generator.sh delete X
    ./redis-generator.sh delete X 6579

Example would create

* redis systemd files at `/usr/lib/systemd/system/redis6479.service` and `/usr/lib/systemd/system/redis6480.service`
* redis-server binaries at `/etc/redis6479/redis-server` and `/etc/redis6480/redis-server` symlinked from `/usr/bin/redis-server`
* redis pid files at `/var/run/redis/redis_6479.pid` and `/var/run/redis/redis_6480.pid`
* dedicated redis config files at `/etc/redis6479/redis6479.conf` and `/etc/redis6479/redis6480.conf` 
* each config file will have `dbfilename` as `dump6479.rdb` and `dump6480.rdb` with commented out unix sockets at `/var/run/redis/redis6479.sock` and `/var/run/redis/redis6480.sock`
* dedicated redis data directories at `/var/lib/redis6479` and `/var/lib/redis6480`
* dedicated redis log files at `/var/log/redis/redis6479.log` and `/var/log/redis/redis6480.log`
* sentinel config file `/root/tools/redis-sentinel/sentinel-16479.conf` where `STARTPORT` is 6479 and incremented by 2 for `/root/tools/redis-sentinel/sentinel-16480.conf` and `/root/tools/redis-sentinel/sentinel-16481.conf`
* sentinel port is `STARTPORT` + 10000 = 6479 + 10000 = `16479` and incremented by 2 for `16480` and `16481`
* sentinel init.d startup script is at `/etc/init.d/sentinel_16479` and incremented by 2 for `/etc/init.d/sentinel_16480` and `/etc/init.d/sentinel_16481`
* sentinel directory `/var/lib/redis/sentinel_16479`, `/var/lib/redis/sentinel_16480` and `/var/lib/redis/sentinel_16481`
* sentinel log `/var/log/redis/sentinel-16479.log`, `/var/log/redis/sentinel-16480.log` and `/var/log/redis/sentinel-16481.log`
* sentinel pid file `/var/run/redis/redis-sentinel-16479.pid`, `/var/run/redis/redis-sentinel-16480.pid` and `/var/run/redis/redis-sentinel-16481.pid`
* quorum is set to 2 with 3x redis sentinels

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
    process_id:5259
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
    creating /root/tools/redis-sentinel/sentinel-16479.conf ...
    
    sentinel sentinel-16479.conf contents
    
    port 16479
    daemonize yes
    dir /var/lib/redis/sentinel_16479
    pidfile /var/run/redis/redis-sentinel-16479.pid
    sentinel monitor master-6479 127.0.0.1 6479 2
    sentinel down-after-milliseconds master-6479 3000
    sentinel failover-timeout master-6479 6000
    sentinel parallel-syncs master-6479 1
    logfile /var/log/redis/sentinel-16479.log
    starting Redis sentinel (sentinel-16479.conf)
    Starting sentinel_16479 ...
    
    -----------------
    creating /root/tools/redis-sentinel/sentinel-16480.conf ...
    
    sentinel sentinel-16480.conf contents
    
    port 16480
    daemonize yes
    dir /var/lib/redis/sentinel_16480
    pidfile /var/run/redis/redis-sentinel-16480.pid
    sentinel monitor master-6479 127.0.0.1 6479 2
    sentinel down-after-milliseconds master-6479 3000
    sentinel failover-timeout master-6479 6000
    sentinel parallel-syncs master-6479 1
    logfile /var/log/redis/sentinel-16480.log
    starting Redis sentinel (sentinel-16480.conf)
    Starting sentinel_16480 ...
    
    -----------------
    creating /root/tools/redis-sentinel/sentinel-16481.conf ...
    
    sentinel sentinel-16481.conf contents
    
    port 16481
    daemonize yes
    dir /var/lib/redis/sentinel_16481
    pidfile /var/run/redis/redis-sentinel-16481.pid
    sentinel monitor master-6479 127.0.0.1 6479 2
    sentinel down-after-milliseconds master-6479 3000
    sentinel failover-timeout master-6479 6000
    sentinel parallel-syncs master-6479 1
    logfile /var/log/redis/sentinel-16481.log
    starting Redis sentinel (sentinel-16481.conf)
    Starting sentinel_16481 ...
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
    process_id:5470
    tcp_port:6480
    uptime_in_seconds:0
    uptime_in_days:0
    executable:/etc/redis6480/redis-server
    config_file:/etc/redis6480/redis6480.conf
    # Replication
    role:slave
    master_host:127.0.0.1
    master_port:6479
    master_link_status:up
    master_last_io_seconds_ago:0
    master_sync_in_progress:0
    slave_repl_offset:446
    slave_priority:100
    slave_read_only:1
    connected_slaves:0
    master_repl_offset:0
    repl_backlog_active:0
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:0
    repl_backlog_histlen:0

Sentinel #1 listening on port 16479 log

    tail -30 /var/log/redis/sentinel-16479.log
                    _._                                                  
            _.-``__ ''-._                                             
        _.-``    `.  `_.  ''-._           Redis 3.2.8 (00000000/0) 64 bit
    .-`` .-```.  ```\/    _.,_ ''-._                                   
    (    '      ,       .-`  | `,    )     Running in sentinel mode
    |`-._`-...-` __...-.``-._|'` _.-'|     Port: 16479
    |    `-._   `._    /     _.-'    |     PID: 5326
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
    
    5326:X 18 Mar 23:14:05.963 # Sentinel ID is a0e19053fde3cd81c5ad1e657bc9b0d91a785117
    5326:X 18 Mar 23:14:05.963 # +monitor master master-6479 127.0.0.1 6479 quorum 2
    5326:X 18 Mar 23:14:10.212 * +sentinel sentinel 1dcfc361efe53842f96fa6febbd4a1e14f2083d5 127.0.0.1 16480 @ master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:14:12.221 * +sentinel sentinel f7b12d2547b457ac6971fb19f818fcda70739506 127.0.0.1 16481 @ master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:14:15.969 * +slave slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479

Sentinel #2 listening on port 16480 log

    tail -30 /var/log/redis/sentinel-16480.log
                    _._                                                  
            _.-``__ ''-._                                             
        _.-``    `.  `_.  ''-._           Redis 3.2.8 (00000000/0) 64 bit
    .-`` .-```.  ```\/    _.,_ ''-._                                   
    (    '      ,       .-`  | `,    )     Running in sentinel mode
    |`-._`-...-` __...-.``-._|'` _.-'|     Port: 16480
    |    `-._   `._    /     _.-'    |     PID: 5373
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
    
    5373:X 18 Mar 23:14:08.072 # Sentinel ID is 1dcfc361efe53842f96fa6febbd4a1e14f2083d5
    5373:X 18 Mar 23:14:08.072 # +monitor master master-6479 127.0.0.1 6479 quorum 2
    5373:X 18 Mar 23:14:09.966 * +sentinel sentinel a0e19053fde3cd81c5ad1e657bc9b0d91a785117 127.0.0.1 16479 @ master-6479 127.0.0.1 6479
    5373:X 18 Mar 23:14:12.221 * +sentinel sentinel f7b12d2547b457ac6971fb19f818fcda70739506 127.0.0.1 16481 @ master-6479 127.0.0.1 6479
    5373:X 18 Mar 23:14:18.142 * +slave slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479

Sentinel #3 listening on port 16481 log

    tail -30 /var/log/redis/sentinel-16481.log
                    _._                                                  
            _.-``__ ''-._                                             
        _.-``    `.  `_.  ''-._           Redis 3.2.8 (00000000/0) 64 bit
    .-`` .-```.  ```\/    _.,_ ''-._                                   
    (    '      ,       .-`  | `,    )     Running in sentinel mode
    |`-._`-...-` __...-.``-._|'` _.-'|     Port: 16481
    |    `-._   `._    /     _.-'    |     PID: 5420
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
    
    5420:X 18 Mar 23:14:10.190 # Sentinel ID is f7b12d2547b457ac6971fb19f818fcda70739506
    5420:X 18 Mar 23:14:10.190 # +monitor master master-6479 127.0.0.1 6479 quorum 2
    5420:X 18 Mar 23:14:10.212 * +sentinel sentinel 1dcfc361efe53842f96fa6febbd4a1e14f2083d5 127.0.0.1 16480 @ master-6479 127.0.0.1 6479
    5420:X 18 Mar 23:14:12.000 * +sentinel sentinel a0e19053fde3cd81c5ad1e657bc9b0d91a785117 127.0.0.1 16479 @ master-6479 127.0.0.1 6479
    5420:X 18 Mar 23:14:20.209 * +slave slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479


Querying sentinel #1 listening on port `16479`

    redis-cli -h 127.0.0.1 -p 16479 sentinel master master-6479
    1) "name"
    2) "master-6479"
    3) "ip"
    4) "127.0.0.1"
    5) "port"
    6) "6479"
    7) "runid"
    8) "690fec7d163884df17d3aa7fd145a621c51eba13"
    9) "flags"
    10) "master"
    11) "link-pending-commands"
    12) "0"
    13) "link-refcount"
    14) "1"
    15) "last-ping-sent"
    16) "0"
    17) "last-ok-ping-reply"
    18) "201"
    19) "last-ping-reply"
    20) "201"
    21) "down-after-milliseconds"
    22) "3000"
    23) "info-refresh"
    24) "9103"
    25) "role-reported"
    26) "master"
    27) "role-reported-time"
    28) "531211"
    29) "config-epoch"
    30) "0"
    31) "num-slaves"
    32) "1"
    33) "num-other-sentinels"
    34) "2"
    35) "quorum"
    36) "2"
    37) "failover-timeout"
    38) "6000"
    39) "parallel-syncs"
    40) "1"

Querying sentinel #1 listening on port `16480`

    redis-cli -h 127.0.0.1 -p 16480 sentinel master master-6479  
    1) "name"
    2) "master-6479"
    3) "ip"
    4) "127.0.0.1"
    5) "port"
    6) "6479"
    7) "runid"
    8) "690fec7d163884df17d3aa7fd145a621c51eba13"
    9) "flags"
    10) "master"
    11) "link-pending-commands"
    12) "0"
    13) "link-refcount"
    14) "1"
    15) "last-ping-sent"
    16) "0"
    17) "last-ok-ping-reply"
    18) "60"
    19) "last-ping-reply"
    20) "60"
    21) "down-after-milliseconds"
    22) "3000"
    23) "info-refresh"
    24) "7092"
    25) "role-reported"
    26) "master"
    27) "role-reported-time"
    28) "539092"
    29) "config-epoch"
    30) "0"
    31) "num-slaves"
    32) "1"
    33) "num-other-sentinels"
    34) "2"
    35) "quorum"
    36) "2"
    37) "failover-timeout"
    38) "6000"
    39) "parallel-syncs"
    40) "1"

Querying sentinel #1 listening on port `16481`

    redis-cli -h 127.0.0.1 -p 16481 sentinel master master-6479 
    1) "name"
    2) "master-6479"
    3) "ip"
    4) "127.0.0.1"
    5) "port"
    6) "6479"
    7) "runid"
    8) "690fec7d163884df17d3aa7fd145a621c51eba13"
    9) "flags"
    10) "master"
    11) "link-pending-commands"
    12) "0"
    13) "link-refcount"
    14) "1"
    15) "last-ping-sent"
    16) "0"
    17) "last-ok-ping-reply"
    18) "384"
    19) "last-ping-reply"
    20) "384"
    21) "down-after-milliseconds"
    22) "3000"
    23) "info-refresh"
    24) "8378"
    25) "role-reported"
    26) "master"
    27) "role-reported-time"
    28) "540287"
    29) "config-epoch"
    30) "0"
    31) "num-slaves"
    32) "1"
    33) "num-other-sentinels"
    34) "2"
    35) "quorum"
    36) "2"
    37) "failover-timeout"
    38) "6000"
    39) "parallel-syncs"
    40) "1"

Processes

    ps aufxw | grep redis | grep -v grep
    redis     5259  0.3  0.1 142896  2772 ?        Ssl  23:14   0:02 /etc/redis6479/redis-server 127.0.0.1:6479
    root      5326  0.4  0.1  39308  2128 ?        Ssl  23:14   0:03 /etc/redis6479/redis-server *:16479 [sentinel]
    root      5373  0.4  0.1  39308  2136 ?        Ssl  23:14   0:03 /etc/redis6479/redis-server *:16480 [sentinel]
    root      5420  0.4  0.1  39308  2140 ?        Ssl  23:14   0:02 /etc/redis6479/redis-server *:16481 [sentinel]
    redis     5470  0.3  0.1 142896  2604 ?        Ssl  23:14   0:02 /etc/redis6480/redis-server 127.0.0.1:6480

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

Checking sentinel #1 log on port 16479

    tail -50 /var/log/redis/sentinel-16479.log
                    _._                                                  
            _.-``__ ''-._                                             
        _.-``    `.  `_.  ''-._           Redis 3.2.8 (00000000/0) 64 bit
    .-`` .-```.  ```\/    _.,_ ''-._                                   
    (    '      ,       .-`  | `,    )     Running in sentinel mode
    |`-._`-...-` __...-.``-._|'` _.-'|     Port: 16479
    |    `-._   `._    /     _.-'    |     PID: 5326
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
    
    5326:X 18 Mar 23:14:05.963 # Sentinel ID is a0e19053fde3cd81c5ad1e657bc9b0d91a785117
    5326:X 18 Mar 23:14:05.963 # +monitor master master-6479 127.0.0.1 6479 quorum 2
    5326:X 18 Mar 23:14:10.212 * +sentinel sentinel 1dcfc361efe53842f96fa6febbd4a1e14f2083d5 127.0.0.1 16480 @ master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:14:12.221 * +sentinel sentinel f7b12d2547b457ac6971fb19f818fcda70739506 127.0.0.1 16481 @ master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:14:15.969 * +slave slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:25:06.960 # +sdown master master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:25:07.014 # +odown master master-6479 127.0.0.1 6479 #quorum 2/2
    5326:X 18 Mar 23:25:07.014 # +new-epoch 1
    5326:X 18 Mar 23:25:07.014 # +try-failover master master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:25:07.017 # +vote-for-leader a0e19053fde3cd81c5ad1e657bc9b0d91a785117 1
    5326:X 18 Mar 23:25:07.024 # f7b12d2547b457ac6971fb19f818fcda70739506 voted for a0e19053fde3cd81c5ad1e657bc9b0d91a785117 1
    5326:X 18 Mar 23:25:07.029 # 1dcfc361efe53842f96fa6febbd4a1e14f2083d5 voted for a0e19053fde3cd81c5ad1e657bc9b0d91a785117 1
    5326:X 18 Mar 23:25:07.093 # +elected-leader master master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:25:07.093 # +failover-state-select-slave master master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:25:07.183 # +selected-slave slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:25:07.183 * +failover-state-send-slaveof-noone slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:25:07.239 * +failover-state-wait-promotion slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:25:08.058 # +promoted-slave slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:25:08.058 # +failover-state-reconf-slaves master master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:25:08.131 # +failover-end master master-6479 127.0.0.1 6479
    5326:X 18 Mar 23:25:08.131 # +switch-master master-6479 127.0.0.1 6479 127.0.0.1 6480
    5326:X 18 Mar 23:25:08.132 * +slave slave 127.0.0.1:6479 127.0.0.1 6479 @ master-6479 127.0.0.1 6480
    5326:X 18 Mar 23:25:11.145 # +sdown slave 127.0.0.1:6479 127.0.0.1 6479 @ master-6479 127.0.0.1 6

Checking sentinel #2 log on port 16480

    tail -50 /var/log/redis/sentinel-16480.log
                    _._                                                  
            _.-``__ ''-._                                             
        _.-``    `.  `_.  ''-._           Redis 3.2.8 (00000000/0) 64 bit
    .-`` .-```.  ```\/    _.,_ ''-._                                   
    (    '      ,       .-`  | `,    )     Running in sentinel mode
    |`-._`-...-` __...-.``-._|'` _.-'|     Port: 16480
    |    `-._   `._    /     _.-'    |     PID: 5373
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
    
    5373:X 18 Mar 23:14:08.072 # Sentinel ID is 1dcfc361efe53842f96fa6febbd4a1e14f2083d5
    5373:X 18 Mar 23:14:08.072 # +monitor master master-6479 127.0.0.1 6479 quorum 2
    5373:X 18 Mar 23:14:09.966 * +sentinel sentinel a0e19053fde3cd81c5ad1e657bc9b0d91a785117 127.0.0.1 16479 @ master-6479 127.0.0.1 6479
    5373:X 18 Mar 23:14:12.221 * +sentinel sentinel f7b12d2547b457ac6971fb19f818fcda70739506 127.0.0.1 16481 @ master-6479 127.0.0.1 6479
    5373:X 18 Mar 23:14:18.142 * +slave slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479
    5373:X 18 Mar 23:25:06.961 # +sdown master master-6479 127.0.0.1 6479
    5373:X 18 Mar 23:25:07.023 # +new-epoch 1
    5373:X 18 Mar 23:25:07.028 # +vote-for-leader a0e19053fde3cd81c5ad1e657bc9b0d91a785117 1
    5373:X 18 Mar 23:25:07.028 # +odown master master-6479 127.0.0.1 6479 #quorum 3/2
    5373:X 18 Mar 23:25:07.028 # Next failover delay: I will not start a failover before Sat Mar 18 23:25:19 2017
    5373:X 18 Mar 23:25:08.136 # +config-update-from sentinel a0e19053fde3cd81c5ad1e657bc9b0d91a785117 127.0.0.1 16479 @ master-6479 127.0.0.1 6479
    5373:X 18 Mar 23:25:08.136 # +switch-master master-6479 127.0.0.1 6479 127.0.0.1 6480
    5373:X 18 Mar 23:25:08.136 * +slave slave 127.0.0.1:6479 127.0.0.1 6479 @ master-6479 127.0.0.1 6480
    5373:X 18 Mar 23:25:11.166 # +sdown slave 127.0.0.1:6479 127.0.0.1 6479 @ master-6479 127.0.0.1 6480

Checking sentinel #3 log on port 16481

    tail -50 /var/log/redis/sentinel-16481.log
                    _._                                                  
            _.-``__ ''-._                                             
        _.-``    `.  `_.  ''-._           Redis 3.2.8 (00000000/0) 64 bit
    .-`` .-```.  ```\/    _.,_ ''-._                                   
    (    '      ,       .-`  | `,    )     Running in sentinel mode
    |`-._`-...-` __...-.``-._|'` _.-'|     Port: 16481
    |    `-._   `._    /     _.-'    |     PID: 5420
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
    
    5420:X 18 Mar 23:14:10.190 # Sentinel ID is f7b12d2547b457ac6971fb19f818fcda70739506
    5420:X 18 Mar 23:14:10.190 # +monitor master master-6479 127.0.0.1 6479 quorum 2
    5420:X 18 Mar 23:14:10.212 * +sentinel sentinel 1dcfc361efe53842f96fa6febbd4a1e14f2083d5 127.0.0.1 16480 @ master-6479 127.0.0.1 6479
    5420:X 18 Mar 23:14:12.000 * +sentinel sentinel a0e19053fde3cd81c5ad1e657bc9b0d91a785117 127.0.0.1 16479 @ master-6479 127.0.0.1 6479
    5420:X 18 Mar 23:14:20.209 * +slave slave 127.0.0.1:6480 127.0.0.1 6480 @ master-6479 127.0.0.1 6479
    5420:X 18 Mar 23:25:06.939 # +sdown master master-6479 127.0.0.1 6479
    5420:X 18 Mar 23:25:07.022 # +new-epoch 1
    5420:X 18 Mar 23:25:07.024 # +vote-for-leader a0e19053fde3cd81c5ad1e657bc9b0d91a785117 1
    5420:X 18 Mar 23:25:08.031 # +odown master master-6479 127.0.0.1 6479 #quorum 3/2
    5420:X 18 Mar 23:25:08.031 # Next failover delay: I will not start a failover before Sat Mar 18 23:25:19 2017
    5420:X 18 Mar 23:25:08.136 # +config-update-from sentinel a0e19053fde3cd81c5ad1e657bc9b0d91a785117 127.0.0.1 16479 @ master-6479 127.0.0.1 6479
    5420:X 18 Mar 23:25:08.136 # +switch-master master-6479 127.0.0.1 6479 127.0.0.1 6480
    5420:X 18 Mar 23:25:08.136 * +slave slave 127.0.0.1:6479 127.0.0.1 6479 @ master-6479 127.0.0.1 6480
    5420:X 18 Mar 23:25:11.140 # +sdown slave 127.0.0.1:6479 127.0.0.1 6479 @ master-6479 127.0.0.1 6480

Restart Redis 6479 port instance will currently be set to redis slave

    systemctl start redis6479

redis 6479 replication info

    redis-cli -h 127.0.0.1 -p 6479 INFO REPLICATION
    # Replication
    role:master
    connected_slaves:0
    master_repl_offset:0
    repl_backlog_active:0
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:0
    repl_backlog_histlen:0

Two additional entries in sentinel log at `/var/log/redis/sentinel-16479.log `

    tail -2 /var/log/redis/sentinel-16479.log 
    5326:X 18 Mar 23:27:17.798 # -sdown slave 127.0.0.1:6479 127.0.0.1 6479 @ master-6479 127.0.0.1 6480
    5326:X 18 Mar 23:27:27.776 * +convert-to-slave slave 127.0.0.1:6479 127.0.0.1 6479 @ master-6479 127.0.0.1 6480

When you run delete command it will wipe the redis instances including sentinel setups

    ./redis-generator.sh delete 2

Monitoring Sentinels
======

Sentinels monitor the health of redis master and slaves but you may need to monitor the status of Sentinel itself. You can setup [Monit](https://mmonit.com/monit/) to monitor your sentinel instances and auto restart sentinel if down.

Example Monit config at `/etc/monit.d/sentinel_16479`

    check process sentinel_16479 with pidfile /var/run/redis/redis-sentinel-16479.pid
      start program = "/etc/init.d/sentinel_16479 start"
      stop program  = "/etc/init.d/sentinel_16479 stop"
      if 2 restarts within 3 cycles then timeout
      if failed host 127.0.0.1 port 16479 then restart

simulate sentinel downtime

```
kill -9 $(cat /var/run/redis/redis-sentinel-16479.pid)
```

```
tail -10 /var/log/monit.log

[UTC Mar 18 23:29:28] info     : Monit daemon with pid [2544] stopped
[UTC Mar 18 23:29:28] info     : 'centos7.localdomain' Monit 5.21.0 stopped
[UTC Mar 18 23:29:29] info     : Starting Monit 5.21.0 daemon with http interface at [127.0.0.1]:2812
[UTC Mar 18 23:29:29] info     : Monit start delay set to 60s
[UTC Mar 18 23:30:29] info     : 'centos7.localdomain' Monit 5.21.0 started
[UTC Mar 18 23:30:29] error    : 'sentinel_16479' process is not running
[UTC Mar 18 23:30:29] info     : 'sentinel_16479' trying to restart
[UTC Mar 18 23:30:29] info     : 'sentinel_16479' start: '/etc/init.d/sentinel_16479 start'
```

```
tail -10 /var/log/redis/sentinel-16479.log
  `-._    `-._`-.__.-'_.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |                                  
  `-._    `-._`-.__.-'_.-'    _.-'                                   
      `-._    `-.__.-'    _.-'                                       
          `-._        _.-'                                           
              `-.__.-'                                               

5745:X 18 Mar 23:30:29.832 # Sentinel ID is a0e19053fde3cd81c5ad1e657bc9b0d91a785117
5745:X 18 Mar 23:30:29.832 # +monitor master master-6479 127.0.0.1 6480 quorum 2
```

Custom Start Ports
======

By default `STARTPORT=6479` is used when you run redis replication mode

    ./redis-generator.sh replication 2

You can create additional redis replication sets by appending a custom start port at end of command i.e. use start port `6597` will create another redis replication set

    ./redis-generator.sh replication 2 6597

Will result in:

* 1st redis replication 2x nodes - master + slave on default 6479 master, 6480 slave with sentinels on 16479, 16480, and 16481 ports
* 2nd redis replication 2x nodes - master + slave on default 6597 master, 6698 slave with sentinels on 16597, 16598, and 16599 ports

```
ps aufxw | grep redis | grep -v grep | sort
redis     5470  0.3  0.1 142896  2760 ?        Ssl  23:14   0:07 /etc/redis6480/redis-server 127.0.0.1:6480
redis     5621  0.3  0.1 142896  2680 ?        Ssl  23:27   0:04 /etc/redis6479/redis-server 127.0.0.1:6479
redis     5959  0.2  0.1 142896  2632 ?        Ssl  23:51   0:00 /etc/redis6597/redis-server 127.0.0.1:6597
redis     6171  0.3  0.1 142896  2592 ?        Ssl  23:51   0:00 /etc/redis6598/redis-server 127.0.0.1:6598
root      5373  0.4  0.1  39308  2156 ?        Ssl  23:14   0:10 /etc/redis6479/redis-server *:16480 [sentinel]
root      5420  0.4  0.1  39308  2152 ?        Ssl  23:14   0:10 /etc/redis6479/redis-server *:16481 [sentinel]
root      5745  0.4  0.1 142896  2120 ?        Ssl  23:30   0:06 /etc/redis6479/redis-server *:16479 [sentinel]
root      6027  0.4  0.1  39308  2140 ?        Ssl  23:51   0:00 /etc/redis6597/redis-server *:16597 [sentinel]
root      6074  0.4  0.1  39308  2140 ?        Ssl  23:51   0:00 /etc/redis6597/redis-server *:16598 [sentinel]
root      6121  0.4  0.1  39308  2136 ?        Ssl  23:51   0:00 /etc/redis6597/redis-server *:16599 [sentinel]
```

Redis Replication Ondisk Persistence Disabled
======

For redis caching only servers, ondisk persistence isn't required so added a new `replication-cache` option


    ./redis-generator.sh replication-cache 2 
    
    Creating redis servers (with ondisk persistence disabled) starting at TCP = 6479...
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
    process_id:15173
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
    creating /root/tools/redis-sentinel/sentinel-16479.conf ...
    
    sentinel sentinel-16479.conf contents
    
    port 16479
    daemonize yes
    dir /var/lib/redis/sentinel_16479
    pidfile /var/run/redis/redis-sentinel-16479.pid
    sentinel monitor master-6479 127.0.0.1 6479 2
    sentinel down-after-milliseconds master-6479 3000
    sentinel failover-timeout master-6479 6000
    sentinel parallel-syncs master-6479 1
    logfile /var/log/redis/sentinel-16479.log
    starting Redis sentinel (sentinel-16479.conf)
    Starting sentinel_16479 ...
    
    -----------------
    creating /root/tools/redis-sentinel/sentinel-16480.conf ...
    
    sentinel sentinel-16480.conf contents
    
    port 16480
    daemonize yes
    dir /var/lib/redis/sentinel_16480
    pidfile /var/run/redis/redis-sentinel-16480.pid
    sentinel monitor master-6479 127.0.0.1 6479 2
    sentinel down-after-milliseconds master-6479 3000
    sentinel failover-timeout master-6479 6000
    sentinel parallel-syncs master-6479 1
    logfile /var/log/redis/sentinel-16480.log
    starting Redis sentinel (sentinel-16480.conf)
    Starting sentinel_16480 ...
    
    -----------------
    creating /root/tools/redis-sentinel/sentinel-16481.conf ...
    
    sentinel sentinel-16481.conf contents
    
    port 16481
    daemonize yes
    dir /var/lib/redis/sentinel_16481
    pidfile /var/run/redis/redis-sentinel-16481.pid
    sentinel monitor master-6479 127.0.0.1 6479 2
    sentinel down-after-milliseconds master-6479 3000
    sentinel failover-timeout master-6479 6000
    sentinel parallel-syncs master-6479 1
    logfile /var/log/redis/sentinel-16481.log
    starting Redis sentinel (sentinel-16481.conf)
    Starting sentinel_16481 ...
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
    process_id:15400
    tcp_port:6480
    uptime_in_seconds:0
    uptime_in_days:0
    executable:/etc/redis6480/redis-server
    config_file:/etc/redis6480/redis6480.conf
    # Replication
    role:slave
    master_host:127.0.0.1
    master_port:6479
    master_link_status:up
    master_last_io_seconds_ago:0
    master_sync_in_progress:0
    slave_repl_offset:446
    slave_priority:100
    slave_read_only:1
    connected_slaves:0
    master_repl_offset:0
    repl_backlog_active:0
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:0
    repl_backlog_histlen:0

redis slave 6480 port config

    egrep '#save|^appendonly' /etc/redis6480/redis6480.conf  
    #save 900 1
    #save 300 10
    #save 60 10000
    appendonly no