#!/bin/bash
######################################################
# get redis database keys
# written by George Liu (eva2000) centminmod.com
######################################################
# variables
#############
DT=$(date +"%d%m%y-%H%M%S")

######################################################
# functions
#############

if [ ! -f /usr/bin/redis-cli ]; then
  echo "redis-cli not found"
  exit 1
fi

get_keys() {
  dbnumber="$1"
  if [[ "$dbnumber" ]]; then
    dbn="$dbnumber"
  else
    dbn=$(redis-cli info keyspace | awk -F : '/^db/ {print $1}' | cut -c3)
  fi

  for d in $dbn; do
    redis-cli -n $d KEYS '*' | while read k; do key=$(echo "$k" | awk '{print $1}'); echo "---"; echo "redis key: $key"; echo -n "redis expiry ttl: "; redis-cli TTL "$key"; done
  done
}

purge_keys() {
  dbnumber="$1"
  if [[ "$dbnumber" ]]; then
    dbn="$dbnumber"
  else
    dbn=$(redis-cli info keyspace | awk -F : '/^db/ {print $1}' | cut -c3)
  fi

  for d in $dbn; do
    redis-cli -n $d FLUSHDB | while read k; do echo "Purging redis database $d: $k"; done
  done
}

######################################################

case "$1" in
  get )
    get_keys "$2"
    ;;
  purge )
    purge_keys
    ;;
  * )
    echo
    echo "Usage:"
    echo
    echo "$0 get {redis_db_number}"
    echo "$0 purge {redis_db_number}"
    echo
    ;;
esac

exit