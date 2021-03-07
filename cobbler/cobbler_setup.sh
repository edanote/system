#!/bin/bash

export server=192.168.10.201
export subnet=192.168.10.0
export netmask=255.255.255.0
export routers=192.168.10.1
export domain_name_servers=$server
export subnet_mask=$netmask
export ip_start=192.168.10.210
export ip_stop=192.168.10.220
os_ver=`sed -r 's#.+?(6|7).+#\1#g' /etc/redhat-release`

function install_cobbler()
{
    echo -e "\033[34mbegin cobbler install\033[0m"
    yum install -y wget epel-release.noarch
#    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-${os_ver}.repo
    yum -y install httpd dhcp tftp python-ctypes cobbler xinetd cobbler-web vim net-tools
    systemctl restart httpd cobblerd rsyncd
    systemctl enable  httpd cobblerd rsyncd
    systemctl status  httpd cobblerd rsyncd
    sleep 5
    echo -e "\033[34mend of cobbler install\033[0m"
}

function set_cobbler_config()
{
    echo -e "\033[34mbegin cobbler setting\033[0m"
    cobbler check
    echo -e "\033[34m    begin /etc/cobbler/settings file update\033[0m"
    sed -ri "s/^server:(\s+)[0-9]+.[0-9]+.[0-9]+.[0-9]+/server:\1$server/" /etc/cobbler/settings
    sed -ri "s/^next_server:(\s+)[0-9]+.[0-9]+.[0-9]+.[0-9]+/next_server:\1$server/" /etc/cobbler/settings
    sed -ri "s/^manage_dhcp:(\s+)0/manage_dhcp:\11/" /etc/cobbler/settings
    sed -ri "s/^manage_tftpd:(\s+)0/manage_tftpd:\11/" /etc/cobbler/settings
    sed -ri "s/^manage_rsync:(\s+)0/manage_rsync:\11/" /etc/cobbler/settings
    sed -i "s#yes#no#" /etc/xinetd.d/tftp
    sed -ri "/default_password_crypted/s#(.*:\s+).*#\1\"`openssl passwd -1 -salt 'oceanhoasdhakdhakjs' '123456'`\"#" /etc/cobbler/settings
    echo -e "\033[34m    end of /etc/cobbler/settings file update\033[0m"
    sleep 5
    cobbler get-loaders
    cobbler signature update
#    systemctl enable rsyncd
#    systemctl start rsyncd

    # set dhcp
    echo -e "\033[34m    begin /etc/cobbler/dhcp.template file update\033[0m"
    sed -ri "s/subnet(\s+)[0-9]+.[0-9]+.[0-9]+.[0-9]+/subnet\1$subnet/" /etc/cobbler/dhcp.template
    sed -ri "s/netmask(\s+)[0-9]+.[0-9]+.[0-9]+.[0-9]+/netmask\1$netmask/" /etc/cobbler/dhcp.template
    sed -ri "s/routers(\s+)[0-9]+.[0-9]+.[0-9]+.[0-9]+/routers\1$routers/" /etc/cobbler/dhcp.template
    sed -ri "s/domain-name-servers(\s+)[0-9]+.[0-9]+.[0-9]+.[0-9]+/domain-name-servers\1$domain_name_servers/" /etc/cobbler/dhcp.template
    sed -ri "s/subnet-mask(\s+)[0-9]+.[0-9]+.[0-9]+.[0-9]+/subnet-mask\1${subnet_mask}/" /etc/cobbler/dhcp.template
    sed -ri "s/dynamic-bootp(\s+)[0-9]+.[0-9]+.[0-9]+.[0-9]+(\s+)[0-9]+.[0-9]+.[0-9]+.[0-9]+/dynamic-bootp\1$ip_start\2$ip_stop/" /etc/cobbler/dhcp.template
    echo -e "\033[34m    end of /etc/cobbler/dhcp.template file update\033[0m"

    systemctl restart cobblerd.service
    sleep 5
    cobbler sync
    cobbler check
    systemctl restart xinetd cobblerd httpd rsyncd dhcpd tftp
    sleep 10
    echo -e "\033[34mend of cobbler setting\033[0m"
}


function main()
{
    install_cobbler
    set_cobbler_config
}

main

# cobbler import --path=/ISO/rhel7.7 --name=rhel7.7 --arch=x86_64
# systemctl restart xinetd cobblerd httpd rsyncd dhcpd tftp

