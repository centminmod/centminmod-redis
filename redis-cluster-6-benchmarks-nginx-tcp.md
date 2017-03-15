Example
=========

Example of using [redis-generator.sh](https://github.com/centminmod/centminmod-redis) to create a 6 node redis cluster consisting of 3x sets of 1x master + 1x slaves + `redis-cluster-tool` joining of the 6 nodes to create a redis cluster and then setting up Centmin Mod Nginx 1.11 TCP Upstream load balancing proxy and running some redis-benchmark runs.

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

Redis Benchmarks
==================

6479 direct Redis cluster tests

```
redis-benchmark -h 127.0.0.1 -p 6479 -n 1000 -r 1000 -t set -P 1000 -c 100      
====== SET ======
  1000 requests completed in 0.16 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 11 milliseconds
36.50% <= 16 milliseconds
72.90% <= 17 milliseconds
100.00% <= 17 milliseconds
6250.00 requests per second

```

```
redis-benchmark -h 127.0.0.1 -p 6479 -n 1000 -r 1000 -t set -P 1000 -c 100      
====== SET ======
  1000 requests completed in 0.16 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 11 milliseconds
36.50% <= 16 milliseconds
72.90% <= 17 milliseconds
100.00% <= 17 milliseconds
6250.00 requests per second
```

```
redis-benchmark -h 127.0.0.1 -p 6479 -n 1000 -r 1000 -t get -P 1000 -c 100 
====== GET ======
  1000 requests completed in 0.17 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 9 milliseconds
45.60% <= 30 milliseconds
91.10% <= 31 milliseconds
100.00% <= 31 milliseconds
6060.61 requests per second
```

```
redis-benchmark -h 127.0.0.1 -p 6479 -n 1000 -r 1000 -t mset -P 1000 -c 100   
====== MSET (10 keys) ======
  1000 requests completed in 0.07 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 65 milliseconds
41.70% <= 66 milliseconds
70.90% <= 67 milliseconds
100.00% <= 67 milliseconds
13888.89 requests per second
```

```
redis-benchmark -h 127.0.0.1 -p 6479 -n 1000 -r 1000 -t get,set,lpush,lpop -P 1000 -c 100      
====== SET ======
  1000 requests completed in 0.16 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 12 milliseconds
36.50% <= 17 milliseconds
72.90% <= 18 milliseconds
100.00% <= 18 milliseconds
6451.61 requests per second

====== GET ======
  1000 requests completed in 0.41 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 262 milliseconds
45.60% <= 263 milliseconds
100.00% <= 263 milliseconds
2450.98 requests per second

====== LPUSH ======
  1000 requests completed in 0.50 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 5 milliseconds
45.60% <= 176 milliseconds
100.00% <= 176 milliseconds
1988.07 requests per second

====== LPOP ======
  1000 requests completed in 0.77 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 507 milliseconds
63.10% <= 508 milliseconds
100.00% <= 508 milliseconds
1303.78 requests per second
```

Centmin Mod Ngixn 1.11 TCP upstream stream proxy load balancing the 3x redis masters

setup nginx TCP stream Redis proxy listening on port 19001

```
stream {
  upstream backend {
    zone     upstream_backend 10m;
    least_conn;

    server 127.0.0.1:6479;
    server 127.0.0.1:6481;
    server 127.0.0.1:6483;
  }

  server {
    listen 127.0.0.1:19001 reuseport;
    #proxy_bind 127.0.0.1:19001;
    proxy_connect_timeout 1s;
    proxy_timeout 3s;
    proxy_pass backend;
  }
}
```

redis-benchmark Nginx TCP stream proxy on port 19001

```
redis-benchmark -h 127.0.0.1 -p 19001 -n 1000 -r 1000 -t set -P 1000 -c 100        
====== SET ======
  1000 requests completed in 0.06 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 12 milliseconds
27.30% <= 13 milliseconds
100.00% <= 13 milliseconds
15625.00 requests per second
```

```
redis-benchmark -h 127.0.0.1 -p 19001 -n 1000 -r 1000 -t get -P 1000 -c 100 
====== GET ======
  1000 requests completed in 0.05 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 10 milliseconds
100.00% <= 10 milliseconds
18181.82 requests per second
```

```
redis-benchmark -h 127.0.0.1 -p 19001 -n 1000 -r 1000 -t mset -P 1000 -c 100 
====== MSET (10 keys) ======
  1000 requests completed in 0.10 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 82 milliseconds
29.30% <= 83 milliseconds
41.70% <= 84 milliseconds
100.00% <= 84 milliseconds
10309.28 requests per second
```

```
redis-benchmark -h 127.0.0.1 -p 19001 -n 1000 -r 1000 -t get,set,lpush,lpop -P 1000 -c 100    
====== SET ======
  1000 requests completed in 0.10 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 17 milliseconds
100.00% <= 17 milliseconds
9708.74 requests per second

====== GET ======
  1000 requests completed in 0.12 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 27 milliseconds
91.10% <= 28 milliseconds
100.00% <= 28 milliseconds
8474.58 requests per second

====== LPUSH ======
  1000 requests completed in 0.02 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 8 milliseconds
41.60% <= 9 milliseconds
100.00% <= 9 milliseconds
47619.05 requests per second

====== LPOP ======
  1000 requests completed in 0.01 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 5 milliseconds
41.60% <= 6 milliseconds
100.00% <= 6 milliseconds
111111.12 requests per second

```

setup nginx TCP stream Redis proxy listening on port 19001 with `proxy_buffer_size` = 64k

```
stream {
  upstream backend {
    zone     upstream_backend 10m;
    least_conn;

    server 127.0.0.1:6479;
    server 127.0.0.1:6481;
    server 127.0.0.1:6483;
  }

  server {
    listen 127.0.0.1:19001 reuseport;
    #proxy_bind 127.0.0.1:19001;
    proxy_buffer_size 64k;
    proxy_connect_timeout 1s;
    proxy_timeout 3s;
    proxy_pass backend;
  }
}
```

```
redis-benchmark -h 127.0.0.1 -p 19001 -n 1000 -r 1000 -t get -P 1000 -c 100
====== GET ======
  1000 requests completed in 0.03 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 18 milliseconds
26.20% <= 19 milliseconds
100.00% <= 19 milliseconds
34482.76 requests per second
```

```
redis-benchmark -h 127.0.0.1 -p 19001 -n 1000 -r 1000 -t set -P 1000 -c 100 
====== SET ======
  1000 requests completed in 0.05 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 27 milliseconds
72.90% <= 28 milliseconds
100.00% <= 28 milliseconds
20000.00 requests per second
```

```
redis-benchmark -h 127.0.0.1 -p 19001 -n 1000 -r 1000 -t mset -P 1000 -c 100
====== MSET (10 keys) ======
  1000 requests completed in 0.10 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 86 milliseconds
29.30% <= 87 milliseconds
41.70% <= 88 milliseconds
70.90% <= 89 milliseconds
100.00% <= 89 milliseconds
9615.38 requests per second
```

```
redis-benchmark -h 127.0.0.1 -p 19001 -n 1000 -r 1000 -t get,set,lpush,lpop -P 1000 -c 100
====== SET ======
  1000 requests completed in 0.05 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 40 milliseconds
79.60% <= 41 milliseconds
100.00% <= 41 milliseconds
22222.22 requests per second

====== GET ======
  1000 requests completed in 0.16 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 91 milliseconds
45.60% <= 92 milliseconds
100.00% <= 92 milliseconds
6211.18 requests per second

====== LPUSH ======
  1000 requests completed in 0.05 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 5 milliseconds
45.60% <= 10 milliseconds
100.00% <= 10 milliseconds
21276.60 requests per second

====== LPOP ======
  1000 requests completed in 0.02 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

0.10% <= 5 milliseconds
63.10% <= 18 milliseconds
100.00% <= 18 milliseconds
43478.26 requests per second
```