#!/usr/bin/env bash

set -eu

fly -t production set-pipeline \
  -p "bosh:xenial-stemcells" \
  -c <( bosh interpolate ci/xenial/pipeline.yml ) \
  -l <( lpass show --note "concourse:production pipeline:os-images" ) \
  -l <( lpass show --note "concourse:production pipeline:bosh:stemcells" ) \
  -l <( lpass show --note "bats-concourse-pool:vsphere secrets" ) \
  -l <( lpass show --note "tracker-bot-story-delivery" )
