#!/bin/bash
######################################################
# written by George Liu (eva2000) centminmod.com
######################################################
# variables
#############
DT=`date +"%d%m%y-%H%M%S"`

STARTPORT=6479
######################################################
# functions
#############

genredis() {
  NUMBER=$1
  echo
  echo "Creating redis servers starting at TCP = $STARTPORT..."
  for (( p=0; p <= $NUMBER; p++ ))
    do
      REDISPORT=$(($STARTPORT+$p))
      echo "redis TCP port: $REDISPORT"
      echo "increment value: $p"
  done
}

######################################################
NUM=$1

if [[ "$NUM" -eq "$NUM" 2> /dev/null ]]; then
  # NUM is a number
  genredis $NUM
else
  echo "Usage where X equal postive integer for number of redis"
  echo "servers to create with incrementing TCP redis ports"
  echo "starting at STARTPORT=6479"
  echo "$0 X"
fi