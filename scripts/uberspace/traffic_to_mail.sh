#!/usr/bin/env bash
set -e
set -x

datestr=$(date +%Y_%m_%d)
goaccess --ignore-crawlers --agent-list --config-file ~/etc/goaccess.conf --log-file ~/logs/webserver/access_log* -o report_$datestr.html
echo "Traffic for $(date)" | mutt -s "Uberspace Traffic $(date)" hi@jfilter.de -a report_$datestr.html
mv report_$datestr.html reports/
