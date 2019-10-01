#!/bin/bash

# Description: To Set System Initialization.

SetSSH(){
  if [ ! -d /root/.ssh ]; then
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
  fi

  # Fetch public key using HTTP
  if [ ! -f /root/.ssh/authorized_keys ]; then
    curl -f http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key \
      > /tmp/metadata-key 2>/dev/null
  fi
  if [ $? -eq 0 ]; then
    cat /tmp/metadata-key >> /root/.ssh/authorized_keys
    chmod 0600 /root/.ssh/authorized_keys
    restorecon /root/.ssh/authorized_keys
    rm -f /tmp/metadata-key
    echo "Successfully retrieved public key from instance metadata"
    echo "*****************"
    echo "AUTHORIZED KEYS"
    echo "*****************"
    cat /root/.ssh/authorized_keys
    echo "*****************"
  fi
}

SetHostname(){
  HostName=`curl http://169.254.169.254/latest/meta-data/hostname`
  echo ${HostName} > /etc/hostname
  hostname ${HostName}
}

MAIN(){
  SetSSH
  SetHostname
}

MAIN