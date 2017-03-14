Info:
=======

Redis server generator to create multiple Redis servers locally listening on 127.0.0.1 with starting port `STARTPORT=6479` and incrementally created via integer passed on `redis-generator.sh` command line. Written for CentOS 7 only with [centminmod.com](https://centminmod.com) LEMP stacks specifically.

Usage:
=======

    ./redis-generator.sh
    
    Usage where X equal postive integer for number of redis
    servers to create with incrementing TCP redis ports
    starting at STARTPORT=6479
    
    ./redis-generator.sh X

Examples:
=======

With `DEBUG_REDISGEN='y'` for dry run debug run checks

    ./redis-generator.sh 1
    
    Creating redis servers starting at TCP = 6479...
    -------------------------------------------------------
    creating redis server: redis6479.service [increment value: 0]
    redis TCP port: 6479
    create systemd redis6479.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6479.service
    create /etc/redis6479.conf config file
    cp -a /etc/redis.conf /etc/redis6479.conf
    grep: /etc/redis6479.conf: No such file or directory
    sed -i "s|^port 6379|port 6479|" /etc/redis6479.conf
    sed -i 's|^daemonize no|daemonize yes|' /etc/redis6479.conf
    sed -i "s|pidfile \/var\/run\/redis_6379.pid|pidfile \/var\/run\/redis\/redis_6479.pid|" /etc/redis6479.conf
    sed -i "s|\/var\/log\/redis\/redis.log|\/var\/log\/redis\/redis6479.log|" /etc/redis6479.conf
    sed -i "s|dbfilename dump.rdb|dbfilename dump6479.rdb|" /etc/redis6479.conf
    sed -i "s|appendfilename "appendonly.aof"|appendfilename "appendonly6479.aof"|" /etc/redis6479.conf
    echo "#masterauth abc123" >> /etc/redis6479.conf
    sed -i "s|\/etc\/redis.conf|\/etc\/redis6479.conf|" /usr/lib/systemd/system/redis6479.service
    systemctl daemon-reload
    systemctl restart redis6479
    Redis TCP 6479 Info:
    redis-cli -h 127.0.0.1 -p 6479 INFO SERVER
    -------------------------------------------------------
    creating redis server: redis6480.service [increment value: 1]
    redis TCP port: 6480
    create systemd redis6480.service
    cp -a /usr/lib/systemd/system/redis.service /usr/lib/systemd/system/redis6480.service
    create /etc/redis6480.conf config file
    cp -a /etc/redis.conf /etc/redis6480.conf
    grep: /etc/redis6480.conf: No such file or directory
    sed -i "s|^port 6379|port 6480|" /etc/redis6480.conf
    sed -i 's|^daemonize no|daemonize yes|' /etc/redis6480.conf
    sed -i "s|pidfile \/var\/run\/redis_6379.pid|pidfile \/var\/run\/redis\/redis_6480.pid|" /etc/redis6480.conf
    sed -i "s|\/var\/log\/redis\/redis.log|\/var\/log\/redis\/redis6480.log|" /etc/redis6480.conf
    sed -i "s|dbfilename dump.rdb|dbfilename dump6480.rdb|" /etc/redis6480.conf
    sed -i "s|appendfilename "appendonly.aof"|appendfilename "appendonly6480.aof"|" /etc/redis6480.conf
    echo "#masterauth abc123" >> /etc/redis6480.conf
    sed -i "s|\/etc\/redis.conf|\/etc\/redis6480.conf|" /usr/lib/systemd/system/redis6480.service
    systemctl daemon-reload
    systemctl restart redis6480
    Redis TCP 6480 Info:
    redis-cli -h 127.0.0.1 -p 6480 INFO SERVER