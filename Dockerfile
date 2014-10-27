FROM java:openjdk-7u65-jdk
#To get from ubuntu need a jdk (or at least a jre)
#FROM ubuntu:14.04
#RUN apt-get update && \
#  sudo apt-get install -y openjdk-7-jre && \
#  sudo update-alternatives --config java

# Download URBANCODE_DEPLOY_V6.1.0.1_EN_EVAL.zip from 
# https://www.ibm.com/developerworks/downloads/urbancode/ucd/
# it contais the directory ibm-ucd-install/
COPY ibm-ucd-install/ /ibm-ucd-install/
RUN /bin/echo >> /ibm-ucd-install/install.properties \
 && /bin/echo nonInteractive=true >> /ibm-ucd-install/install.properties \
 && /bin/echo install.java.home=/usr/lib/jvm/java-7-openjdk-amd64/jre >> /ibm-ucd-install/install.properties \
 && /bin/echo install.server.web.always.secure=n >> /ibm-ucd-install/install.properties \
 && /bin/echo install.server.web.host=localhost >> /ibm-ucd-install/install.properties \
 && /bin/echo install.server.web.ip=0.0.0.0 >> /ibm-ucd-install/install.properties \
 && /bin/echo install.server.web.port=8080 >> /ibm-ucd-install/install.properties \
 && /bin/echo java.io.tmpdir=/opt/ibm-ucd/server/var/temp >> /ibm-ucd-install/install.properties \
 && /bin/echo database.derby.port=11377 >> /ibm-ucd-install/install.properties \
 && /bin/echo database.type=derby >> /ibm-ucd-install/install.properties \
 && /bin/echo hibernate.connection.url=jdbc\:derby\://localhost\:11377/data >> /ibm-ucd-install/install.properties \
 && /bin/echo hibernate.connection.username=ibm_ucd >> /ibm-ucd-install/install.properties \
 && /bin/echo hibernate.connection.password=password >> /ibm-ucd-install/install.properties \
 && /ibm-ucd-install/install-server.sh

# run data copy with "save" now.  the entry point should call it without a parameter to relocate to the volume
COPY ucd_data_copy.sh /opt/ibm-ucd/server/ucd_data_copy.sh
# RUN /opt/ibm-ucd/server/ucd_data_copy.sh save
VOLUME /ucddata

# http:8080 https:7918
EXPOSE 8080 7918

# by default run the ucd server command with the run option
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["server", "run"]
