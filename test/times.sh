#!/bin/bash

for f in *.time; do echo "$(basename "$f" .time) $(grep real "$f" | sed -e 's/^real *//')"; done | column -t
