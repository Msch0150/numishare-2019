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
    
