#!/bin/bash -eu

file=$(mktemp)
cp $(dirname $0)/pipeline.yml $file
for version in "$@"
do
  out=$(mktemp)
  bosh int $file -o <(git show $version:$(dirname $0)/add_release_ops.yml) \
    -v release_branch=${version} > $out
  file=$out
done
cat $file
