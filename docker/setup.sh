# Initial setup
mkdir -p ${HOME}/data/docker-loris-data/images
mkdir -p ${HOME}/data/docker-solr-data
sudo chown -R 8983:8983 ${HOME}/data/docker-solr-data
mkdir -p ${HOME}/data/docker-fuseki-data

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
sudo ln -s ui default && \
cd docker

docker-compose up

# Using the current docker-compose.xml you might want to try:
#
# Numishare: http://localhost:10200/orbeon/numishare/admin/
# Solr     : http://localhost:10202/
# Exist DB : http://localhost:10204
# Loris    : http://localhost:10206/
# Fuseki   : http://localhost:10208/  (username:password displayed in console of Docker)
# Apache   : http://localhost

