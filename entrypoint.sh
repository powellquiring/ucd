#!/bin/bash
# See Dockerfile
# ENTRYPOINT thisFile
# RUN server run
set -e

if [ "$1" = 'server' ]; then
    # chown -R ucd . # who is the ucd user?
    /opt/ibm-ucd/server/ucd_data_copy.sh

    shift
    # exec gosu ucd /opt/ibm-ucd/server/bin/server "$@"
    exec /opt/ibm-ucd/server/bin/server "$@"
fi

exec "$@"
