# Initial setup
mkdir -p ${HOME}/data/docker-loris-data/images
mkdir -p ${HOME}/data/docker-solr-data

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
cd numishare-master/docker

docker-compose up
