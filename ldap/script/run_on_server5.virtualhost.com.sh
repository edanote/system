cat hosts >> /etc/hosts

yum -y install openldap compat-openldap openldap-clients openldap-servers openldap-servers-sql openldap-devel rsyslog net-tools less vim
systemctl start slapd.service
systemctl enable slapd.service

echo "local4.* /var/log/ldap.log" >> /etc/rsyslog.conf
systemctl restart rsyslog

cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown -R ldap:ldap /var/lib/ldap/

#


ldapadd -Y EXTERNAL -H ldapi:/// -f syncprov_mod.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f olcserverid_server5.virtualhost.com.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f olcdatabase.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f configrep.ldif

