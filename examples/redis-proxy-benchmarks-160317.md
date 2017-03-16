Comparing various Redis proxy solutions for Redis Cluster - 6x node setup with 3x masters + 3 slaves created with [redis-generator.sh](https://github.com/centminmod/centminmod-redis) as well as 3x sets of 1x redis master + 1x redis slaves.

Redis Cluster & Proxy Configs
=====

* Direct access to Redis cluster on port 6479
* Centmin Mod Nginx 1.11 TCP stream based upstream proxy on port 19001
* Twitter's Twemproxy https://github.com/twitter/twemproxy/ on port 22224
* Netflix's Dynomite https://github.com/Netflix/dynomite on port 8102
* Corvus https://github.com/eleme/corvus/ on port 12345

**Config 1:** Redis 6x node Cluster created via [redis-generator.sh](https://github.com/centminmod/centminmod-redis)

```
./redis-generator.sh clustermake 6
```

```
redis-cli -h 127.0.0.1 -p 6479 -c cluster nodes | sort -k2
2f9616bc82b44ea1f64a8e9c9f6bcb348bf3217d 127.0.0.1:6479 myself,master - 0 0 5 connected 0-5461
08672e48a24d006b5a85bca3d8923981b3531ef7 127.0.0.1:6480 slave 2f9616bc82b44ea1f64a8e9c9f6bcb348bf3217d 0 1489628341623 5 connected
c9d717149d630fecf05d0f313e2a1e74e6a831d3 127.0.0.1:6481 master - 0 1489628341623 0 connected 5462-10922
661b317601ddb3c9c2dafca4de6544d68f5a6cd8 127.0.0.1:6482 slave c9d717149d630fecf05d0f313e2a1e74e6a831d3 0 1489628342627 3 connected
5a7df83da1fa245ab913fc361c6d2847c070c09d 127.0.0.1:6483 master - 0 1489628341120 4 connected 10923-16383
9016a024d692cb4674afcb673dcd598a83082af8 127.0.0.1:6484 slave 5a7df83da1fa245ab913fc361c6d2847c070c09d 0 1489628342627 4 connected
```

**Config 2:** Redis 3x sets of 1x redis master + 1x redis slave created via [redis-generator.sh](https://github.com/centminmod/centminmod-redis) using 3 copies of the script with `STARTPORT` set to 6479, 6579 and 6679 respectively for Redis masters

* Note Corvus doesn't work in this config as it needs to be running on a Redis cluster

```
./redis-generator.sh replication 2
./redis-generator2.sh replication 2
./redis-generator3.sh replication 2
```

```
redis-cli -h 127.0.0.1 -p 6479 INFO REPLICATION            
# Replication
role:master
connected_slaves:1
slave0:ip=127.0.0.1,port=6480,state=online,offset=477,lag=1
master_repl_offset:477
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:2
repl_backlog_histlen:476
```

```
redis-cli -h 127.0.0.1 -p 6579 INFO REPLICATION 
# Replication
role:master
connected_slaves:1
slave0:ip=127.0.0.1,port=6580,state=online,offset=211,lag=1
master_repl_offset:211
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:2
repl_backlog_histlen:210
```

```
redis-cli -h 127.0.0.1 -p 6679 INFO REPLICATION 
# Replication
role:master
connected_slaves:1
slave0:ip=127.0.0.1,port=6680,state=online,offset=211,lag=1
master_repl_offset:211
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:2
repl_backlog_histlen:210
```


**System Config**

* CentOS 7.3 64bit VirtualBox 
* 4 CPU
* 2GB RAM
* 20GB SSD DISK
* Samsung ATIV Book 8 Laptop - Intel Core i7 3635QM Quad Core + HT (8 cpu threads)
* [Centmin Mod 123.09beta01 LEMP Stack](https://centminmod.com)

Benchmark Parameters
=====

Where $PORT = listening port outlined above

* redis-benchmark -h 127.0.0.1 -p $PORT -n 1000 -r 1000 -t set -P 1000 -c 100
* redis-benchmark -h 127.0.0.1 -p $PORT -n 1000 -r 1000 -t get -P 1000 -c 100
* redis-benchmark -h 127.0.0.1 -p $PORT -n 1000 -r 1000 -t mset -P 1000 -c 100  

Benchmark Results
=====


6x Redis Cluster Config

| Redis Proxy Solution | set | get | mset |
| --- | --- | --- | --- |
| Direct Redis Cluster | 6250.00 | 6060.61 | 13888.89 |
| Centmin Mod Nginx TCP Proxy | 15625.00 | 18181.82 | 10309.28 |
| Twitter Twemproxy | 2272.73 | 1736.11 | 564.97 |
| Netflix Dynomite | 564.97 | 640.20 | [not supported](https://github.com/Netflix/dynomite/blob/master/notes/redis.md) |
| Corvus | 35.08 | 26.54 | 6.26 |


3x Redis Master + Slave Config

| Redis Proxy Solution | set | get | mset |
| --- | --- | --- | --- |
| Direct Redis Master 6479 | 4273.50 | 5263.16 | 778.82 |
| Centmin Mod Nginx TCP Proxy 6479,6579,6679 | 16666.67 | 19230.77 | 3267.97 |
| Twitter Twemproxy  6479,6579,6679| 1824.82 | 1457.73 | 337.84 |
| Netflix Dynomite 6479 | 558.97 | 594.53 | [not supported](https://github.com/Netflix/dynomite/blob/master/notes/redis.md) |
| Corvus | NA | NA | NA |


Nginx TCP Stream config
=====

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


```
stream {
  upstream backend {
    zone     upstream_backend 10m;
    least_conn;

    server 127.0.0.1:6479;
    server 127.0.0.1:6579;
    server 127.0.0.1:6679;
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

Twitter's Twemproxy config
=====

`/etc/nutcracker/nutcracker.yml`

```
crm:
  listen: 127.0.0.1:22224
  hash: fnv1a_64
  distribution: ketama
  timeout: 400
  backlog: 8192
  auto_eject_hosts: true
  server_retry_timeout: 2000
  server_failure_limit: 1
  redis: true
  #redis_auth: PASS
  servers:
   - 127.0.0.1:6479:1
   - 127.0.0.1:6481:1
   - 127.0.0.1:6483:1
```

```
crm:
  listen: 127.0.0.1:22224
  hash: fnv1a_64
  distribution: ketama
  timeout: 400
  backlog: 8192
  auto_eject_hosts: true
  server_retry_timeout: 2000
  server_failure_limit: 1
  redis: true
  #redis_auth: PASS
  servers:
   - 127.0.0.1:6479:1
   - 127.0.0.1:6579:1
   - 127.0.0.1:6679:1
```

Netflix's Dynomite config
=====

`/etc/dynomite/dynomite.yml`

```
dyn_o_mite:
  datacenter: default_dc
  dyn_listen: 0.0.0.0:8101
  dyn_port: 8101
  dyn_seed_provider: simple_provider
  listen: 0.0.0.0:8102
  rack: localrack1
  servers:
  - 127.0.0.1:6479:1
  timeout: 5000
  tokens: 4294967295
  data_store: 0
  mbuf_size: 16384
  max_msgs: 300000
```

Corvus config
=====

`/etc/corvus/corvus.conf`

```
bind 12345
node 127.0.0.1:6479,127.0.0.1:6481,127.0.0.1:6483
thread 4

# debug, info, warn, error
loglevel debug
syslog 0

# Close the connection after client idle for `client_timeout` seconds.
# No response after `server_timeout` seconds waiting for redis-server
# connection to redis-server will be closed.
#
# Value 0 means never timeout.
#
# Default 0
#
# client_timeout 30
# server_timeout 5

# Statsd config
# metrics:
#   corvus.<cluster>.<host-port>.<value label>
#
#   corvus.default.localhost-12345.connected_clients
#   corvus.default.localhost-12345.completed_commands
#   corvus.default.localhost-12345.used_cpu_sys
#   corvus.default.localhost-12345.used_cpu_user
#   corvus.default.localhost-12345.latency
#   corvus.default.localhost-12345.redis-node.127-0-0-1-8000.bytes.{send,recv}
#
# Cluster annotation. Using `cluster` to add a cluster name to metrics.
#
# cluster default
#
# Metrices are sent using udp socket. Using `statsd` config to
# set statsd server address. Every `metric_interval` senconds
# will produce a set of metrices.
#
# statsd localhost:8125
# metric_interval 10

# Buffer size allocated each time avoiding fregments
# Buffer used in processing data recieving or sending
# Min buffer size is limited to 64 Bytes
# Default value is 16KBytes (16384)
#
# bufsize 16384
#
# Client should send AUTH <PASSWORD> if `requirepass` setted.
# Corvus will not forward this command, and do authentication just by itself.
# If it is given empty, it will be no effect and you can access the proxy with no password check.
#
# requirepass password
#
# Use `read-strategy` to config how to read from the cluster. It has three valid
# values:
#
#   * `master`, forward all reading commands to master, the default
#   * `read-slave-only`, forward all reading commands to slaves
#   * `both`, forward reading commands to both master and slaves
#
# If new slaves are added to the cluster, `PROXY UPDATESLOTMAP` should be emmited
# to tell corvus to use the newly added slaves.
#
# read-strategy master

# Slowlog
# The following two configs are almost the same with redis.
# Every command whose lantency exceeds `slowlog-log-slower-than` will be considered a slow command,
# which will be sent to statsd and can also be retrieved using `slowlog get`.
# Note that the lantency here is the time spent in proxy,
# including redirection caused by MOVED and ASK.
# Both slowlog command and sending slowlog to statsd are disabled by default.
# You can enable both or either of them.
#
# A zero value will log every command.
# slowlog-log-slower-than 10000
#
# Set this to positive value to enable slowlog command.
# slowlog-max-len 1024
#
# Set this to 1 if you want to send slowlog to statsd.
# slowlog-statsd-enabled 0
```