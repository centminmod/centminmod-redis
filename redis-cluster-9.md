Example
=========

Creating a 9 node redis cluster consisting of 3x sets of 1x master + 2x slaves + `redis-cluster-tool` joining of the 9 nodes to create a redis cluster

    ./redis-generator.sh 9 cluster 9                                            
    
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
    enabled cluster mode with cluster-config-file nodes-150317-051259.conf
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
    process_id:3478
    run_id:fbc2ae007bb5fd68aa76172b15b3ba4900bc5ecb
    tcp_port:6479
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13159771
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
    enabled cluster mode with cluster-config-file nodes-150317-051259.conf
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
    process_id:3552
    run_id:3de050593bbfa3015499a34b97c156f919580a1a
    tcp_port:6480
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13159771
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
    enabled cluster mode with cluster-config-file nodes-150317-051259.conf
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
    process_id:3626
    run_id:bae6d94f4547a8eca772ef509701e8ce94cd6b8c
    tcp_port:6481
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13159771
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
    enabled cluster mode with cluster-config-file nodes-150317-051259.conf
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
    process_id:3700
    run_id:42fc4a8e017153dc1b30b8f117333ccbae828bf1
    tcp_port:6482
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13159771
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
    enabled cluster mode with cluster-config-file nodes-150317-051259.conf
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
    process_id:3774
    run_id:6646f6deb203ce96071a228639aa30f7f2a1aae1
    tcp_port:6483
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13159772
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
    enabled cluster mode with cluster-config-file nodes-150317-051259.conf
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
    process_id:3848
    run_id:bebbcb06806bef131263627ea551d3b40babb957
    tcp_port:6484
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13159772
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
    enabled cluster mode with cluster-config-file nodes-150317-051259.conf
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
    process_id:3922
    run_id:3bf9dee1125b878ec85788faa7d0cea5c2764180
    tcp_port:6485
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13159772
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
    enabled cluster mode with cluster-config-file nodes-150317-051259.conf
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
    process_id:3996
    run_id:17a779328b329724f9cf5374910fc06be5f2c26e
    tcp_port:6486
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13159773
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
    enabled cluster mode with cluster-config-file nodes-150317-051259.conf
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
    process_id:4070
    run_id:6732bae60c9ea6c52a1de23b42ff99a42bd9150d
    tcp_port:6487
    uptime_in_seconds:0
    uptime_in_days:0
    hz:10
    lru_clock:13159773
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