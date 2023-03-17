#!/bin/bash
set -e

MYUID="${MYUID:-1000}"
MYGUID="${MYGUID:-1000}"
#echo ${MYUID}

u=`id -u ubuntu`
if [ $u != $MYUID ] 
then
  echo "Setting up permissions, please wait..."
  usermod -u ${MYUID} ubuntu
  groupmod -g ${MYGUID} ubuntu
  chown -R ubuntu.ubuntu /home/ubuntu
fi
#echo $MYUID
#chown -R ubuntu.ubuntu /home/ubuntu 
#echo $MYUID
#echo ${@}
# if [ ! -f /tmp/rustup.sh ]
# then
#     gosu ubuntu bash -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh"
#     gosu ubuntu bash -c "chmod +x /tmp/rustup.sh"
#     gosu ubuntu bash -c "/tmp/rustup.sh -y"
# fi
#exec gosu ubuntu '/home/ubuntu/.cargo/bin/rustup component add rust-src clippy rust-analysis rustfmt'
#exec gosu ubuntu '/home/ubuntu/.cargo/bin/rustup self update'
exec gosu ubuntu "${@}"
