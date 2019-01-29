Info:
=======

Redis server generator to create multiple Redis servers in standalone, replication (+ optional sentinel setup) and cluster enabled configurations on local listener `127.0.0.1` with starting port `STARTPORT=6479` and incrementally created additional redis servers via integer passed on `redis-generator.sh` command line. Written for CentOS 7 only with [centminmod.com](https://centminmod.com) LEMP stacks specifically though should work on any CentOS 7 or RHEL 7 based system.

### Redis Source Install Support

* Optional redis source install support has been added. Example of using `redis-generator.sh` with [redis 4.x source installed](examples/redis-sourceinstall-support.md).

Requirements:
=======

* redis 5.0+ or higher branch is required and must be installed prior to using `redis-generator.sh`
* [Remi YUM repository](https://blog.remirepo.net/pages/Config-en) if you want to install redis server via Remi YUM repo for latest redis 4.0 branch. [centminmod.com](https://centminmod.com) auto installer already installs Remi YUM repo.
* Optional: [stunnel](https://www.stunnel.org/index.html) for secure TLS encrypted redis remote connections.

```
yum list stunnel -q
Installed Packages
stunnel.x86_64      5.41-1.el7.centos      installed

rpm -qa --changelog stunnel | head -3
* Sun Jul 16 2017 George Liu <centminmod.com>
- custom stunnel 5.41 rpm built for centminmod.com
```

Redis Server Install:
=======

For [Centmin Mod LEMP web stacks](https://centminmod.com), installing redis 4.0 branch is simple as using these SSH command steps or using `redis-install.sh` script:

`redis-install.sh` script

    ./redis-install.sh install

Manual install steps

    yum -y install redis --enablerepo=remi --disableplugin=priorities
    sed -i 's|LimitNOFILE=.*|LimitNOFILE=262144|' /etc/systemd/system/redis.service.d/limit.conf
    echo "d      /var/run/redis/         0755 redis redis" > /etc/tmpfiles.d/redis.conf
    mkdir -p /var/run/redis
    chown redis:redis /var/run/redis
    chmod 755 /var/run/redis
    systemctl daemon-reload
    systemctl start redis
    systemctl enable redis
    echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
    echo never > /sys/kernel/mm/transparent_hugepage/enabled
    echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local
    sysctl -p

If redis isn't installed `redis-generator.sh` will alert you

    ./redis-generator.sh 
    
    /usr/lib/systemd/system/redis.service not found
    Script is for CentOS 7 only and requires redis
    server installed first

Usage:
=======

Default is to create the redis servers via TCP ports. You can edit `UNIXSOCKET='y'` variable to enable using Unix sockets instead

    ./redis-generator.sh
    
    * Usage: where X equal postive integer for number of redis
    servers to create with incrementing TCP redis ports
    starting at STARTPORT=6479.
    * prep - standalone prep command installs redis-cluster-tool
    * prepupdate - standalone prep update command updates redis-cluster-tool
    * multi X - no. of standalone redis instances to create
    * multi-cache X - no. of standalone redis instances + disable ondisk persistence
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
    ./redis-generator.sh multi-cache X
    ./redis-generator.sh clusterprep X
    ./redis-generator.sh clustermake 6
    ./redis-generator.sh clustermake 9
    ./redis-generator.sh replication X
    ./redis-generator.sh replication X 6579
    ./redis-generator.sh replication-cache X
    ./redis-generator.sh replication-cache X 6579
    ./redis-generator.sh delete X
    ./redis-generator.sh delete X 6579

For `clustermake` options you need to install [redis-cluster-tool](https://github.com/deep011/redis-cluster-tool)  via `prep` command

    ./redis-generator.sh prep

When you create 2 redis servers via command:

    ./redis-generator.sh multi 2

You will create:

* 2 redis server starting at `STARTPORT=6479` for redis on `6479` and `6480` TCP ports.
* redis systemd files for controlling each redis server at `/usr/lib/systemd/system/redis6479.service` and `/usr/lib/systemd/system/redis6480.service`
* redis pid files at `/var/run/redis/redis_6479.pid` and `/var/run/redis/redis_6480.pid`
* dedicated redis directories for each redis server instance at `/etc/redis6479` and `/etc/redis6480`
* main `/usr/bin/redis-server` binary gets symlinked to dedicated redis directories at `/etc/redis6479/redis-server` and `/etc/redis6480/redis-server`
* dedicated redis config files at `/etc/redis6479/redis6479.conf` and `/etc/redis6479/redis6480.conf` 
* each config file will have `dbfilename` as `dump6479.rdb` and `dump6480.rdb` with commented out unix sockets at `/var/run/redis/redis6479.sock` and `/var/run/redis/redis6480.sock`
* dedicated redis data directories at `/var/lib/redis6479` and `/var/lib/redis6480`
* if `cluster` flag is used, each redis config file will reference a `cluster-config-file` in format of `cluster-config-file nodes-150317-003235.conf` where date/timestamped

If you want to create multiple redis grouped clusters, you could make a copy of `redis-generator.sh` as `redis-generator2.sh` and just edit the `STARTPORT=6479` starting port variable to say `STARTPORT=6579`

    ./redis-generator.sh multi 2
    ./redis-generator2.sh multi 2

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

    ./redis-generator.sh prepupdate

Examples:
=======

Below are various examples. For specific redis 9 node cluster setup with auto run of `redis-cluster-tool` example, check this [example](examples/redis-cluster-9.md).

With `DEBUG_REDISGEN='y'` for dry run debug run checks

    ./redis-generator.sh multi 2              
    
    Creating redis servers starting at TCP = 6479...
    -------------------------------------------------------
    creating redis server: redis6479.service [increment value: 0]
    redis TCP port: 6479
    create systemd redis6479.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6479.service
    create /etc/redis6479/redis6479.conf config file
    mkdir -p /etc/redis6479
    cp -a /etc/redis.conf /etc/redis6479/redis6479.conf
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
    redis-cli -h 127.0.0.1 -p 6479 INFO SERVER | egrep 'redis_version|redis_mode|process_id|tcp_port|uptime|executable|config_file'
    -------------------------------------------------------
    creating redis server: redis6480.service [increment value: 1]
    redis TCP port: 6480
    create systemd redis6480.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6480.service
    create /etc/redis6480/redis6480.conf config file
    mkdir -p /etc/redis6480
    cp -a /etc/redis.conf /etc/redis6480/redis6480.conf
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
    redis-cli -h 127.0.0.1 -p 6480 INFO SERVER | egrep 'redis_version|redis_mode|process_id|tcp_port|uptime|executable|config_file'

With `DEBUG_REDISGEN='n'` for live run and generation of redis servers with X = 1 meaning create 2x redis servers on starting port `6479` and `6480` (port incremented by 1)

    ./redis-generator.sh multi 2
    
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
    process_id:11670
    tcp_port:6479
    uptime_in_seconds:0
    uptime_in_days:0
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
    -rw-r----- 1 redis root 46K Feb 13 08:07 /etc/redis6480/redis6480.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6480.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6480.service to /usr/lib/systemd/system/redis6480.service.
    ## Redis TCP 6480 Info ##
    redis_version:3.2.8
    redis_mode:standalone
    process_id:11738
    tcp_port:6480
    uptime_in_seconds:0
    uptime_in_days:0
    executable:/etc/redis6480/redis-server
    config_file:/etc/redis6480/redis6480.conf

```
systemctl status redis6479
● redis6479.service - Redis persistent key-value database
   Loaded: loaded (/usr/lib/systemd/system/redis6479.service; enabled; vendor preset: disabled)
  Drop-In: /etc/systemd/system/redis6479.service.d
           └─limit.conf
   Active: active (running) since Wed 2017-03-15 17:43:50 UTC; 25s ago
 Main PID: 11670 (redis-server)
   CGroup: /system.slice/redis6479.service
           └─11670 /etc/redis6479/redis-server 127.0.0.1:6479

Mar 15 17:43:50 centos7.localdomain systemd[1]: Started Redis persistent key-value database.
Mar 15 17:43:50 centos7.localdomain systemd[1]: Starting Redis persistent key-value database...
```

```
systemctl status redis6480
● redis6480.service - Redis persistent key-value database
   Loaded: loaded (/usr/lib/systemd/system/redis6480.service; enabled; vendor preset: disabled)
  Drop-In: /etc/systemd/system/redis6480.service.d
           └─limit.conf
   Active: active (running) since Wed 2017-03-15 17:43:50 UTC; 27s ago
 Main PID: 11738 (redis-server)
   CGroup: /system.slice/redis6480.service
           └─11738 /etc/redis6480/redis-server 127.0.0.1:6480

Mar 15 17:43:50 centos7.localdomain systemd[1]: Started Redis persistent key-value database.
Mar 15 17:43:50 centos7.localdomain systemd[1]: Starting Redis persistent key-value database...
```

To remove created redis servers, append `delete` flag on end:

    ./redis-generator.sh delete 2
    
    -------------------------------------------------------
    Deleting redis6479.service ...
    Removed symlink /etc/systemd/system/multi-user.target.wants/redis6479.service.
    -------------------------------------------------------
    Deleting redis6480.service ...
    Removed symlink /etc/systemd/system/multi-user.target.wants/redis6480.service.
    Deletion completed


Create 2 redis servers with `UNIXSOCKET='y'` enabled for redis Unix socket usage instead of TCP ports
=========

    ./redis-generator.sh multi 2 
    
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
    process_id:11919
    tcp_port:0
    uptime_in_seconds:0
    uptime_in_days:0
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
    -rw-r----- 1 redis root 46K Feb 13 08:07 /etc/redis6480/redis6480.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6480.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6480.service to /usr/lib/systemd/system/redis6480.service.
    ## Redis TCP 6480 Info ##
    redis_version:3.2.8
    redis_mode:standalone
    process_id:11990
    tcp_port:0
    uptime_in_seconds:0
    uptime_in_days:0
    executable:/etc/redis6480/redis-server
    config_file:/etc/redis6480/redis6480.conf

redis server via Unix socket `/var/run/redis/redis6479.sock`

    redis-cli -s /var/run/redis/redis6479.sock INFO SERVER
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
    process_id:11919
    run_id:2f72840fbe18342fdf57a24ff681997f9f08c26c
    tcp_port:0
    uptime_in_seconds:27
    uptime_in_days:0
    hz:10
    lru_clock:13204966
    executable:/etc/redis6479/redis-server
    config_file:/etc/redis6479/redis6479.conf

Create 2 redis server master + slave replication on ports 6479 and 6480
=========

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

Latest version of `redis-generator.sh` also supports specifying the custom `STARTPORT` for redis replication commands. So to create 2x redis master + slave replication starting on TCP port `6579` instead of default `6479`:

    ./redis-generator.sh replication 2 6579

If TCP port 6579 already in use, you'll get an error

    ./redis-generator.sh replication 2 6579
    
    Error: TCP port 6579 in use, try another port

Optionally, you can enable auto [redis sentinel](https://redis.io/topics/sentinel) setup which is tied to the redis master instance on `STARTPORT` by enabling `SENTINEL_SETUP='y'` prior to running replication command.

* [Create Redis Replication + Sentinel monitor config - 1x master + 1x slave](https://github.com/centminmod/centminmod-redis/blob/master/examples/redis-replication-2-sentinels.md)

9 Redis server cluster
=========

9x Redis server cluster mode with `cluster` flag appended for TCP ports 6479-6487 with manual run of `redis-cluster-tool` to join cluster. Or for specific redis 9 node cluster setup with auto run of `redis-cluster-tool` example, check this [example](examples/redis-cluster-9.md).


    ./redis-generator.sh clusterprep 9
    
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
    enabled cluster mode with cluster-config-file nodes-150317-175739.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6479.service to /usr/lib/systemd/system/redis6479.service.
    ## Redis TCP 6479 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:12972
    tcp_port:6479
    uptime_in_seconds:0
    uptime_in_days:0
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
    -rw-r----- 1 redis root 46K Feb 13 08:07 /etc/redis6480/redis6480.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6480.service
    enabled cluster mode with cluster-config-file nodes-150317-175739.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6480.service to /usr/lib/systemd/system/redis6480.service.
    ## Redis TCP 6480 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:13047
    tcp_port:6480
    uptime_in_seconds:0
    uptime_in_days:0
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
    -rw-r----- 1 redis root 46K Feb 13 08:07 /etc/redis6481/redis6481.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6481.service
    enabled cluster mode with cluster-config-file nodes-150317-175739.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6481.service to /usr/lib/systemd/system/redis6481.service.
    ## Redis TCP 6481 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:13122
    tcp_port:6481
    uptime_in_seconds:0
    uptime_in_days:0
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
    -rw-r----- 1 redis root 46K Feb 13 08:07 /etc/redis6482/redis6482.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6482.service
    enabled cluster mode with cluster-config-file nodes-150317-175739.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6482.service to /usr/lib/systemd/system/redis6482.service.
    ## Redis TCP 6482 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:13197
    tcp_port:6482
    uptime_in_seconds:0
    uptime_in_days:0
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
    -rw-r----- 1 redis root 46K Feb 13 08:07 /etc/redis6483/redis6483.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6483.service
    enabled cluster mode with cluster-config-file nodes-150317-175739.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6483.service to /usr/lib/systemd/system/redis6483.service.
    ## Redis TCP 6483 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:13272
    tcp_port:6483
    uptime_in_seconds:0
    uptime_in_days:0
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
    -rw-r----- 1 redis root 46K Feb 13 08:07 /etc/redis6484/redis6484.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6484.service
    enabled cluster mode with cluster-config-file nodes-150317-175739.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6484.service to /usr/lib/systemd/system/redis6484.service.
    ## Redis TCP 6484 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:13347
    tcp_port:6484
    uptime_in_seconds:0
    uptime_in_days:0
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
    -rw-r----- 1 redis root 46K Feb 13 08:07 /etc/redis6485/redis6485.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6485.service
    enabled cluster mode with cluster-config-file nodes-150317-175739.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6485.service to /usr/lib/systemd/system/redis6485.service.
    ## Redis TCP 6485 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:13422
    tcp_port:6485
    uptime_in_seconds:0
    uptime_in_days:0
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
    -rw-r----- 1 redis root 46K Feb 13 08:07 /etc/redis6486/redis6486.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6486.service
    enabled cluster mode with cluster-config-file nodes-150317-175739.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6486.service to /usr/lib/systemd/system/redis6486.service.
    ## Redis TCP 6486 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:13497
    tcp_port:6486
    uptime_in_seconds:0
    uptime_in_days:0
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
    -rw-r----- 1 redis root 46K Feb 13 08:07 /etc/redis6487/redis6487.conf
    -rw-r--r-- 1 root  root 249 Sep 14 08:43 /usr/lib/systemd/system/redis6487.service
    enabled cluster mode with cluster-config-file nodes-150317-175739.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6487.service to /usr/lib/systemd/system/redis6487.service.
    ## Redis TCP 6487 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:13572
    tcp_port:6487
    uptime_in_seconds:0
    uptime_in_days:0
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

Cluster node info

    redis-cli -h 127.0.0.1 -p 6479 -c cluster nodes | sort -k2
    3d96c3b1a9413ddbe86b76fe647d978c59667fd9 127.0.0.1:6479 myself,master - 0 0 1 connected 0-5461
    f85f542abf5428a7733a8a61aa2f3d3e3753245a 127.0.0.1:6480 slave 3d96c3b1a9413ddbe86b76fe647d978c59667fd9 0 1489600758505 1 connected
    49f574a996f0cf54c7925b87c87aa6d9b8bcde1c 127.0.0.1:6481 slave 3d96c3b1a9413ddbe86b76fe647d978c59667fd9 0 1489600758505 5 connected
    a902dd4f58687378950cd7dcb054c4813cca1f69 127.0.0.1:6482 master - 0 1489600757500 6 connected 5462-10922
    1b9b164150e679c71abdad31d2e0c3529290f5b8 127.0.0.1:6483 slave a902dd4f58687378950cd7dcb054c4813cca1f69 0 1489600759009 7 connected
    d24ebd19b8c509401c6b14e126d88ac208235c12 127.0.0.1:6484 slave a902dd4f58687378950cd7dcb054c4813cca1f69 0 1489600759009 6 connected
    1e9a870450fb67fe96e78e5c1e28fe7a0ffcfbae 127.0.0.1:6485 master - 0 1489600757500 8 connected 10923-16383
    a0ff921249b308dabea33eba5449ebdea0acafed 127.0.0.1:6486 slave 1e9a870450fb67fe96e78e5c1e28fe7a0ffcfbae 0 1489600756994 8 connected
    4070795b598a586827d170b341dbd685b19e0ed0 127.0.0.1:6487 slave 1e9a870450fb67fe96e78e5c1e28fe7a0ffcfbae 0 1489600758505 8 connected

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