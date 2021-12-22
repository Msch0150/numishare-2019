# Using Numishare with Docker

## Example with Docker for Windows

* Install Docker
* Enable Linux for Windows
* Install Ubuntu
* Open terminal
* Copy and Paste content of setup.sh in terminal

## OLD SECTION Create default link for themes

* required to load the javascripts for supporting iiif.
* 
* cd /usr/local/tomcat/webapps/orbeon/WEB-INF/resources/apps/numishare; ln -s /usr/local/projects/numishare/ui default
* Change in admin interface > Modify Settings > Themes and layout http://localhost:8081/orbeon/numishare/

## Post install tasks
* docker exec -ti orbeon bash
* sudo apt-get install telnet
* cp -r /usr/local/tomcat/webapps/orbeon/WEB-INF/resources/apps/numishare /usr/local/projects/<my_instance_name>
* Access admin interface > http://localhost:10200/orbeon/numishare/admin/
* Add new collection:
*  Tomcat Role: <my_instance_name>
*  Collection Name: <my_instance_name>
*  Installation Directory: /usr/local/projects/<my_instance_name>
*  Public Site: http://localhost:10200/orbeon/numishare/<my_instance_name>
*  Solr Published: http://solr:8983/solr/numishare/ (default setting. Leave as it is. Docker inserts host "solr" and port "8983")
*  mkdir /var/lib/tomcat7/webapps/orbeon/WEB-INF/resources/apps/themes
*  cd /var/lib/tomcat7/webapps/orbeon/WEB-INF/resources/apps/themes
*  ln -s /usr/local/projects/mymint_01/ui <my_instance_name>
*  Upload ips files:
*  cd /usr/local/projects/alpen/xforms/xquery/
*  curl -v -u admin: http://exist:8080/exist/rest/<my_instance_name>/ --upload-file ./get-subtypes.xql
*  curl -v -u admin: http://exist:8080/exist/rest/<my_instance_name>/ --upload-file ./aggregate-ids.xql
*  curl -v -u admin: http://exist:8080/exist/rest/<my_instance_name>/ --upload-file ./aggregate-all.xql
*  Change in admin interface > Modify Settings > Themes and layout http://localhost:10200/orbeon/themes
*  Theme Folder: <my_instance_name>
*  Upload 
  


## Testing IIIF

* cd data/docker-loris-data/
* mkdir images/sar/jpg
* copy srm.20081212-010.1.jpg images/sar/jpg/
* http://localhost:10206/sar/jpg/srm.20081212-010.1.jpg/full/175,/0/default.jpg
