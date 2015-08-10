FROM	ubuntu:14.04

MAINTAINER	Tiberiu Radu

ENV GRAFANA_VERSION	    2.1.0
ENV INFLUXDB_VERSION	0.9.2.1
ENV RIEMANN_VERSION	    0.2.10
ENV TELEGRAF_VERSION    0.1.4

RUN	apt-get -y update && apt-get -y upgrade


# Install prerequisites
RUN     apt-get -y install wget nginx supervisor curl openjdk-7-jdk vim adduser libfontconfig
RUN     apt-get -y install mlocate


# Users for Riemann and Grafana and Influxdb with custom UID and GID to match those in the data-volume container
RUN groupadd -r -g 1200 influxdb && useradd -r -g influxdb -u 1200 influxdb
RUN groupadd -r -g 1300 riemann && useradd -r -g riemann -u 1300 -d /usr/share/riemann -s /bin/false riemann
RUN groupadd -r -g 1400 grafana && useradd -r -g grafana -u 1400 -d /usr/share/grafana -s /bin/false grafana

# Install Riemann
RUN	wget https://aphyr.com/riemann/riemann_${RIEMANN_VERSION}_all.deb && \
	dpkg -i riemann_${RIEMANN_VERSION}_all.deb


# Install Grafana
RUN	wget https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb && \
	dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb 


# Install InfluxDB
RUN 	wget https://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
	dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb

# Install InfluxDB telegraf (agent for collecting data)
# To remove once all other are installed and work properly.
RUN     wget http://get.influxdb.org/telegraf/telegraf_${TELEGRAF_VERSION}_amd64.deb && \
    dpkg -i telegraf_${TELEGRAF_VERSION}_amd64.deb


# Remove *.deb files
RUN     rm *.deb


# -------------------
#   Data Volume
# -------------------
# All data we want to be persistent will be found in this dir
# This dir should be mounted in the host machine in a dir with a similar name and/or location
# In future these should be split in two (configs and data)
VOLUME  /mnt/apcmetrics/

# -------------------
# Configs
# -------------------


# Initial directories and permissions 
# InfluxDB related

ADD     ./scripts/init_influxdb.sh     /etc/avira/init_influxdb.sh
RUN     chmod 754 /etc/avira/init_influxdb.sh

# InfluxDB config
ADD     ./influxdb/influxdb.conf    /etc/opt/influxdb/influxdb.conf

# Grafana
ADD     ./grafana/grafana.ini   /etc/grafana/grafana.ini

# Riemann
# ADD ...

# Supervisord
# ADD		./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start all script
ADD     ./scripts/start_all.sh  /etc/init.d/start_all
RUN     chmod 755 /etc/init.d/start_all

# Configure InfluxDB telegraf
ADD     ./influxdb/influxdb-telegraf.conf   /etc/opt/telegraf/telegraf.conf


# Start all
#RUN     /etc/init.d/start_all


# -------------------
#   Open up ports
# -------------------

# Grafana - change the port in the future...
EXPOSE 3000 

# Influxdb ports
EXPOSE 8083
EXPOSE 8086
EXPOSE 8088

# Graphite plugin of InfluxDB
EXPOSE 2003

# Riemann


CMD     ["/etc/init.d/start_all"]
