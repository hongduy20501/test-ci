#! /usr/bin/env bash
set -e
#server=$1
#times=$2
#docker node ls --format {{.Hostname}} >> server.list
while true
do
  while read -r server; do
	./ping.sh ${server}
  done < server.list
  sleep 10s
done
