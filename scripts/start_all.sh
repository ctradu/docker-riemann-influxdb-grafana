#!/bin/bash

# Start influxdb
/etc/init.d/influxdb start

/etc/avira/init_influxdb.sh

# Start Riemann
/etc/init.d/riemann start

# Start Grafana
/etc/init.d/grafana-server start


# run a bash...
/bin/bash
