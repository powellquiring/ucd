#!/bin/bash
# usage: /opt/ibm-ucd/server/ucd_data_relocate.sh [save]
#
# run the command with the save option from the Dockerfile
# COPY ucd_data_relocate.sh /opt/ibm-ucd/server/ucd_data_relocate.sh
# RUN /opt/ibm-ucd/server/ucd_data_relocate.sh save
# VOLUME /ucddata
#
# run the command in the initial entrypoint.sh (ENTRYPOINT or CMD) script in the image
#
# The image should be started with -v HOSTDIR:/ucddata  See the VOLUME in the Dockerfile

SERVER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SERVER

# see http://www-01.ibm.com/support/knowledgecenter/SS4GSP_6.1.0/com.ibm.udeploy.install.doc/topics/server_install_silent.html
relocatables="\
    var/email \
    var/plugins \
    var/sa \
    logs \
    conf/encryption.keystore \
    conf/server.keystore \
    conf/collectors \
    patches \
    conf/server/log4j.properties \
    "

DESTINATION=/ucddata
SAVED=/opt/ibm-ucd/server/saved

# save the contents away to avoid deleting later
if [ "$1" == "save" ]; then
    mkdir $SAVED
    for relocatable in $relocatables; do
        if [ -e $relocatable ]; then
            mkdir -p $SAVED/$relocatable # make sure parent exists
            rmdir $SAVED/$relocatable    # move will create the dir
            mv $relocatable $SAVED/$relocatable
        fi
        ln -s $DESTINATION/$relocatable $relocatable
    done
    exit 0
fi

for relocatable in $relocatables; do
    if [ ! -e $DESTINATION/$relocatable ]; then # already exists do not change it
        # assume it is a directory that must be created
        mkdir -p $DESTINATION/$relocatable  # make sure parent exists
        if [ -e $SAVED/$relocatable ]; then
            # but if the source exists, even if it is a file, delete and copy will create it
            rmdir $DESTINATION/$relocatable     # the copy will create the dir
            cp -r $SAVED/$relocatable $DESTINATION/$relocatable
        fi
    fi
done
