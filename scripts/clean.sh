#!/usr/bin/env bash
set -ex

conda clean --all --yes || true
docker system prune -a -f
trash-empty
rm -rf ~/.cache
