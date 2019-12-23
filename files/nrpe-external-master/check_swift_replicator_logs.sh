#!/bin/bash

pattern=${1:-replicated}
interval=${2:-15}
warn_min=${3:-2}
crit_min=${4:-1}

exec sudo -u root /usr/local/lib/nagios/plugins/check_timed_logs.pl -pattern $pattern -logfile /var/log/syslog -interval $interval -w $warn_min -c $crit_min -reverse 2>&1
