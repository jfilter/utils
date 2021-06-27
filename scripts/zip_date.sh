#!/usr/bin/env bash
set -ex

# Usage:
# ./zip_date.sh file1.txt file2.txt ...

zip -r "archive-$(date +"%Y-%m-%d").zip" "$@"
