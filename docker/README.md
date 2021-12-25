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
* apt-get install telnet
* NOT REQUIRED cp -rp /usr/local/tomcat/webapps/orbeon/WEB-INF/resources/apps/numishare /usr/local/projects/<my_instance_name>
* Access admin interface > http://localhost:10200/orbeon/numishare/admin/
* Add new collection:
*  Tomcat Role: <my_instance_name>
*  Collection Name: <my_instance_name>
*  Installation Directory: /usr/local/projects/numishare (leave the default)
*  Public Site: http://localhost:10200/orbeon/numishare/<my_instance_name>
*  Solr Published: http://solr:8983/solr/numishare/ (default setting. Leave as it is. Docker inserts host "solr" and port "8983")
*  mkdir /usr/local/tomcat/webapps/orbeon/WEB-INF/resources/apps/themes
*  cd /usr/local/tomcat/webapps/orbeon/WEB-INF/resources/apps/themes
*  ln -s /usr/local/projects/<my_instance_name>/ui <my_instance_name>
*  If setup as coint-type:
*  Change in admin interface, Modify Settings, General settings > Collection Type > Type series: http://nomisma.org/id/pella_type_series (doesn't really matter in this step, but there needs to be entered something. It will have an influence on the listed contributors. So all institutions contributing to pella (ANS, {BnF, NNC, ...). > Save
*  Change in admin interface > Modify Settings > Themes and layout http://localhost:10200/orbeon/themes
*  Theme Folder: <my_instance_name>

## Testing IIIF

* cd data/docker-loris-data/
* mkdir -p images/<my_collection_name>/jpg
* copy <my_collection_name>.<my_image_id>.jpg images/<my_collection_name>/jpg/
* http://localhost:10206/<my_collection_name>/jpg/my_collection_name>.<my_image_id>.jpg/full/175,/0/default.jpg

* Example:  http://localhost:10206/srm/jpg/srm.20081212-010.1.jpg/full/175,/0/default.jpg

## Post Installation Tasks Fuseki (required for cointype)

* Login to fuseki http://localhost:10208/ (username/password is displayed in startup console) and create a dataset "nomisma".

## Post Installation Tasks for multiple instances 

* docker exec -ti orbeon bash
* mkdir /usr/local/tomcat/webapps/orbeon/WEB-INF/resources/numishare-projects
* cd /usr/local/tomcat/webapps/orbeon/WEB-INF/resources/numishare-projects
* ln -s /usr/local/projects/<my_collection_name> <my_collection_name>
* vi /usr/local/projects/numishare/page-flow.xml
* Add to section "PUBLIC INTERFACE":
* \<!-- <my_instance_name> --\>
* \<page path="/numishare/<my_instance_name>/" model="xpl/models/config.xpl" view="oxf:/numishare-projects/<my_instance_name>/xpl/views/pages/index.xpl"/\>
* Because it is linked, it will use /usr/local/projects/alpen/xpl/views/pages/index.xpl (no changes required here). But this will forced to use:
* /usr/local/projects/<my_collection_name>/ui/xslt/pages/index.xsl
* Change the above for your needs, example: add a banner image in the body section, below the header:
* Example:  \<img src="http://numismatics.org/themes/ocre/images/banner.jpg" style="width:100%" /\>
* Or on the server: cp <mysource>/banner.jpg /usr/local/projects/alpen/ui/images/ and add to the above mentioned index.xsl:
* Example:  \<img src="/themes/alpen/images/banner.jpg" style="width:100%" /\>
* See: https://github.com/ewg118/numishare/issues/105
* See: https://github.com/ewg118/numishare/wiki/Numishare-Themes#altering-numishare-public-ui-pages-on-a-per-project-basis (maybe outdated)

## Logo
  * Example:
  * cp /mnt/c/Users/jhunke/Documents/joschel/forschung/numishare/alpen/logo_ulpia_03.png ~/data/docker-numishare-data/alpen/ui/images/logo.png
  * Admin UI > <instance> > Modifiy Settings > Tiles and URLs > Logo URL > "logo.png"

 ## Fuseki
   * Login to fuseki (http://localhost:10208)
   * Create a dataset (example ulpia)
   * export "numishare" dump and void from collection (example public page, api down)
   * Import both dumps into fuseki dataset.
   * Numishare Admin, SPARQL Endpoint: http://fuseki:3030/ulpia/ (this is the docker internal link, the external one http://localhost:10208/uplia does not work.
 
