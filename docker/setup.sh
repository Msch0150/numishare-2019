#!/bin/bash

# Variables
# At least numishare is required in the list below
MAIN="numishare"
COLLECTIONS="alpen srm koeln rct"
DATA_DIR=${HOME}/data


# preparations
sudo apt install unzip

# Initial setup
mkdir -p "${DATA_DIR}/docker-loris-data/images"
mkdir -p "${DATA_DIR}/docker-solr-data"
sudo chown -R 8983:8983 "${DATA_DIR}/docker-solr-data"
mkdir -p "${DATA_DIR}/docker-fuseki-data"

# Cleanup
cd ${HOME} && \
sudo docker stop $(sudo docker ps -a -q) && \
sudo docker rm $(sudo docker ps -a -q) && \
sudo rm -rf numishare

# setup
export TARGET_DIR=${HOME}/numishare && \
mkdir -p ${TARGET_DIR} && cd ${TARGET_DIR} && \
wget https://github.com/Msch0150/numishare/archive/master.zip && \
unzip master.zip && sudo chown -R 8983:8983 numishare-master/solr-home/ && \
sudo chown 8983:8983 numishare-master/docker/core.properties && \
cd numishare-master && \
sudo ln -s ui default

if [ ! -d "${DATA_DIR}/docker-numishare-data/${MAIN}" ]; then
  mkdir -p "${DATA_DIR}/docker-numishare-data/${MAIN}"
  cp -rp $(pwd)/* "${DATA_DIR}/docker-numishare-data/${MAIN}/"
  cp docker/exist-config.xml "${DATA_DIR}/docker-numishare-data/${MAIN}/"
fi

for COLLECTION in ${COLLECTIONS}; do
  if [ ! -d "${DATA_DIR}/docker-numishare-data/${COLLECTION}" ]; then
    mkdir -p "${DATA_DIR}/docker-numishare-data/${COLLECTION}"
    # to avoid data access via admin
    echo 'ProxyPass /'${COLLECTION}'/ http://orbeon:8080/orbeon/numishare/'${COLLECTION}'/' >> "${DATA_DIR}/docker-numishare-data/${MAIN}/docker/httpd.conf"
    echo 'ProxyPassReverse /'${COLLECTION}'/ http://orbeon:8080/orbeon/numishare/'${COLLECTION}'/' >> "${DATA_DIR}/docker-numishare-data/${MAIN}/docker/httpd.conf"
  fi
done

cd "${DATA_DIR}/docker-numishare-data/numishare/docker"

echo "Use $(pwd) for docker startup and shutdown"

# docker compose up

# Using the current docker-compose.xml you might want to try:
#
# Numishare: http://localhost:10200/orbeon/numishare/admin/
# Solr     : http://localhost:10202/
# Exist DB : http://localhost:10204
# Loris    : http://localhost:10206/
# Fuseki   : http://localhost:10208/  (username:password displayed in console of Docker or in /fuseki/shiro.ini in section [users])
# Apache   : http://localhost

