#!/bin/sh

while read hosts;do
	echo " -----------------------------------------"
	echo "host: "$hosts
	echo " -----------------------------------------"
	dig "$hosts" | grep "$hosts"
done <hosts.txt
