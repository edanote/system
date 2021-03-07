#!/bin/bash

resultdir="script"
#declare -A ldaphosts
ldaphosts=(server1.virtualhost.com "192.168.10.31"  server2.virtualhost.com "192.168.10.32"  server3.virtualhost.com "192.168.10.33" server4.virtualhost.com "192.168.10.34" server5.virtualhost.com "192.168.10.35")
configRootPW=1234
dc="dc=virtualhost,dc=com"
RootDN=ldapadmin
RootDNPW=1234567

rm -rf $resultdir
mkdir $resultdir

# create hosts
declare -i i=0
declare -i limit=${#ldaphosts[*]}/2
while [ $i -lt $limit ]
do
    host=${ldaphosts[*]:$i*2:1}
    ip=${ldaphosts[*]:$i*2+1:1}
    let i=$i+1
    echo "$ip    $host" >> $resultdir/hosts
done

# create syncprov_mod.ldif
cp template/syncprov_mod.ldif script/syncprov_mod.ldif

# create olcserverid_xx.ldif and run.sh
declare -i i=0
declare -i limit=${#ldaphosts[*]}/2
while [ $i -lt $limit ]
do
    host=${ldaphosts[*]:$i*2:1}
    ip=${ldaphosts[*]:$i*2+1:1}
#    echo $host $ip
    let i=$i+1
    # generate run script server_xxx.sh
    cp template/server.sh  $resultdir/run_on_${host}.sh
    sed -i "s/SERVERNAME/$host/" $resultdir/run_on_${host}.sh

    # generate olcserverid_xxx.ldif 
    sed "s/SERVERID/${i}/" template/olcserverid.ldif >  $resultdir/olcserverid_${host}.ldif
done

# create olcdatabase.ldif
configRootPW_SSHA=`slappasswd -s $configRootPW`
sed "s#SSHA#${configRootPW_SSHA}#" template/olcdatabase.ldif >  $resultdir/olcdatabase.ldif

# create configrep.ldif
cp template/configrep.ldif $resultdir/configrep.ldif
declare -i i=0
declare -i limit=${#ldaphosts[*]}/2
while [ $i -lt $limit ]
do
    host=${ldaphosts[*]:$i*2:1}
    ip=${ldaphosts[*]:$i*2+1:1}
    let i=$i+1
    sed -e "s/SERVERID/$i/" -e "s/SERVERNAME/$host/" template/configrep_olcServerID >> $resultdir/configrep_olcServerID
    i_zerofill=`printf "%03d\n" $i`
    sed -e "s/SERVERID_zero/$i_zerofill/" -e "s/SERVERNAME/$host/" -e "s/configRootPW/${configRootPW}/" template/configrep_olcSyncRepl >> $resultdir/configrep_olcSyncRepl
done
sed -i "/configrep_olcServerID/r $resultdir/configrep_olcServerID" $resultdir/configrep.ldif
sed -i "/configrep_olcSyncRepl/r $resultdir/configrep_olcSyncRepl" $resultdir/configrep.ldif
sed -i "/configrep_olcServerID/d" $resultdir/configrep.ldif
sed -i "/configrep_olcSyncRepl/d" $resultdir/configrep.ldif


# begin x.sh script
cp template/x.sh $resultdir/run_on_phpadmin.sh

# create syncprov.ldif
cp template/syncprov.ldif $resultdir/syncprov.ldif

# create olcdatabasehdb.ldif
cp template/olcdatabasehdb.ldif $resultdir/olcdatabasehdb.ldif
declare -i i=0
declare -i limit=${#ldaphosts[*]}/2
while [ $i -lt $limit ]
do
    host=${ldaphosts[*]:$i*2:1}
    ip=${ldaphosts[*]:$i*2+1:1}
    let i=$i+1
    let j=$i+$limit
    i_zerofill=`printf "%03d\n" $j`
    sed -e "s/SERVERID_zero/$i_zerofill/" -e "s/SERVERNAME/$host/" -e "s/RootDNPW/${RootDNPW}/" template/olcdatabasehdb_olcSyncRepl >> $resultdir/olcdatabasehdb_olcSyncRepl
done
RootDNPW_SSHA=`slappasswd -s $RootDNPW`
sed "s#RootDNPW_SSHA#${RootDNPW_SSHA}#" template/olcdatabasehdb.ldif >  $resultdir/olcdatabasehdb.ldif
sed -i "/olcdatabasehdb_olcSyncRepl/r $resultdir/olcdatabasehdb_olcSyncRepl" $resultdir/olcdatabasehdb.ldif
sed -i "/olcdatabasehdb_olcSyncRepl/d" $resultdir/olcdatabasehdb.ldif
sed -i "s/DC/${dc}/g" $resultdir/olcdatabasehdb.ldif
sed -i "s/cn=RootDN/cn=${RootDN}/g" $resultdir/olcdatabasehdb.ldif


# create monitor.ldif
cp template/monitor.ldif $resultdir/monitor.ldif
sed "s/DC/${dc}/" template/monitor.ldif >  $resultdir/monitor.ldif

# copy self service password
cp -a template/self_service_password $resultdir/self_service_password

#echo $configRootPW
#echo $dc
#echo $RootDN
#echo $RootDNPW
echo ""
echo "admin dn is : cn=$RootDN,$dc"
echo "admin password is : $RootDNPW"
echo ""


sample_template="template/sample/"
samples=`ls $sample_template`
for dir in $samples
do
    for sample_file in `ls $sample_template/$dir`
    do
        echo $sample_file
        export src=${sample_template}/${dir}/${sample_file}
        export dst_dir=${resultdir}/sample/${dir}
        export dst=${resultdir}/sample/${dir}/${sample_file}
        mkdir -p  $dst_dir
        sed -e "s/RootDN/$RootDN/g" -e "s/DC/$dc/g" $src > $dst
    done
done
