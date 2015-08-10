#!/bin/bash

# InfluxDB
# Get current InfluxDB databases
APCMETRICS=`/opt/influxdb/influx -execute "show databases" |grep "apcmetrics" | wc -l`

if [ $APCMETRICS = 1 ]; then
    echo "The db 'apcmetrics' is already created";

else
    /opt/influxdb/influx -execute "create database apcmetrics"
    /opt/influxdb/influx -execute "create user apcloud with password 'qwe123'"
fi    
