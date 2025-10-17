#!/bin/bash
# build.sh
# Conversion of build.cmd to a shell script.

docker build -t gilhari_relationships_inline_attribs_example:1.0 .
docker images