#!/usr/bin/env bash

set -eu

fly -t production set-pipeline \
  -p bosh:stemcells:3363.x -c ci/pipeline.yml \
  -l <(lpass show --notes "concourse:production pipeline:bosh:stemcells:3363.x") \
  -l <(lpass show --notes "concourse:production pipeline:os-images") \
  -l <(lpass show --notes "bats-concourse-pool:vsphere secrets")
