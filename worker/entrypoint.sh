#!/bin/bash
set -e

MYUID="${MYUID:-1000}"
MYGUID="${MYGUID:-1000}"

u=`id -u ubuntu`
if [ $u != $MYUID ] 
then
  echo "Setting up permissions, please wait..."
  usermod -u ${MYUID} ubuntu
  groupmod -g ${MYGUID} ubuntu
  chown -R ubuntu.ubuntu /home/ubuntu
fi

exec gosu ubuntu "${@}"
