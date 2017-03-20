Redis Source Install Binary Support
=========

[redis-generator.sh](https://github.com/centminmod/centminmod-redis) can now optionally support [redis source installed bianries](https://github.com/antirez/redis) at `/usr/local/bin/redis-server` via a new `USE_SOURCEREDIS='y'` variable. You still need for redis remi yum repo installed package as redis-generator.sh borrows the systemd redis.service file and makes a custom copy for redis source installed binaries at /usr/local/bin/redis-server etc. This allows you to use `redis-generator.sh` and create concurrent redis servers of different redis versions - one for redis remi yum repo installed redis 3.2.8 and one for your desired redis source installed version. Below example is using [redis 4.0-rc2](http://antirez.com/news/110) source install as an example.

To enable this, set `USE_SOURCEREDIS='y'` and then example to create 2 redis server master + slave replication on ports 6479 and 6480 + enable auto [redis sentinel](https://redis.io/topics/sentinel) setup (3x sentinel with quorum of 2) which is tied to the redis master instance on `STARTPORT` by enabling `SENTINEL_SETUP='y'` prior to running replication command.

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
* redis-server binaries at `/etc/redis6479/redis-server` and `/etc/redis6480/redis-server` copied from `/usr/local/bin/redis-server` (source install) instead of `/usr/bin/redis-server`
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
    redis_version:3.9.102
    redis_mode:standalone
    process_id:13222
    tcp_port:6479
    uptime_in_seconds:0
    uptime_in_days:0
    executable:/etc/redis6479/redis-server
    config_file:/etc/redis6479/redis6479.conf
    # Replication
    role:master
    connected_slaves:0
    master_replid:0cac33b29e726409d8b4c28eab35de2c0171ea97
    master_replid2:0000000000000000000000000000000000000000
    master_repl_offset:0
    second_repl_offset:-1
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
    redis_version:3.9.102
    redis_mode:standalone
    process_id:13438
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
    slave_repl_offset:445
    slave_priority:100
    slave_read_only:1
    connected_slaves:0
    master_replid:678fc5fbb792e0c9259b258413376862355d0edf
    master_replid2:0000000000000000000000000000000000000000
    master_repl_offset:445
    second_repl_offset:-1
    repl_backlog_active:1
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:1
    repl_backlog_histlen:445

For example redis 4.0-rc2 version (tagged as 3.9.102) source install 

    /usr/local/bin/redis-cli -v
    redis-cli 3.9.102 (git:8226f2c3)
    
    /usr/local/bin/redis-server -v
    Redis server v=3.9.102 sha=8226f2c3:0 malloc=jemalloc-4.0.3 bits=64 build=4b846d91c40ae29c


Using `/usr/local/bin/redis-cli` for redis 4.0-rc2 master 6479

    /usr/local/bin/redis-cli -h 127.0.0.1 -p 6479 INFO
    # Server
    redis_version:3.9.102
    redis_git_sha1:8226f2c3
    redis_git_dirty:0
    redis_build_id:4b846d91c40ae29c
    redis_mode:standalone
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:13222
    run_id:52d44b86f8c65905dea1e2d3862c922de8cd4c43
    tcp_port:6479
    uptime_in_seconds:460
    uptime_in_days:0
    hz:10
    lru_clock:13578243
    executable:/etc/redis6479/redis-server
    config_file:/etc/redis6479/redis6479.conf
    
    # Clients
    connected_clients:7
    client_longest_output_list:0
    client_biggest_input_buf:0
    blocked_clients:0
    
    # Memory
    used_memory:2104792
    used_memory_human:2.01M
    used_memory_rss:2859008
    used_memory_rss_human:2.73M
    used_memory_peak:2123872
    used_memory_peak_human:2.03M
    used_memory_peak_perc:99.10%
    used_memory_overhead:2047300
    used_memory_startup:765672
    used_memory_dataset:57492
    used_memory_dataset_perc:4.29%
    total_system_memory:1928937472
    total_system_memory_human:1.80G
    used_memory_lua:37888
    used_memory_lua_human:37.00K
    maxmemory:0
    maxmemory_human:0B
    maxmemory_policy:noeviction
    mem_fragmentation_ratio:1.36
    mem_allocator:jemalloc-4.0.3
    lazyfree_pending_objects:0
    
    # Persistence
    loading:0
    rdb_changes_since_last_save:0
    rdb_bgsave_in_progress:0
    rdb_last_save_time:1489972800
    rdb_last_bgsave_status:ok
    rdb_last_bgsave_time_sec:0
    rdb_current_bgsave_time_sec:-1
    rdb_last_cow_size:208896
    aof_enabled:0
    aof_rewrite_in_progress:0
    aof_rewrite_scheduled:0
    aof_last_rewrite_time_sec:-1
    aof_current_rewrite_time_sec:-1
    aof_last_bgrewrite_status:ok
    aof_last_write_status:ok
    aof_last_cow_size:0
    
    # Stats
    total_connections_received:10
    total_commands_processed:2582
    instantaneous_ops_per_sec:3
    total_net_input_bytes:128016
    total_net_output_bytes:3408326
    instantaneous_input_kbps:0.21
    instantaneous_output_kbps:0.68
    rejected_connections:0
    sync_full:1
    sync_partial_ok:0
    sync_partial_err:0
    expired_keys:0
    evicted_keys:0
    keyspace_hits:0
    keyspace_misses:0
    pubsub_channels:1
    pubsub_patterns:0
    latest_fork_usec:378
    migrate_cached_sockets:0
    
    # Replication
    role:master
    connected_slaves:1
    slave0:ip=127.0.0.1,port=6480,state=online,offset=89869,lag=0
    master_replid:678fc5fbb792e0c9259b258413376862355d0edf
    master_replid2:0000000000000000000000000000000000000000
    master_repl_offset:89869
    second_repl_offset:-1
    repl_backlog_active:1
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:1
    repl_backlog_histlen:89869
    
    # CPU
    used_cpu_sys:0.61
    used_cpu_user:0.92
    used_cpu_sys_children:0.00
    used_cpu_user_children:0.00
    
    # Cluster
    cluster_enabled:0
    
    # Keyspace

Processes for replication setup above

    ps aufxw | grep redis | grep -v grep
    redis    13222  0.3  0.1 147244  2928 ?        Ssl  01:19   0:03 /etc/redis6479/redis-server 127.0.0.1:6479
    root     13290  0.4  0.1  41608  2332 ?        Ssl  01:19   0:04 /etc/redis6479/redis-server *:16479 [sentinel]
    root     13338  0.4  0.1  41608  2336 ?        Ssl  01:19   0:04 /etc/redis6479/redis-server *:16480 [sentinel]
    root     13386  0.4  0.1  41608  2336 ?        Ssl  01:19   0:04 /etc/redis6479/redis-server *:16481 [sentinel]
    redis    13438  0.3  0.1 147244  2904 ?        Ssl  01:19   0:03 /etc/redis6480/redis-server 127.0.0.1:6480

Contents of systemd file `/usr/lib/systemd/system/redis6479.service`

    [Unit]
    Description=Redis persistent key-value database
    After=network.target
    
    [Service]
    ExecStart=/etc/redis6479/redis-server /etc/redis6479/redis6479.conf --daemonize no
    ExecStop=/usr/local/bin/redis-shutdown
    User=redis
    Group=redis
    
    [Install]
    WantedBy=multi-user.target

Redis master 6479 log file `/var/log/redis/redis6479.log`

    tail -100 /var/log/redis/redis6479.log
                    _._                                                  
            _.-``__ ''-._                                             
        _.-``    `.  `_.  ''-._           Redis 3.9.102 (8226f2c3/0) 64 bit
    .-`` .-```.  ```\/    _.,_ ''-._                                   
    (    '      ,       .-`  | `,    )     Running in standalone mode
    |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6479
    |    `-._   `._    /     _.-'    |     PID: 13222
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
    
    13222:M 20 Mar 01:19:51.766 # Server started, Redis version 3.9.102
    13222:M 20 Mar 01:19:51.766 * The server is now ready to accept connections on port 6479
    13222:M 20 Mar 01:20:00.332 * Slave 127.0.0.1:6480 asks for synchronization
    13222:M 20 Mar 01:20:00.332 * Full resync requested by slave 127.0.0.1:6480
    13222:M 20 Mar 01:20:00.332 * Starting BGSAVE for SYNC with target: disk
    13222:M 20 Mar 01:20:00.332 * Background saving started by pid 13442
    13442:C 20 Mar 01:20:00.337 * DB saved on disk
    13442:C 20 Mar 01:20:00.338 * RDB: 0 MB of memory used by copy-on-write
    13222:M 20 Mar 01:20:00.345 * Background saving terminated with success
    13222:M 20 Mar 01:20:00.345 * Synchronization with slave 127.0.0.1:6480 succeeded