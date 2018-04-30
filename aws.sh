#!/bin/bash
PIP=/usr/bin/pip
TAR=/usr/bin/tar

## Upgrade pip
${PIP} install --upgrade pip

## Install AWS CLI
${PIP} install awscli


aws --endpoint=https://s3-api.dal-us-geo.objectstorage.softlayer.net s3 cp s3://indmkt-db2-es-tarballs/eventstore_singlenode_trial_x86-64.tar /ibm

OD=`pwd`
cd /ibm
${TAR} -xvf /ibm/eventstore_singlenode_trial_x86-64.tar
cd ${OD}
