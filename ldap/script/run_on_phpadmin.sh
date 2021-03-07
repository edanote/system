yum install -y epel*
yum install httpd phpldapadmin -y

ldapmodify -Y EXTERNAL -H ldapi:/// -f syncprov.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f olcdatabasehdb.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f monitor.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f updatepass.ldif

ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif 
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif

#ldapadd -x -W -D "cn=ldapadm,dc=itzgeek,dc=local" -f base.ldif


cp /etc/httpd/conf.d/phpldapadmin.conf /etc/httpd/conf.d/phpldapadmin.conf_org
sed -i '/Directory/,/Directory/ s/^/#/' /etc/httpd/conf.d/phpldapadmin.conf
echo "<Directory /usr/share/phpldapadmin/htdocs>" >> /etc/httpd/conf.d/phpldapadmin.conf
echo "    Order Deny,Allow" >> /etc/httpd/conf.d/phpldapadmin.conf
echo "    Allow from all" >> /etc/httpd/conf.d/phpldapadmin.conf
echo "</Directory>" >> /etc/httpd/conf.d/phpldapadmin.conf


cp /etc/phpldapadmin/config.php /etc/phpldapadmin/config.php_org
sed -i "s/'login','attr','uid'/'login','attr','dn'/" /etc/phpldapadmin/config.php

cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf_org
sed -i '/<Directory \//,/<\/Directory/ s/^/#/' /etc/httpd/conf/httpd.conf
echo "<Directory />" >> /etc/httpd/conf/httpd.conf
echo "    Options Indexes FollowSymLinks" >> /etc/httpd/conf/httpd.conf
echo "    AllowOverride none" >> /etc/httpd/conf/httpd.conf
echo "</Directory>" >> /etc/httpd/conf/httpd.conf

systemctl restart httpd
systemctl enable httpd


