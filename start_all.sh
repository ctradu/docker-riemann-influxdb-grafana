#!/bin/bash

# Start influxdb
/etc/init.d/influxdb start

# Start Riemann
/etc/init.d/riemann start

# Start Grafana
