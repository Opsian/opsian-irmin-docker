#!/bin/sh

set -eu

export OPS_KEY=$1

docker run -it \
  --ulimit core=-1 \
  --privileged \
  --cap-add=SYS_PTRACE \
  -v ${PWD}/data/:/data \
  -e OPS_KEY="$OPS_KEY" \
  opsian-irmin-bench

