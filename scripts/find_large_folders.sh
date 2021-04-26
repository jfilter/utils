#!/usr/bin/env bash
set -ex

du --max-depth=7 /* | sort -n
