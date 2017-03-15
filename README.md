Info:
=======

Redis server generator to create multiple Redis servers in standalone, replication and cluster enabled configurations on local listener `127.0.0.1` with starting port `STARTPORT=6479` and incrementally created additional redis servers via integer passed on `redis-generator.sh` command line. Written for CentOS 7 only with [centminmod.com](https://centminmod.com) LEMP stacks specifically though should work on any CentOS 7 or RHEL 7 based system.

Requirements:
=======

* redis 3.2 branch is required and must be installed prior to using `redis-generator.sh`

Redis install:
=======

For [Centmin Mod LEMP web stacks](https://centminmod.com), installing redis 3.2 branch is simple as using these SSH command steps:

    yum -y install redis --enablerepo=remi --disableplugin=priorities
    sed -i 's|LimitNOFILE=.*|LimitNOFILE=262144|' /etc/systemd/system/redis.service.d/limit.conf
    echo "d      /var/run/redis/         0755 redis redis" > /etc/tmpfiles.d/redis.conf
    mkdir /var/run/redis
    chown redis:redis /var/run/redis
    chmod 755 /var/run/redis
    systemctl daemon-reload
    systemctl start redis
    systemctl enable redis
    echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
    echo never > /sys/kernel/mm/transparent_hugepage/enabled
    echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local
    sysctl -p

Usage:
=======

    ./redis-generator.sh                      
    
    * Usage where X equal postive integer for number of redis
      servers to create with incrementing TCP redis ports
      starting at STARTPORT=6479.
    * Append delete flag to remove
    * Append cluster flag to enable cluster mode
    * Append replication flag to enable replication mode
    * standalone prep command installs redis-cluster-tool
    * standalone prep update command updates redis-cluster-tool
    
    ./redis-generator.sh X
    ./redis-generator.sh X delete
    ./redis-generator.sh X cluster
    ./redis-generator.sh X replication
    ./redis-generator.sh prep
    ./redis-generator.sh prep update

When you create 2 redis servers via command:

    ./redis-generator.sh 2

You will create:

* 2 redis server starting at `STARTPORT=6479` for redis on `6479` and `6480` TCP ports.
* systemd files for controlling each redis server at `/usr/lib/systemd/system/redis6479.service` and `/usr/lib/systemd/system/redis6480.service`
* dedicated redis directories for each redis server instance at `/etc/redis6479` and `/etc/redis6480`
* main `/usr/bin/redis-server` binary gets copied to dedicated redis directories at `/etc/redis6479/redis-server` and `/etc/redis6480/redis-server`
* dedicated redis config files at `/etc/redis6479/redis6479.conf` and `/etc/redis6479/redis6480.conf` 
* each config file will have `dbfilename` as `dump6479.rdb` and `dump6480.rdb` with commented out unix sockets at `/var/run/redis/redis6479.sock` and `/var/run/redis/redis6480.sock`
* dedicated redis data directories at `/var/lib/redis6479` and `/var/lib/redis6480`
* if `cluster` flag is used, each redis config file will reference a `cluster-config-file` in format of `cluster-config-file nodes-150317-003235.conf` where date/timestamped

If you want to create multiple redis grouped clusters, you could make a copy of `redis-generator.sh` as `redis-generator2.sh` and just edit the `STARTPORT=6479` starting port variable to say `STARTPORT=6579`

    ./redis-generator.sh 2
    ./redis-generator2.sh 2

This would create 2x2 sets of redis servers where one set uses TCP ports `6479` and `6480` and other set uses TCP ports `6579` and `6580`

    ps aufxw | grep redis-server | grep -v grep
    redis    20835  0.1  0.1 142896  2476 ?        Ssl  02:09   0:00 /etc/redis6479/redis-server 127.0.0.1:6479
    redis    20902  0.2  0.1 142896  2476 ?        Ssl  02:09   0:00 /etc/redis6480/redis-server 127.0.0.1:6480
    redis    20989  0.1  0.1 142896  2476 ?        Ssl  02:09   0:00 /etc/redis6579/redis-server 127.0.0.1:6579
    redis    21056  0.1  0.1 142896  2476 ?        Ssl  02:09   0:00 /etc/redis6580/redis-server 127.0.0.1:6580

Install & Update redis-cluster-tool:
=======

[redis-cluster-tool](https://github.com/deep011/redis-cluster-tool) is used to join multiple cluster enabled redis server configs created via `redis-generator.sh` into a redis cluster

To install redis-cluster-tool

    ./redis-generator.sh prep

To update redis-cluster tool

    ./redis-generator.sh prep update

Examples:
=======

With `DEBUG_REDISGEN='y'` for dry run debug run checks

    ./redis-generator.sh 2  
    
    Creating redis servers starting at TCP = 6479...
    -------------------------------------------------------
    creating redis server: redis6479.service [increment value: 0]
    redis TCP port: 6479
    /usr/lib/systemd/system/redis6479.service already exists
    /etc/redis6479/redis6479.conf already exists
    mkdir -p /etc/systemd/system/redis6479.service.d/
    \cp -af /etc/systemd/system/redis.service.d/limit.conf /etc/systemd/system/redis6479.service.d/limit.conf
    sed -i "s|^port 6379|port 6479|" /etc/redis6479/redis6479.conf
    mkdir -p /var/lib/redis6479
    chown -R redis:redis /var/lib/redis6479
    \cp -af /usr/bin/redis-server /etc/redis6479/redis-server
    sed -i "s|\/usr\/bin\/redis-server|\/etc\/redis6479\/redis-server|" /usr/lib/systemd/system/redis6479.service
    sed -i "s|dir \/var\/lib\/redis\/|dir \/var\/lib\/redis6479|" /etc/redis6479/redis6479.conf
    sed -i 's|^daemonize no|daemonize yes|' /etc/redis6479/redis6479.conf
    sed -i "s|cluster-config-file nodes-6379.conf|cluster-config-file nodes-6479.conf|" /etc/redis6479/redis6479.conf
    sed -i "s|unixsocket \/tmp\/redis.sock|unixsocket \/var\/run\/redis\/redis6479.sock|" /etc/redis6479/redis6479.conf
    sed -i "s|pidfile \/var\/run\/redis_6379.pid|pidfile \/var\/run\/redis\/redis_6479.pid|" /etc/redis6479/redis6479.conf
    sed -i "s|\/var\/log\/redis\/redis.log|\/var\/log\/redis\/redis6479.log|" /etc/redis6479/redis6479.conf
    sed -i "s|dbfilename dump.rdb|dbfilename dump6479.rdb|" /etc/redis6479/redis6479.conf
    sed -i "s|appendfilename "appendonly.aof"|appendfilename "appendonly6479.aof"|" /etc/redis6479/redis6479.conf
    echo "#masterauth abc123" >> /etc/redis6479/redis6479.conf
    sed -i "s|\/etc\/redis.conf|\/etc\/redis6479\/redis6479.conf|" /usr/lib/systemd/system/redis6479.service
    systemctl daemon-reload
    systemctl restart redis6479
    systemctl enable redis6479
    Redis TCP 6479 Info:
    redis-cli -h 127.0.0.1 -p 6479 INFO SERVER
    -------------------------------------------------------
    creating redis server: redis6480.service [increment value: 1]
    redis TCP port: 6480
    /usr/lib/systemd/system/redis6480.service already exists
    /etc/redis6480/redis6480.conf already exists
    mkdir -p /etc/systemd/system/redis6480.service.d/
    \cp -af /etc/systemd/system/redis.service.d/limit.conf /etc/systemd/system/redis6480.service.d/limit.conf
    sed -i "s|^port 6379|port 6480|" /etc/redis6480/redis6480.conf
    mkdir -p /var/lib/redis6480
    chown -R redis:redis /var/lib/redis6480
    \cp -af /usr/bin/redis-server /etc/redis6480/redis-server
    sed -i "s|\/usr\/bin\/redis-server|\/etc\/redis6480\/redis-server|" /usr/lib/systemd/system/redis6480.service
    sed -i "s|dir \/var\/lib\/redis\/|dir \/var\/lib\/redis6480|" /etc/redis6480/redis6480.conf
    sed -i 's|^daemonize no|daemonize yes|' /etc/redis6480/redis6480.conf
    sed -i "s|cluster-config-file nodes-6379.conf|cluster-config-file nodes-6480.conf|" /etc/redis6480/redis6480.conf
    sed -i "s|unixsocket \/tmp\/redis.sock|unixsocket \/var\/run\/redis\/redis6480.sock|" /etc/redis6480/redis6480.conf
    sed -i "s|pidfile \/var\/run\/redis_6379.pid|pidfile \/var\/run\/redis\/redis_6480.pid|" /etc/redis6480/redis6480.conf
    sed -i "s|\/var\/log\/redis\/redis.log|\/var\/log\/redis\/redis6480.log|" /etc/redis6480/redis6480.conf
    sed -i "s|dbfilename dump.rdb|dbfilename dump6480.rdb|" /etc/redis6480/redis6480.conf
    sed -i "s|appendfilename "appendonly.aof"|appendfilename "appendonly6480.aof"|" /etc/redis6480/redis6480.conf
    echo "#masterauth abc123" >> /etc/redis6480/redis6480.conf
    sed -i "s|\/etc\/redis.conf|\/etc\/redis6480\/redis6480.conf|" /usr/lib/systemd/system/redis6480.service
    systemctl daemon-reload
    systemctl restart redis6480
    systemctl enable redis6480
    Redis TCP 6480 Info:
    redis-cli -h 127.0.0.1 -p 6480 INFO SERVER

With `DEBUG_REDISGEN='n'` for live run and generation of redis servers with X = 1 meaning create 2x redis servers on starting port `6479` and `6480` (port incremented by 1)

    ./redis-generator.sh 2
    
    Creating redis servers starting at TCP = 6479...
    -------------------------------------------------------
    creating redis server: redis6479.service [increment value: 0]
    redis TCP port: 6479
    create systemd redis6479.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6479.service
    create /etc/redis6479/redis6479.conf config file
    mkdir -p /etc/redis6479
    cp -a /etc/redis.conf /etc/redis6479/redis6479.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6479/redis6479.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6479.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6479.service to /usr/lib/systemd/system/redis6479.service.
    ## Redis TCP 6479 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:standalone
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:13850
    run_id:43c228b846803ed9c86723fe9e07bbd02e86190b
    tcp_port:6479
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142005
    executable:/etc/redis6479/redis-server
    config_file:/etc/redis6479/redis6479.conf
    -------------------------------------------------------
    creating redis server: redis6480.service [increment value: 1]
    redis TCP port: 6480
    create systemd redis6480.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6480.service
    create /etc/redis6480/redis6480.conf config file
    mkdir -p /etc/redis6480
    cp -a /etc/redis.conf /etc/redis6480/redis6480.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6480/redis6480.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6480.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6480.service to /usr/lib/systemd/system/redis6480.service.
    ## Redis TCP 6480 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:standalone
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:13917
    run_id:ce770689b40c7df2e64505e0212cb108f6fecc42
    tcp_port:6480
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142005
    executable:/etc/redis6480/redis-server
    config_file:/etc/redis6480/redis6480.conf

```
systemctl status redis6479
● redis6479.service - Redis persistent key-value database
   Loaded: loaded (/usr/lib/systemd/system/redis6479.service; enabled; vendor preset: disabled)
  Drop-In: /etc/systemd/system/redis6479.service.d
           └─limit.conf
   Active: active (running) since Wed 2017-03-15 00:16:53 UTC; 1min 9s ago
 Main PID: 13850 (redis-server)
   CGroup: /system.slice/redis6479.service
           └─13850 /etc/redis6479/redis-server 127.0.0.1:6479

Mar 15 00:16:53 centos7.localdomain systemd[1]: Started Redis persistent key-value database.
Mar 15 00:16:53 centos7.localdomain systemd[1]: Starting Redis persistent key-value database...
```

```
systemctl status redis6480
● redis6480.service - Redis persistent key-value database
   Loaded: loaded (/usr/lib/systemd/system/redis6480.service; enabled; vendor preset: disabled)
  Drop-In: /etc/systemd/system/redis6480.service.d
           └─limit.conf
   Active: active (running) since Wed 2017-03-15 00:16:53 UTC; 1min 12s ago
 Main PID: 13917 (redis-server)
   CGroup: /system.slice/redis6480.service
           └─13917 /etc/redis6480/redis-server 127.0.0.1:6480

Mar 15 00:16:53 centos7.localdomain systemd[1]: Started Redis persistent key-value database.
Mar 15 00:16:53 centos7.localdomain systemd[1]: Starting Redis persistent key-value database...
```

To remove created redis servers, append `delete` flag on end:

    ./redis-generator.sh 2 delete
    
    Deleting redis servers starting at TCP = 6479...
    -------------------------------------------------------
    Deleting redis6479.service ...
    Removed symlink /etc/systemd/system/multi-user.target.wants/redis6479.service.
    -------------------------------------------------------
    Deleting redis6480.service ...
    Removed symlink /etc/systemd/system/multi-user.target.wants/redis6480.service.
    Deletion completed

Create 2 redis server master + slave replication on ports 6479 and 6480
=========

    ./redis-generator.sh 2 replication
    
    Creating redis servers starting at TCP = 6479...
    -------------------------------------------------------
    creating redis server: redis6479.service [increment value: 0]
    redis TCP port: 6479
    create systemd redis6479.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6479.service
    create /etc/redis6479/redis6479.conf config file
    mkdir -p /etc/redis6479
    cp -a /etc/redis.conf /etc/redis6479/redis6479.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6479/redis6479.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6479.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6479.service to /usr/lib/systemd/system/redis6479.service.
    ## Redis TCP 6479 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:standalone
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:21660
    run_id:344020d0cdf418b42cb3b859b461aa5ec4206972
    tcp_port:6479
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13149753
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
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6480/redis6480.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6480.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6480.service to /usr/lib/systemd/system/redis6480.service.
    ## Redis TCP 6480 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:standalone
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:21728
    run_id:4c1696d87b1cded3b57f3ae4ce4eeb0c746639c8
    tcp_port:6480
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13149753
    executable:/etc/redis6480/redis-server
    config_file:/etc/redis6480/redis6480.conf
    # Replication
    role:slave
    master_host:127.0.0.1
    master_port:6479
    master_link_status:down
    master_last_io_seconds_ago:-1
    master_sync_in_progress:1
    slave_repl_offset:1
    master_sync_left_bytes:-1
    master_sync_last_io_seconds_ago:0
    master_link_down_since_seconds:1489544761
    slave_priority:100
    slave_read_only:1
    connected_slaves:0
    master_repl_offset:0
    repl_backlog_active:0
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:0
    repl_backlog_histlen:0

Creating 6 redis servers on ports 6479-6784
=========

    ./redis-generator.sh 6  
    
    Creating redis servers starting at TCP = 6479...
    -------------------------------------------------------
    creating redis server: redis6479.service [increment value: 0]
    redis TCP port: 6479
    create systemd redis6479.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6479.service
    create /etc/redis6479/redis6479.conf config file
    mkdir -p /etc/redis6479
    cp -a /etc/redis.conf /etc/redis6479/redis6479.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6479/redis6479.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6479.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6479.service to /usr/lib/systemd/system/redis6479.service.
    ## Redis TCP 6479 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:standalone
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:14097
    run_id:e01c747a8897cfb24f514e79678d363d05b4b189
    tcp_port:6479
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142142
    executable:/etc/redis6479/redis-server
    config_file:/etc/redis6479/redis6479.conf
    -------------------------------------------------------
    creating redis server: redis6480.service [increment value: 1]
    redis TCP port: 6480
    create systemd redis6480.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6480.service
    create /etc/redis6480/redis6480.conf config file
    mkdir -p /etc/redis6480
    cp -a /etc/redis.conf /etc/redis6480/redis6480.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6480/redis6480.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6480.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6480.service to /usr/lib/systemd/system/redis6480.service.
    ## Redis TCP 6480 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:standalone
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:14164
    run_id:b0ad4ae2f504bc8b27ade9b06b4a79844260056d
    tcp_port:6480
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142142
    executable:/etc/redis6480/redis-server
    config_file:/etc/redis6480/redis6480.conf
    -------------------------------------------------------
    creating redis server: redis6481.service [increment value: 2]
    redis TCP port: 6481
    create systemd redis6481.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6481.service
    create /etc/redis6481/redis6481.conf config file
    mkdir -p /etc/redis6481
    cp -a /etc/redis.conf /etc/redis6481/redis6481.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6481/redis6481.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6481.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6481.service to /usr/lib/systemd/system/redis6481.service.
    ## Redis TCP 6481 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:standalone
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:14231
    run_id:c5f9323e50529bbfbe4aea7e2f8c9ad7ff642eb8
    tcp_port:6481
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142142
    executable:/etc/redis6481/redis-server
    config_file:/etc/redis6481/redis6481.conf
    -------------------------------------------------------
    creating redis server: redis6482.service [increment value: 3]
    redis TCP port: 6482
    create systemd redis6482.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6482.service
    create /etc/redis6482/redis6482.conf config file
    mkdir -p /etc/redis6482
    cp -a /etc/redis.conf /etc/redis6482/redis6482.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6482/redis6482.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6482.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6482.service to /usr/lib/systemd/system/redis6482.service.
    ## Redis TCP 6482 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:standalone
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:14298
    run_id:ae17526363116d82bb18f57f791983a6b87f07d5
    tcp_port:6482
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142143
    executable:/etc/redis6482/redis-server
    config_file:/etc/redis6482/redis6482.conf
    -------------------------------------------------------
    creating redis server: redis6483.service [increment value: 4]
    redis TCP port: 6483
    create systemd redis6483.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6483.service
    create /etc/redis6483/redis6483.conf config file
    mkdir -p /etc/redis6483
    cp -a /etc/redis.conf /etc/redis6483/redis6483.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6483/redis6483.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6483.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6483.service to /usr/lib/systemd/system/redis6483.service.
    ## Redis TCP 6483 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:standalone
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:14365
    run_id:81fd364c4d59539620e0b10c159db485f09e8b17
    tcp_port:6483
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142143
    executable:/etc/redis6483/redis-server
    config_file:/etc/redis6483/redis6483.conf
    -------------------------------------------------------
    creating redis server: redis6484.service [increment value: 5]
    redis TCP port: 6484
    create systemd redis6484.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6484.service
    create /etc/redis6484/redis6484.conf config file
    mkdir -p /etc/redis6484
    cp -a /etc/redis.conf /etc/redis6484/redis6484.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6484/redis6484.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6484.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6484.service to /usr/lib/systemd/system/redis6484.service.
    ## Redis TCP 6484 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:standalone
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:14432
    run_id:6d5caaa8068e2ba7013c7b8fc9851e8ec1492837
    tcp_port:6484
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142143
    executable:/etc/redis6484/redis-server
    config_file:/etc/redis6484/redis6484.conf

Running redis servers

    ps aufxw | grep redis-server | grep -v grep
    redis    14097  0.1  0.1 142896  2476 ?        Ssl  00:19   0:00 /etc/redis6479/redis-server 127.0.0.1:6479
    redis    14164  0.1  0.1 142896  2480 ?        Ssl  00:19   0:00 /etc/redis6480/redis-server 127.0.0.1:6480
    redis    14231  0.1  0.1 142896  2480 ?        Ssl  00:19   0:00 /etc/redis6481/redis-server 127.0.0.1:6481
    redis    14298  0.1  0.1 142896  2480 ?        Ssl  00:19   0:00 /etc/redis6482/redis-server 127.0.0.1:6482
    redis    14365  0.1  0.1 142896  2480 ?        Ssl  00:19   0:00 /etc/redis6483/redis-server 127.0.0.1:6483
    redis    14432  0.1  0.1 142896  2476 ?        Ssl  00:19   0:00 /etc/redis6484/redis-server 127.0.0.1:6484

and

    netstat -plunt | grep redis
    tcp        0      0 127.0.0.1:6479          0.0.0.0:*               LISTEN      14097/redis-server  
    tcp        0      0 127.0.0.1:6480          0.0.0.0:*               LISTEN      14164/redis-server  
    tcp        0      0 127.0.0.1:6481          0.0.0.0:*               LISTEN      14231/redis-server  
    tcp        0      0 127.0.0.1:6482          0.0.0.0:*               LISTEN      14298/redis-server  
    tcp        0      0 127.0.0.1:6483          0.0.0.0:*               LISTEN      14365/redis-server  
    tcp        0      0 127.0.0.1:6484          0.0.0.0:*               LISTEN      14432/redis-server  

9 Redis server cluster
=========

9x Redis server cluster mode with `cluster` flag appended for TCP ports 6479-6487

    ./redis-generator.sh 9 cluster                  
    
    Creating redis servers starting at TCP = 6479...
    -------------------------------------------------------
    creating redis server: redis6479.service [increment value: 0]
    redis TCP port: 6479
    create systemd redis6479.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6479.service
    create /etc/redis6479/redis6479.conf config file
    mkdir -p /etc/redis6479
    cp -a /etc/redis.conf /etc/redis6479/redis6479.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6479/redis6479.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6479.service
    enabled cluster mode with cluster-config-file nodes-150317-003235.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6479.service to /usr/lib/systemd/system/redis6479.service.
    ## Redis TCP 6479 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:cluster
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:17685
    run_id:9fd22a21dd9c3e7176a428b8335f0b5c6a4c3ab8
    tcp_port:6479
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142947
    executable:/etc/redis6479/redis-server
    config_file:/etc/redis6479/redis6479.conf
    # Cluster
    cluster_enabled:1
    -------------------------------------------------------
    creating redis server: redis6480.service [increment value: 1]
    redis TCP port: 6480
    create systemd redis6480.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6480.service
    create /etc/redis6480/redis6480.conf config file
    mkdir -p /etc/redis6480
    cp -a /etc/redis.conf /etc/redis6480/redis6480.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6480/redis6480.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6480.service
    enabled cluster mode with cluster-config-file nodes-150317-003235.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6480.service to /usr/lib/systemd/system/redis6480.service.
    ## Redis TCP 6480 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:cluster
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:17759
    run_id:d5ee420b828fb2eaa33ce3eddab22919c14449e8
    tcp_port:6480
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142948
    executable:/etc/redis6480/redis-server
    config_file:/etc/redis6480/redis6480.conf
    # Cluster
    cluster_enabled:1
    -------------------------------------------------------
    creating redis server: redis6481.service [increment value: 2]
    redis TCP port: 6481
    create systemd redis6481.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6481.service
    create /etc/redis6481/redis6481.conf config file
    mkdir -p /etc/redis6481
    cp -a /etc/redis.conf /etc/redis6481/redis6481.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6481/redis6481.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6481.service
    enabled cluster mode with cluster-config-file nodes-150317-003235.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6481.service to /usr/lib/systemd/system/redis6481.service.
    ## Redis TCP 6481 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:cluster
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:17833
    run_id:1daa2a90aca2ba9efa7374c6fa8703e6d981d95c
    tcp_port:6481
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142948
    executable:/etc/redis6481/redis-server
    config_file:/etc/redis6481/redis6481.conf
    # Cluster
    cluster_enabled:1
    -------------------------------------------------------
    creating redis server: redis6482.service [increment value: 3]
    redis TCP port: 6482
    create systemd redis6482.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6482.service
    create /etc/redis6482/redis6482.conf config file
    mkdir -p /etc/redis6482
    cp -a /etc/redis.conf /etc/redis6482/redis6482.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6482/redis6482.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6482.service
    enabled cluster mode with cluster-config-file nodes-150317-003235.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6482.service to /usr/lib/systemd/system/redis6482.service.
    ## Redis TCP 6482 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:cluster
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:17907
    run_id:77e9a0cc3c227de62eebe31142e65443945c3eda
    tcp_port:6482
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142948
    executable:/etc/redis6482/redis-server
    config_file:/etc/redis6482/redis6482.conf
    # Cluster
    cluster_enabled:1
    -------------------------------------------------------
    creating redis server: redis6483.service [increment value: 4]
    redis TCP port: 6483
    create systemd redis6483.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6483.service
    create /etc/redis6483/redis6483.conf config file
    mkdir -p /etc/redis6483
    cp -a /etc/redis.conf /etc/redis6483/redis6483.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6483/redis6483.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6483.service
    enabled cluster mode with cluster-config-file nodes-150317-003235.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6483.service to /usr/lib/systemd/system/redis6483.service.
    ## Redis TCP 6483 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:cluster
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:17981
    run_id:3bba3cc0766276c17050ae4d0620bd14867765a2
    tcp_port:6483
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142948
    executable:/etc/redis6483/redis-server
    config_file:/etc/redis6483/redis6483.conf
    # Cluster
    cluster_enabled:1
    -------------------------------------------------------
    creating redis server: redis6484.service [increment value: 5]
    redis TCP port: 6484
    create systemd redis6484.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6484.service
    create /etc/redis6484/redis6484.conf config file
    mkdir -p /etc/redis6484
    cp -a /etc/redis.conf /etc/redis6484/redis6484.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6484/redis6484.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6484.service
    enabled cluster mode with cluster-config-file nodes-150317-003235.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6484.service to /usr/lib/systemd/system/redis6484.service.
    ## Redis TCP 6484 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:cluster
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:18055
    run_id:09749a28921f0f0c0000e9cfe3dcdbf0fd14de2e
    tcp_port:6484
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142949
    executable:/etc/redis6484/redis-server
    config_file:/etc/redis6484/redis6484.conf
    # Cluster
    cluster_enabled:1
    -------------------------------------------------------
    creating redis server: redis6485.service [increment value: 6]
    redis TCP port: 6485
    create systemd redis6485.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6485.service
    create /etc/redis6485/redis6485.conf config file
    mkdir -p /etc/redis6485
    cp -a /etc/redis.conf /etc/redis6485/redis6485.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6485/redis6485.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6485.service
    enabled cluster mode with cluster-config-file nodes-150317-003235.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6485.service to /usr/lib/systemd/system/redis6485.service.
    ## Redis TCP 6485 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:cluster
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:18129
    run_id:c4f69d9c60e11de88dd75696d52676cebbf987c0
    tcp_port:6485
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142949
    executable:/etc/redis6485/redis-server
    config_file:/etc/redis6485/redis6485.conf
    # Cluster
    cluster_enabled:1
    -------------------------------------------------------
    creating redis server: redis6486.service [increment value: 7]
    redis TCP port: 6486
    create systemd redis6486.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6486.service
    create /etc/redis6486/redis6486.conf config file
    mkdir -p /etc/redis6486
    cp -a /etc/redis.conf /etc/redis6486/redis6486.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6486/redis6486.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6486.service
    enabled cluster mode with cluster-config-file nodes-150317-003235.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6486.service to /usr/lib/systemd/system/redis6486.service.
    ## Redis TCP 6486 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:cluster
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:18203
    run_id:810260f62c808a5d5d4834d719f82eae4c19c3c3
    tcp_port:6486
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142949
    executable:/etc/redis6486/redis-server
    config_file:/etc/redis6486/redis6486.conf
    # Cluster
    cluster_enabled:1
    -------------------------------------------------------
    creating redis server: redis6487.service [increment value: 8]
    redis TCP port: 6487
    create systemd redis6487.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6487.service
    create /etc/redis6487/redis6487.conf config file
    mkdir -p /etc/redis6487
    cp -a /etc/redis.conf /etc/redis6487/redis6487.conf
    -rw-r----- 1 redis root 46K Mar 13 21:22 /etc/redis6487/redis6487.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6487.service
    enabled cluster mode with cluster-config-file nodes-150317-003235.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6487.service to /usr/lib/systemd/system/redis6487.service.
    ## Redis TCP 6487 Info ##
    # Server
    redis_version:3.2.8
    redis_git_sha1:00000000
    redis_git_dirty:0
    redis_build_id:dd923e72e9efa6d8
    redis_mode:cluster
    os:Linux 3.10.0-514.10.2.el7.x86_64 x86_64
    arch_bits:64
    multiplexing_api:epoll
    gcc_version:4.8.5
    process_id:18277
    run_id:e7893e492aac45d8af86e13f5fabbe6e3350eefd
    tcp_port:6487
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13142949
    executable:/etc/redis6487/redis-server
    config_file:/etc/redis6487/redis6487.conf
    # Cluster
    cluster_enabled:1

Using [redis-cluster-tool](https://github.com/deep011/redis-cluster-tool) to then create redis cluster from the 9x redis servers created

    redis-cluster-tool -C "cluster_create 127.0.0.1:6479[127.0.0.1:6480|127.0.0.1:6481] 127.0.0.1:6482[127.0.0.1:6483|127.0.0.1:6484] 127.0.0.1:6485[127.0.0.1:6486|127.0.0.1:6487]"

output

    redis-cluster-tool -C "cluster_create 127.0.0.1:6479[127.0.0.1:6480|127.0.0.1:6481] 127.0.0.1:6482[127.0.0.1:6483|127.0.0.1:6484] 127.0.0.1:6485[127.0.0.1:6486|127.0.0.1:6487]"
    Waiting for the nodes to join...
    All nodes joined!
    Cluster created success!

Get cluster state

    redis-cluster-tool -a 127.0.0.1:6479 -C cluster_state -r master
    master[127.0.0.1:6479] cluster_state: ok
    master[127.0.0.1:6482] cluster_state: ok
    master[127.0.0.1:6485] cluster_state: ok
    
    All nodes "cluster_state" are SAME: ok

Get cluster used memory

    redis-cluster-tool -a 127.0.0.1:6479 -C cluster_used_memory -r master     
    master[127.0.0.1:6479] used_memory: 2457304 (2 MB 33.33%)
    master[127.0.0.1:6482] used_memory: 2457304 (2 MB 33.33%)
    master[127.0.0.1:6485] used_memory: 2457304 (2 MB 33.33%)
    
    Cluster total "used_memory" : 7371912 (7 MB)

Flush cluster

    redis-cluster-tool -a 127.0.0.1:6479 -C flushall -s
    Do you really want to execute the "flushall"?
    please input "yes" or "no" :
    yes
    
    All nodes "flushall" are OK

Get config value from every node in cluster

    redis-cluster-tool -a 127.0.0.1:6479 -C "cluster_config_get maxmemory" -r master
    master[127.0.0.1:6479] maxmemory: 116391936 (111 MB)
    master[127.0.0.1:6482] maxmemory: 116391936 (111 MB)
    master[127.0.0.1:6485] maxmemory: 116391936 (111 MB)
    
    All nodes "maxmemory" are SAME: 116391936 (111 MB)
    Cluster total maxmemory: 349175808 (333 MB)

Set config value on every node in cluster

    redis-cluster-tool -a 127.0.0.1:6479 -C "cluster_config_set maxmemory 10000000" -s
    Do you really want to execute the "cluster_config_set"?
    please input "yes" or "no" :
    yes
    
    All nodes "config" are OK

Recheck new value

    redis-cluster-tool -a 127.0.0.1:6479 -C "cluster_config_get maxmemory" -r master
    master[127.0.0.1:6479] maxmemory: 10000000 (9 MB)
    master[127.0.0.1:6482] maxmemory: 10000000 (9 MB)
    master[127.0.0.1:6485] maxmemory: 10000000 (9 MB)
    
    All nodes "maxmemory" are SAME: 10000000 (9 MB)
    Cluster total maxmemory: 30000000 (28 MB)

Delete keys in cluster

    redis-cluster-tool -a 127.0.0.1:6479 -C "del_keys 1*"
    Do you really want to execute the "del_keys"?
    please input "yes" or "no" :
    yes
    delete keys job is running...
    delete keys job finished, deleted: 999999 keys, used: 4 s

End result is 9x redis server cluster consisting of 3x sets of Redis master + 2 slaves.

Example of redis port 6479 master with port 6480 and 6481 redis slaves

    redis-cli -h 127.0.0.1 -p 6479 INFO REPLICATION
    # Replication
    role:master
    connected_slaves:2
    slave0:ip=127.0.0.1,port=6480,state=online,offset=1274,lag=0
    slave1:ip=127.0.0.1,port=6481,state=online,offset=1274,lag=0
    master_repl_offset:1274
    repl_backlog_active:1
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:2
    repl_backlog_histlen:1273
    
    redis-cli -h 127.0.0.1 -p 6480 INFO REPLICATION  
    # Replication
    role:slave
    master_host:127.0.0.1
    master_port:6479
    master_link_status:up
    master_last_io_seconds_ago:2
    master_sync_in_progress:0
    slave_repl_offset:1358
    slave_priority:100
    slave_read_only:1
    connected_slaves:0
    master_repl_offset:0
    repl_backlog_active:0
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:0
    repl_backlog_histlen:0
    
    redis-cli -h 127.0.0.1 -p 6481 INFO REPLICATION 
    # Replication
    role:slave
    master_host:127.0.0.1
    master_port:6479
    master_link_status:up
    master_last_io_seconds_ago:8
    master_sync_in_progress:0
    slave_repl_offset:1358
    slave_priority:100
    slave_read_only:1
    connected_slaves:0
    master_repl_offset:0
    repl_backlog_active:0
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:0
    repl_backlog_histlen:0

Example of redis port 6482 master with port 6483 and 6484 redis slaves

    redis-cli -h 127.0.0.1 -p 6482 INFO REPLICATION 
    # Replication
    role:master
    connected_slaves:2
    slave0:ip=127.0.0.1,port=6483,state=online,offset=1498,lag=0
    slave1:ip=127.0.0.1,port=6484,state=online,offset=1498,lag=0
    master_repl_offset:1498
    repl_backlog_active:1
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:2
    repl_backlog_histlen:1497
    
    redis-cli -h 127.0.0.1 -p 6483 INFO REPLICATION 
    # Replication
    role:slave
    master_host:127.0.0.1
    master_port:6482
    master_link_status:up
    master_last_io_seconds_ago:8
    master_sync_in_progress:0
    slave_repl_offset:1498
    slave_priority:100
    slave_read_only:1
    connected_slaves:0
    master_repl_offset:0
    repl_backlog_active:0
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:0
    repl_backlog_histlen:0
    
    redis-cli -h 127.0.0.1 -p 6484 INFO REPLICATION 
    # Replication
    role:slave
    master_host:127.0.0.1
    master_port:6482
    master_link_status:up
    master_last_io_seconds_ago:1
    master_sync_in_progress:0
    slave_repl_offset:1512
    slave_priority:100
    slave_read_only:1
    connected_slaves:0
    master_repl_offset:0
    repl_backlog_active:0
    repl_backlog_size:1048576
    repl_backlog_first_byte_offset:0
    repl_backlog_histlen:0

Test the redis cluster

    redis-cli -h 127.0.0.1 -p 6479 -c set foo bar
    OK
    
    redis-cli -h 127.0.0.1 -p 6479 -c get foo
    "bar"
    
    redis-cli -h 127.0.0.1 -p 6480 -c get foo  
    "bar"
    
    redis-cli -h 127.0.0.1 -p 6481 -c get foo 
    "bar"
    
    redis-cli -h 127.0.0.1 -p 6482 -c get foo  
    "bar"
    
    redis-cli -h 127.0.0.1 -p 6483 -c get foo 
    "bar"
    
    redis-cli -h 127.0.0.1 -p 6484 -c get foo 
    "bar"
    
    redis-cli -h 127.0.0.1 -p 6485 -c get foo 
    "bar"
    
    redis-cli -h 127.0.0.1 -p 6486 -c get foo 
    "bar"
    
    redis-cli -h 127.0.0.1 -p 6487 -c get foo 
    "bar"