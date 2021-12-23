FROM tomcat:8

ENV OrbeonTag="2020.1.2" OrbeonRelease="ce" OrbeonDateString="202103050030"
ENV OrbeoanDownloadLink="https://github.com/orbeon/orbeon-forms/releases/download"
ENV CATALINA_HOME=/usr/local/tomcat
ENV TEMP_DIR=/var/tmp
ENV ProjectsDir=/usr/local/projects

### Download Orbeon

RUN cd ${TEMP_DIR} && \
    wget ${OrbeoanDownloadLink}/tag-release-${OrbeonTag}-${OrbeonRelease}/orbeon-${OrbeonTag}.${OrbeonDateString}-$(echo ${OrbeonRelease} | tr /a-z/ /A-Z/).zip && \
    unzip orbeon-${OrbeonTag}.${OrbeonDateString}-$(echo ${OrbeonRelease} | tr /a-z/ /A-Z/).zip orbeon-${OrbeonTag}.${OrbeonDateString}-$(echo ${OrbeonRelease} | tr /a-z/ /A-Z/)/orbeon.war

### Expand orbeon.war, remove properties-local.xml.template, add properties-local.xml.
### Example: orbeon-2017.2.201712300816-CE/WEB-INF/resources/config/properties-local.xml.
### Info: adding an attribute like 'as="xs:anyURI' does not work with python because "as" is a keyword. Search of a workaround later.
### Meanwhile add a prepared file manually:
### Expand orbeon war file
### Additional: Adjust orbeon.log location

RUN cd ${TEMP_DIR}/orbeon-${OrbeonTag}.${OrbeonDateString}-$(echo ${OrbeonRelease} | tr /a-z/ /A-Z/)/ && \
    unzip orbeon.war && \
    rm WEB-INF/resources/config/properties-local.xml.template && \
    sed -i s%../logs/orbeon.log%logs/orbeon.log%g ./WEB-INF/resources/config/log4j.xml && \
    rm orbeon.war && \
    cd .. && \
    mv orbeon-${OrbeonTag}.${OrbeonDateString}-$(echo ${OrbeonRelease} | tr /a-z/ /A-Z/) ${CATALINA_HOME}/webapps/orbeon && \
    mkdir ${ProjectsDir}

### Install vim/vi

RUN apt-get update && \
    apt-get install vim -y \
    apt-get install telnet -y
