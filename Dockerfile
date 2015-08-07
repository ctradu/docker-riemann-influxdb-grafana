FROM	ubuntu:14.04

MAINTAINER	Tiberiu Radu

ENV GRAFANA_VERSION	2.1.0
ENV INFLUXDB_VERSION	0.9.2
ENV RIEMANN_VERSION	0.2.10

RUN	apt-get -y update && apt-get -y upgrade


# Install prerequisites
RUN     apt-get -y install wget nginx supervisor curl openjdk-7-jdk vim adduser libfontconfig


# Install Riemann
RUN	wget https://aphyr.com/riemann/riemann_${RIEMANN_VERSION}_all.deb && \
	dpkg -i riemann_${RIEMANN_VERSION}_all.deb


# Install Grafana
RUN	wget https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb && \
	dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb 


# Install InfluxDB
RUN 	wget https://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
	dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb


# -------------------
# Configs
# -------------------

# ADD		./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Start all script
ADD     ./start_all.sh  /etc/init.d/start_all
ADD     ./grafana/grafana.ini   /etc/grafana/grafana.ini
RUN     chmod 755 /etc/init.d/start_all
# Configure InfluxDB
#

# -------------------
#   Open up ports
# -------------------

# Grafana - change the port in the future...
EXPOSE 80

# Influxdb ports
EXPOSE 8083
EXPOSE 8086
EXPOSE 8088


CMD     ["/etc/init.d/start_all"]
