#!/bin/bash
set -x
gsutil cp gs://${bucket}/credentials/master .
password=`sed -e 's/","username.*$//' master|sed -e 's/^.*assword":"//'`
creds=admin:$password
fn="${cfe_rpm}"
fn_no_rpm=`echo $fn|sed -e 's/\.rpm$//'`
#
# install
#
install () {
    cfe_json=${cfe_json}
    len=$(wc -c $fn | cut -f 1 -d ' ')
    data="{\"operation\":\"INSTALL\",\"packageFilePath\":\"/var/config/rest/downloads/$fn\"}"
    for num in 1 2; do
        if [ $num == 1 ]; then
            zone="a"
        else
            zone="b"
        fi
        bip=`gcloud compute instances describe bigip$num-bp15 --zone=us-east4-$zone |grep networkIP|grep "10.1.10"|sed -e 's/^.* 1/1/'`
        echo "big-ip: $bip"
        curl -vku $creds https://$bip/mgmt/shared/file-transfer/uploads/$fn -H 'Content-Type: application/octet-stream' -H "Content-Range: 0-$((len - 1))/$len" -H "Content-Length: $len" -H 'Connection: keep-alive' --data-binary @$fn
        echo
        curl -vku $creds "https://$bip/mgmt/shared/iapp/package-management-tasks" -H "Origin: https://$bip" -H 'Content-Type: application/json;charset=UTF-8' --data $data
        echo
    done
    sleep 60
    for num in 1 2; do
        if [ $num == 1 ]; then
            zone="a"
        else
            zone="b"
        fi
        bip=`gcloud compute instances describe bigip$num-bp15 --zone=us-east4-$zone |grep networkIP|grep "10.1.10"|sed -e 's/^.* 1/1/'`
        curl -ksu $creds https://$bip/mgmt/shared/cloud-failover/info|grep :404, && sleep 30
        curl -ksu $creds https://$bip/mgmt/shared/cloud-failover/info|grep :404, && sleep 30
        curl -vku $creds "https://$bip/mgmt/shared/cloud-failover/declare" -H "Origin: https://$bip" -H 'Content-Type: application/json' --data @$cfe_json
    done
}
#
# uninstall
#
uninstall () {
    data="{\"operation\":\"UNINSTALL\",\"packageName\":\"$fn_no_rpm\"}"
    for num in 1 2; do
        if [ $num == 1 ]; then
            zone="a"
        else
            zone="b"
        fi
        bip=`gcloud compute instances describe bigip$num-bp15 --zone=us-east4-$zone |grep networkIP|grep "10.1.10"|sed -e 's/^.* 1/1/'`
        curl -vku $creds "https://$bip/mgmt/shared/iapp/package-management-tasks" -H "Origin: https://$bip" -H 'Content-Type: application/json;charset=UTF-8' --data $data
    done
}
#
# reset state
#
resetstate () {
    data="{\"resetStateFile\":\"true\"}"
    for num in 1 2; do
        if [ $num == 1 ]; then
            zone="a"
        else
            zone="b"
        fi
        bip=`gcloud compute instances describe bigip$num-bp15 --zone=us-east4-$zone |grep networkIP|grep "10.1.10"|sed -e 's/^.* 1/1/'`
        curl -vku $creds "https://$bip/mgmt/shared/cloud-failover/reset" -H "Origin: https://$bip" -H 'Content-Type: application/json' --data $data
    done
}
#
# main
#
if [ -z $1 ]; then
    echo "specify install, uninstall or resetstate as an argument"
    exit 1
fi
if [ $1 == "uninstall" ]; then
    uninstall;
    exit
fi
if [ $1 == "resetstate" ]; then
    resetstate;
    exit
fi
if [ $1 == "install" ]; then
    install;
    exit
fi
echo "specify install, uninstall or resetstate as an argument"
exit 1