#!/bin/sh

set -eu

eval "$(opam env)"
VER=$(git rev-parse HEAD)
export OPSIAN_OPTS="apiKey=$OPS_KEY,applicationVersion=$VER,debugLogPath=/data/£{ARGV_0}-£{PID}-irmin-debug.log,agentId=£{ARGV_0}-irmin"

while true
do
  for file in ./data4_10310commits.repr ./data4_100066commits.repr ./data_1343496commits.repr
  do
    dune exec -- ./bench/irmin-pack/tree.exe --mode trace --no-summary \
      --empty-blobs --path-conversion=v0+v1 "$file" --ncommits-trace 20000000 --artefacts "/irmin/res/nope"
    dune exec -- ./bench/irmin-pack/tree.exe --mode trace --no-summary \
      --keep-stat-trace "$file" --ncommits-trace 20000000 --artefacts "/irmin/res/$file"
  done
done

