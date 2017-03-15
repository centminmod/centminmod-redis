Example
=========

Example of using [redis-generator.sh](https://github.com/centminmod/centminmod-redis) to create a 6 node redis cluster consisting of 3x sets of 1x master + 1x slaves + `redis-cluster-tool` joining of the 9 nodes to create a redis cluster.

    ./redis-generator.sh clustermake 6
    
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
    enabled cluster mode with cluster-config-file nodes-150317-180951.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6479.service to /usr/lib/systemd/system/redis6479.service.
    ## Redis TCP 6479 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:16655
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
    enabled cluster mode with cluster-config-file nodes-150317-180951.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6480.service to /usr/lib/systemd/system/redis6480.service.
    ## Redis TCP 6480 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:16730
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
    enabled cluster mode with cluster-config-file nodes-150317-180951.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6481.service to /usr/lib/systemd/system/redis6481.service.
    ## Redis TCP 6481 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:16805
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
    enabled cluster mode with cluster-config-file nodes-150317-180951.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6482.service to /usr/lib/systemd/system/redis6482.service.
    ## Redis TCP 6482 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:16880
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
    enabled cluster mode with cluster-config-file nodes-150317-180951.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6483.service to /usr/lib/systemd/system/redis6483.service.
    ## Redis TCP 6483 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:16955
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
    enabled cluster mode with cluster-config-file nodes-150317-180951.conf
    Created symlink from /etc/systemd/system/multi-user.target.wants/redis6484.service to /usr/lib/systemd/system/redis6484.service.
    ## Redis TCP 6484 Info ##
    redis_version:3.2.8
    redis_mode:cluster
    process_id:17030
    tcp_port:6484
    uptime_in_seconds:0
    uptime_in_days:0
    executable:/etc/redis6484/redis-server
    config_file:/etc/redis6484/redis6484.conf
    # Cluster
    cluster_enabled:1
    
    Join created 6 node cluster enabled redis instances to cluster
    using redis-cluster-tool: 3x 1x master + 1x slaves
    
    redis-cluster-tool -C "cluster_create 127.0.0.1:6479[127.0.0.1:6480] 127.0.0.1:6481[127.0.0.1:6482] 127.0.0.1:6483[127.0.0.1:6484]"
    Waiting for the nodes to join...
    All nodes joined!
    Cluster created success!
    
    redis-cluster-tool -a 127.0.0.1:6479 -C cluster_state -r master
    master[127.0.0.1:6479] cluster_state: ok
    master[127.0.0.1:6481] cluster_state: ok
    master[127.0.0.1:6483] cluster_state: ok
    
    All nodes "cluster_state" are SAME: ok
    
    redis-cluster-tool -a 127.0.0.1:6479 -C cluster_state -r slave
    slave[127.0.0.1:6480] cluster_state: ok
    slave[127.0.0.1:6482] cluster_state: ok
    slave[127.0.0.1:6484] cluster_state: ok
    
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

Cluster node info

    redis-cli -h 127.0.0.1 -p 6479 -c cluster nodes | sort -k2
    f6585413fc9b52fdfee16cb365307dfb63e5cb3a 127.0.0.1:6479 myself,master - 0 0 0 connected 0-5461
    2da2ac9160ece8c7af8e88af42a3234781f8d715 127.0.0.1:6480 slave f6585413fc9b52fdfee16cb365307dfb63e5cb3a 0 1489601460236 5 connected
    841e165d9e822debdddb881f42f0348e418baaf5 127.0.0.1:6481 master - 0 1489601461744 3 connected 5462-10922
    9309d34f26513820d40e37e9b02e1c113c7d92a7 127.0.0.1:6482 slave 841e165d9e822debdddb881f42f0348e418baaf5 0 1489601460236 3 connected
    28370f7db9b2d952288842d3b55e812fdb6f2ee1 127.0.0.1:6483 master - 0 1489601460738 4 connected 10923-16383
    7b1e66a701e323273ca6358b98172eedb295b742 127.0.0.1:6484 slave 28370f7db9b2d952288842d3b55e812fdb6f2ee1 0 1489601461743 4 connected