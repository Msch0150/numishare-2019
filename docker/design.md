# File system structure

    data/
      docker-exist-data
      docker-fuseki-data
      docker-loris-data
      docker-numishare-data
        page-flow.xml
        <my_collection_1>
        ui
          css
            style.css
          images
            project
              banner.jpg
              my_logo.png
          xslt
          pages
            index.xsl
        <my_collection_2>
          {same structure as above}
      docker-solr-data
      numishare-master
        numishare
          docker
            docker-compose
        ...

# Installation (multiple instances)

Download `numishare/docker/setup.sh`and change the values inside `COLLECTIONS` for your needs.  
Run `setup.sh`.  
Startup directory is `numishare/numishare/docker/`. You should be already in this directory, otherwise go there. Then satart docker:
    
    docker compose up
    
If you want to adjust the banner image you can copy `page-flow.xml` to a directory outside of the code:

    cp numishare/numishare/page-flow.xml data/docker-numishare-data/page-flow.xml
    
Make your modifications and add append to the `volumes:` of `orbeon:` section in the file `numishare/numishare/docker/docker-compose.yml`:

     - "../../../data/docker-numishare-data/page-flow.xml:/usr/local/tomcat/webapps/orbeon/WEB-INF/resources/apps/numishare/page-flow.xml"
     
Info: The next installation will detect he outside laying file and append the location automatically.


# IIIF Setup

    cd data/docker-loris-data/
    mkdir -p images/media/<my_collection_name>/jpg
    copy <my_collection_name>.<my_image_id>.jpg images/media/<my_collection_name>/jpg/

Test internally via `http://localhost:10206/media/<my_collection_name>/jpg/my_collection_name>.<my_image_id>.jpg/full/175,/0/default.jpg`
Example:

    http://localhost:10206/media/srm/jpg/srm.20081212-010.1.jpg/full/175,/0/default.jpg

Test externally via `http://external_url/media/<my_collection_name>/jpg/my_collection_name>.<my_image_id>.jpg/full/175,/0/default.jpg`

# Customization for instances

To remove the standard information about Numishare on the title page edit the `config.xml` in the Exist-DB and remove the paragraph in the pages section. 
