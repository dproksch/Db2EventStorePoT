#!/bin/bash
if [ $# -ne 1 ]
then
        echo "Usage:  bmx.sh APIKEY"
        exit -1
fi
APIKEY=$1

RM=/usr/bin/rm
MV=/usr/bin/mv
WGET=/usr/bin/wget
TAR=/usr/bin/tar
BMX=/usr/local/bin/bluemix
CLEANUP="${RM} -rf ./linux64.tar.gz ./Bluemix_CLI > /dev/null 2>&1"

## Download the IBM Cloud CLI Installer
${WGET} https://clis.ng.bluemix.net/download/bluemix-cli/latest/linux64

## unpack the installer
${MV} linux64 linux64.tar.gz
${TAR} -zxvf linux64.tar.gz

## Run the Installer
OD=`pwd`
cd ./Bluemix_CLI
./install_bluemix_cli
cd ${OD}

${CLEANUP}


${BMX} login --apikey ${APIKEY} -a https://api.ng.bluemix.net
${BMX} target -o "proksch@us.ibm.com"
${BMX} account space "POT" > /dev/null 2>&1
RC=$?
if [ ${RC} -ne 0 ]
then
        ${BMX} account space-create "POT"
fi
${BMX} target -s "POT"

TMPFILE=/tmp/.aws.$$

bluemix resource service-key POT-CREDS-00 2>&1 | egrep "access_key_id|secret_access_key" > ${TMPFILE} 2>&1

#cat ${TMPFILE}
AK=`cat ${TMPFILE} | grep access_key_id | awk -F\: '{print $2}'`
SAK=`cat ${TMPFILE} | grep secret_access_key | awk -F\: '{print $2}'`

## create AWS config file
mkdir ~/.aws 2> /dev/null > /dev/null
echo "[default]" > ~/.aws/credentials
echo "aws_access_key_id = ${AK}"  >> ~/.aws/credentials
echo "aws_secret_access_key = ${SAK}"  >> ~/.aws/credentials

${RM} -f ${TMPFILE} > /dev/null 2>&1
