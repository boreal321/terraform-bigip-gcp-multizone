#!/bin/bash
fn=${cfe_rpm}
cfe_json=${cfe_json}
gsutil cp gsutil gs://${bucket}/credentials/master .
password=`sed -e 's/","username.*$//' master|sed -e 's/^.*assword":"//'`
creds=admin:$password
len=$(wc -c $fn | cut -f 1 -d ' ')
data="{\"operation\":\"INSTALL\",\"packageFilePath\":\"/var/config/rest/downloads/$fn\"}"
for num in 1 2; do
    if [ $num == 1 ];
        zone="a"
    else
        zone="b"
    fi
    bip=`gcloud compute instances describe bigip$num-bp15 --zone=us-east4-$zone |grep networkIP|grep "10.1.10"|sed -e 's/^.* 1/1/'`
    curl -kvu $creds https://$bip/mgmt/shared/file-transfer/uploads/$fn -H 'Content-Type: application/octet-stream' -H "Content-Range: 0-$((LEN - 1))/$len" -H "Content-Length: $len" -H 'Connection: keep-alive' --data-binary @$fn
    curl -kvu $creds "https://$bip/mgmt/shared/iapp/package-management-tasks" -H "Origin: https://$bip" -H 'Content-Type: application/json;charset=UTF-8' --data $data
    echo
    sleep 30
    curl -ku $creds https://$bip/mgmt/shared/cloud-failover/info
    echo
    sleep 20 
    curl -kvu $creds "https://$bip/mgmt/shared/cloud-failover/declare" -H "Origin: https://$bip" -H 'Content-Type: application/json' --data @$cfe_json
done