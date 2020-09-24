#!/bin/sh

while !(grep "women-soccer-swopr-varnish-1047803442.eu-west-1.elb.amazonaws.com" test.txt > /dev/null) || !(grep "women-s-soccer-swopr-varnish-1725766073.eu-west-1.elb.amazonaws.com" test.txt > /dev/null); do
	aws elb delete-load-balancer --load-balancer-name women-soccer-swopr-varnish > /dev/null
	aws elb create-load-balancer --load-balancer-name women-soccer-swopr-varnish --listener Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80 --security-groups sg-058a895b228a50545 --subnets "subnet-049fee5e" "subnet-5867503e" "subnet-6b858223" > test.txt
	cat test.txt | xargs
	sleep 1
done

