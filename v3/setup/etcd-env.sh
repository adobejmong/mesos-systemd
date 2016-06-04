#!/bin/bash -x

source /etc/environment

# Skip setting the etcd keys if we're not on the control tier
if [ "${NODE_ROLE}" != "control" ]; then
  exit 0
fi

ENV_FILE="/etc/environment"
ETCD_PREFIX="/environment"
IGNORED='^NODE|^COREOS|^#|^FLIGHT_DIRECTOR|^CAPCOM'

for line in $(cat $ENV_FILE|egrep -v $IGNORED); do
    key=${line%=*}
    value=${line#*=}

    etcdkey="$ETCD_PREFIX/$key"
    etcdctl set $etcdkey $value
done
