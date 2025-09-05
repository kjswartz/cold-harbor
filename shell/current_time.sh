#!/bin/bash
set -euo pipefail

echo "EST:  $(date '+%H:%M')"
echo "CST:  $(date -v -1H '+%H:%M')"
echo "MST:  $(date -v -2H '+%H:%M')"
echo "PST:  $(date -v -3H '+%H:%M')"
echo "Date: $(date '+%A %m-%d-%Y')"
