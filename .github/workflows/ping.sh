#! /usr/bin/env bash
set -e

server=$1

ping ${server} -c 5 > list.txt
  echo ${server} 
  avg=$(cat list.txt | grep rtt | cut -d' ' -f4 | cut -d'/' -f2)
  echo "avg: $avg"
  percent=$(cat list.txt |grep -oE "[0-9]%+" | grep -oE "[0-9]+") 
  echo "packet loss: $percent"
  time=$(cat list.txt | grep packets | grep -oE "[0-9]+ms" | grep -oE "[0-9]+")
  echo "time: $time"
if [ ${percent} == 0 ]; then
	echo "ping_server_avg ${avg}" | curl -s --data-binary @- http://grafana_pushgateway:9091/metrics/job/check_ping_avg/instance/${server}
	echo "ping_server_time ${time}" | curl -s --data-binary @- http://grafana_pushgateway:9091/metrics/job/ping_time/instance/${server}
	#echo "ping_server ${percent}" | curl -v --data-binary @- http://127.0.0.1:9091/metrics/job/ping_${server}
fi
#sleep 10
