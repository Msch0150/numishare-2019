# Using Numishare with Docker

## Example with Docker for Windows

* Install Docker
* Enable Linux for Windows
* Install Ubuntu
* Open terminal
* Copy and Paste content of setup.sh in terminal

## Create default link for themes

* required to load the javascripts for supporting iiif.
* 
* cd /usr/local/tomcat/webapps/orbeon/WEB-INF/resources/apps/numishare; ln -s /usr/local/projects/numishare/ui default
* Change in admin interface > Modify Settings > Themes and layout http://localhost:8081/orbeon/numishare/

## Testing IIIF

* cd data/docker-loris-data/
* mkdir images/sar/jpg
* copy srm.20081212-010.1.jpg images/sar/jpg/
* http://localhost:10206/sar/jpg/srm.20081212-010.1.jpg/full/175,/0/default.jpg
