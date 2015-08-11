#!/bin/bash
if [ $# -lt 1 ]
then
    echo "Usage : $0 run | run-cli | build"
    exit
fi

HOST_DIR=~/data/apcmetrics

#-v $HOST_DIR:/mnt/apcmetrics/influxdb \
case $1 in
    "run-cli") 
        docker run -t -p 3000:3000 \
                     -p 8083:8083 \
                     -p 8086:8086 \
                     -p 8088:8088 \
                     -p 2003:2003 \
                     --volumes-from apcmetrics \
                     -i ctradu/riemann-influxdb-grafana /bin/bash ;;
    "run")
        docker run -t -d -p 3000:3000 \
                     -p 8083:8083 \
                     -p 8086:8086 \
                     -p 8088:8088 \
                     -p 2003:2003 \
                     --volumes-from apcmetrics \
                     --name rig \
                     -i ctradu/riemann-influxdb-grafana;;
            
    "build")
        docker build -t ctradu/riemann-influxdb-grafana . ;;

    *)
        echo "Unknown option";
        echo "Accepted options: run | build";
        exit
esac
