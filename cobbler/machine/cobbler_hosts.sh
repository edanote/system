# add cobbler system

echo setting serverA1
if [ `cobbler system find | grep "^serverA1$"` ]; then
    cobbler system remove --name=serverA1
fi
cobbler system add --name=serverA1 --mac=A0:00:00:00:00:01 --ip-address=192.168.10.161 --subnet=255.255.255.0 --gateway=192.168.10.1 --interface=eth0 --static=1 --hostname=serverA1 --name-servers=192.168.10.1 --kickstart=/var/lib/cobbler/kickstarts/rhel6.7-x86_64.ks --profile=rhel6.7-x86_64

echo setting serverA2
if [ `cobbler system find | grep "^serverA2$"` ]; then
    cobbler system remove --name=serverA2
fi
cobbler system add --name=serverA2 --mac=A0:00:00:00:00:02 --ip-address=192.168.10.162 --subnet=255.255.255.0 --gateway=192.168.10.1 --interface=eth0 --static=1 --hostname=serverA2 --name-servers=192.168.10.1 --kickstart=/var/lib/cobbler/kickstarts/rhel6.7-x86_64.ks --profile=rhel6.7-x86_64

echo setting serverA3
if [ `cobbler system find | grep "^serverA3$"` ]; then
    cobbler system remove --name=serverA3
fi
cobbler system add --name=serverA3 --mac=A0:00:00:00:00:03 --ip-address=192.168.10.163 --subnet=255.255.255.0 --gateway=192.168.10.1 --interface=eth0 --static=1 --hostname=serverA3 --name-servers=192.168.10.1 --kickstart=/var/lib/cobbler/kickstarts/rhel6.7-x86_64.ks --profile=rhel6.7-x86_64

echo setting serverA4
if [ `cobbler system find | grep "^serverA4$"` ]; then
    cobbler system remove --name=serverA4
fi
cobbler system add --name=serverA4 --mac=A0:00:00:00:00:04 --ip-address=192.168.10.164 --subnet=255.255.255.0 --gateway=192.168.10.1 --interface=eth0 --static=1 --hostname=serverA4 --name-servers=192.168.10.1 --kickstart=/var/lib/cobbler/kickstarts/rhel6.7-x86_64.ks --profile=rhel6.7-x86_64

echo setting serverA5
if [ `cobbler system find | grep "^serverA5$"` ]; then
    cobbler system remove --name=serverA5
fi
cobbler system add --name=serverA5 --mac=A0:00:00:00:00:05 --ip-address=192.168.10.165 --subnet=255.255.255.0 --gateway=192.168.10.1 --interface=eth0 --static=1 --hostname=serverA5 --name-servers=192.168.10.1 --kickstart=/var/lib/cobbler/kickstarts/rhel6.7-x86_64.ks --profile=rhel6.7-x86_64

echo setting serverB1
if [ `cobbler system find | grep "^serverB1$"` ]; then
    cobbler system remove --name=serverB1
fi
cobbler system add --name=serverB1 --mac=B0:00:00:00:00:01 --ip-address=192.168.10.171 --subnet=255.255.255.0 --gateway=192.168.10.1 --interface=eth0 --static=1 --hostname=serverB1 --name-servers=192.168.10.1 --kickstart=/var/lib/cobbler/kickstarts/rhel7.7-x86_64.ks --profile=rhel7.7-x86_64

echo setting serverB2
if [ `cobbler system find | grep "^serverB2$"` ]; then
    cobbler system remove --name=serverB2
fi
cobbler system add --name=serverB2 --mac=B0:00:00:00:00:02 --ip-address=192.168.10.172 --subnet=255.255.255.0 --gateway=192.168.10.1 --interface=eth0 --static=1 --hostname=serverB2 --name-servers=192.168.10.1 --kickstart=/var/lib/cobbler/kickstarts/rhel7.7-x86_64.ks --profile=rhel7.7-x86_64

echo setting serverB3
if [ `cobbler system find | grep "^serverB3$"` ]; then
    cobbler system remove --name=serverB3
fi
cobbler system add --name=serverB3 --mac=B0:00:00:00:00:03 --ip-address=192.168.10.173 --subnet=255.255.255.0 --gateway=192.168.10.1 --interface=eth0 --static=1 --hostname=serverB3 --name-servers=192.168.10.1 --kickstart=/var/lib/cobbler/kickstarts/rhel7.7-x86_64.ks --profile=rhel7.7-x86_64

echo setting serverB4
if [ `cobbler system find | grep "^serverB4$"` ]; then
    cobbler system remove --name=serverB4
fi
cobbler system add --name=serverB4 --mac=B0:00:00:00:00:04 --ip-address=192.168.10.174 --subnet=255.255.255.0 --gateway=192.168.10.1 --interface=eth0 --static=1 --hostname=serverB4 --name-servers=192.168.10.1 --kickstart=/var/lib/cobbler/kickstarts/rhel7.7-x86_64.ks --profile=rhel7.7-x86_64

echo setting serverB5
if [ `cobbler system find | grep "^serverB5$"` ]; then
    cobbler system remove --name=serverB5
fi
cobbler system add --name=serverB5 --mac=B0:00:00:00:00:05 --ip-address=192.168.10.175 --subnet=255.255.255.0 --gateway=192.168.10.1 --interface=eth0 --static=1 --hostname=serverB5 --name-servers=192.168.10.1 --kickstart=/var/lib/cobbler/kickstarts/rhel7.7-x86_64.ks --profile=rhel7.7-x86_64
