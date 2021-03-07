cp ltb-project.repo /etc/yum.repos.d/
yum -y install openldap compat-openldap openldap-clients openldap-servers openldap-servers-sql openldap-devel rsyslog net-tools less vim
yum -y install self-service-password php-ldap php-mcrypt libmcrypt libmcrypt-devel mcrypt mhash

