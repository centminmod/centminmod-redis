Info:
=======

Redis server generator to create multiple Redis servers locally listening on 127.0.0.1 with starting port `STARTPORT=6479` and incrementally created via integer passed on `redis-generator.sh` command line. Written for CentOS 7 only with [centminmod.com](https://centminmod.com) LEMP stacks specifically.

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
    
    Usage where X equal postive integer for number of redis
    servers to create with incrementing TCP redis ports
    starting at STARTPORT=6479. Append delete flag to remove
    
    ./redis-generator.sh X
    ./redis-generator.sh X delete

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

Creating 6 redis servers on ports 6479-6784


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