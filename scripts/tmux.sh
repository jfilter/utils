#!/usr/bin/env bash
set -ex

tmux new-session \; split-window -v \; split-window -h \; select-pane -t 0 \; split-window -h \;
