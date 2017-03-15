Example
=========

Example of using [redis-generator.sh](https://github.com/centminmod/centminmod-redis) to create 2 redis server master + slave replication on ports 6479 and 6480

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
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6479.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6479.service to /usr/lib/systemd/system/redis6479.service.
    ## Redis TCP 6479 Info ##
    redis_version:3.2.8
    redis_mode:standalone
    process_id:12724
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
    -------------------------------------------------------
    creating redis server: redis6480.service [increment value: 1]
    redis TCP port: 6480
    create systemd redis6480.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6480.service
    create /etc/redis6480/redis6480.conf config file
    mkdir -p /etc/redis6480
    cp -a /etc/redis.conf /etc/redis6480/redis6480.conf
    -rw-r----- 1 redis root 46K Feb 13 08:07 /etc/redis6480/redis6480.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6480.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6480.service to /usr/lib/systemd/system/redis6480.service.
    ## Redis TCP 6480 Info ##
    redis_version:3.2.8
    redis_mode:standalone
    process_id:12794
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
    master_last_io_seconds_ago:2
    master_sync_in_progress:0
    slave_repl_offset:1
    slave_priority:100
    slave_read_only:1
    connected_slaves:0
    master_repl_offset:0
    repl_backlog_active:0
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:0
    repl_backlog_histlen:0