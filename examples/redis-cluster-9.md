Example
=========

Example of using [redis-generator.sh](https://github.com/centminmod/centminmod-redis) to create a 9 node redis cluster consisting of 3x sets of 1x master + 2x slaves + `redis-cluster-tool` joining of the 9 nodes to create a redis cluster.

    ./redis-generator.sh clustermake 9
    
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
    enabled cluster mode with cluster-config-file nodes-150317-180034.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6479.service to /usr/lib/systemd/system/redis6479.service.
    ## Redis TCP 6479 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:14068
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
    enabled cluster mode with cluster-config-file nodes-150317-180034.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6480.service to /usr/lib/systemd/system/redis6480.service.
    ## Redis TCP 6480 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:14143
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
    enabled cluster mode with cluster-config-file nodes-150317-180034.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6481.service to /usr/lib/systemd/system/redis6481.service.
    ## Redis TCP 6481 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:14218
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
    enabled cluster mode with cluster-config-file nodes-150317-180034.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6482.service to /usr/lib/systemd/system/redis6482.service.
    ## Redis TCP 6482 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:14293
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
    enabled cluster mode with cluster-config-file nodes-150317-180034.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6483.service to /usr/lib/systemd/system/redis6483.service.
    ## Redis TCP 6483 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:14368
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
    enabled cluster mode with cluster-config-file nodes-150317-180034.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6484.service to /usr/lib/systemd/system/redis6484.service.
    ## Redis TCP 6484 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:14443
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
    enabled cluster mode with cluster-config-file nodes-150317-180034.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6485.service to /usr/lib/systemd/system/redis6485.service.
    ## Redis TCP 6485 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:14518
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
    enabled cluster mode with cluster-config-file nodes-150317-180034.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6486.service to /usr/lib/systemd/system/redis6486.service.
    ## Redis TCP 6486 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:14593
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
    enabled cluster mode with cluster-config-file nodes-150317-180034.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6487.service to /usr/lib/systemd/system/redis6487.service.
    ## Redis TCP 6487 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:14668
    tcp_port:6487
    uptime_in_seconds:0
    uptime_in_days:0
    executable:/etc/redis6487/redis-server
    config_file:/etc/redis6487/redis6487.conf
    # Cluster
    cluster_enabled:1
    
    Join created 9 node cluster enabled redis instances to cluster
    using redis-cluster-tool: 3x 1x master + 2x slaves
    
    redis-cluster-tool -C "cluster_create 127.0.0.1:6479[127.0.0.1:6480|127.0.0.1:6481] 127.0.0.1:6482[127.0.0.1:6483|127.0.0.1:6484] 127.0.0.1:6485[127.0.0.1:6486|127.0.0.1:6487]"
    Waiting for the nodes to join...
    All nodes joined!
    Cluster created success!
    
    redis-cluster-tool -a 127.0.0.1:6479 -C cluster_state -r master
    master[127.0.0.1:6479] cluster_state: ok
    master[127.0.0.1:6482] cluster_state: ok
    master[127.0.0.1:6485] cluster_state: ok
    
    All nodes "cluster_state" are SAME: ok
    
    redis-cluster-tool -a 127.0.0.1:6479 -C cluster_state -r slave
    slave[127.0.0.1:6480] cluster_state: ok
    slave[127.0.0.1:6481] cluster_state: ok
    slave[127.0.0.1:6483] cluster_state: ok
    slave[127.0.0.1:6484] cluster_state: ok
    slave[127.0.0.1:6486] cluster_state: ok
    slave[127.0.0.1:6487] cluster_state: ok
    
    All nodes "cluster_state" are SAME: ok


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

Cluster node info

    redis-cli -h 127.0.0.1 -p 6479 -c cluster nodes | sort -k2
    ad19d87ec30f3e6d0e7645916260b11e3cdd8525 127.0.0.1:6479 myself,master - 0 0 3 connected 0-5461
    6b6dfc86f002c95a2ca9d6e2902d5bb8818acc49 127.0.0.1:6480 slave ad19d87ec30f3e6d0e7645916260b11e3cdd8525 0 1489600881924 4 connected
    c63fadce5c8923ddd15e2be324f5dfe9f2a219ef 127.0.0.1:6481 slave ad19d87ec30f3e6d0e7645916260b11e3cdd8525 0 1489600880916 3 connected
    8a9bcabe52f064a1b1acb86191d1693b93863832 127.0.0.1:6482 master - 0 1489600881421 1 connected 5462-10922
    503bd1f34f875ab5e41397d7ace8e1566fc9b60e 127.0.0.1:6483 slave 8a9bcabe52f064a1b1acb86191d1693b93863832 0 1489600880916 5 connected
    1a09318cd9d1644bd4ef4c1b9036bc675a93ac9c 127.0.0.1:6484 slave 8a9bcabe52f064a1b1acb86191d1693b93863832 0 1489600881924 6 connected
    61a67d6075c614e769b7b772da4408d41b9e0f9d 127.0.0.1:6485 master - 0 1489600879905 4 connected 10923-16383
    8225eb06a4dceafd68b362f90de29f0dc0052dea 127.0.0.1:6486 slave 61a67d6075c614e769b7b772da4408d41b9e0f9d 0 1489600881421 5 connected
    e73f854c1c7e923599146697949b1da1269b9543 127.0.0.1:6487 slave 61a67d6075c614e769b7b772da4408d41b9e0f9d 0 1489600880916 4 connected