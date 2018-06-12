#!/usr/bin/env bash

set -eu

dir=$(dirname $0)

fly -t production set-pipeline \
  -p "bosh:stemcells:ubuntu-xenial" \
  -c <(
    bosh interpolate \
      -o <( bosh int -v group=master -v branch=master            -v initial_version=0.0.0  -v bump_version=major $dir/pipeline-branch-ops.yml ) \
      -o <( bosh int -v group=1.x    -v branch=ubuntu-xenial/1.x -v initial_version=1.98.0 -v bump_version=minor <( git show ubuntu-xenial/1.x:ci/ubuntu-xenial/pipeline-branch-ops.yml ) ) \
      $dir/pipeline-base.yml
  ) \
  -l <( lpass show --notes "concourse:production pipeline:os-images" ) \
  -l <( lpass show --notes "concourse:production pipeline:bosh:stemcells" ) \
  -l <( lpass show --notes "bats-concourse-pool:vsphere secrets" ) \
  -l <( lpass show --notes "tracker-bot-story-delivery" ) \
  -l <(lpass show --notes "stemcell-reminder-bot")
