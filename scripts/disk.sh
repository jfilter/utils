#!/usr/bin/env bash
set -ex

df -h / && for f in /mnt/*; do df -h $f; done
