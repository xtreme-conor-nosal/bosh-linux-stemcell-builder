#!/usr/bin/env bash

set -eu

dir=$(dirname $0)

pipeline="bosh:stemcells"
args=""

pipeline="$pipeline:$STEMCELL_OS-$STEMCELL_OS_VERSION"
if [ -n "${INITIAL_STEMCELL_VERSION:-}" ]; then
  initial_version=${INITIAL_STEMCELL_VERSION}
else
  initial_version="0.0.0"
fi
args="
  -v initial_version=${initial_version}
  -v stemcell_os=${STEMCELL_OS}
  -v stemcell_os_version=${STEMCELL_OS_VERSION}
"

fly -t production set-pipeline \
  -p "$pipeline" \
  -c <( bosh interpolate $args <( $dir/generate_pipes.sh xenial-1.x ) ) \
  -l <( lpass show --note "concourse:production pipeline:os-images" ) \
  -l <( lpass show --note "concourse:production pipeline:bosh:stemcells" ) \
  -l <( lpass show --note "bats-concourse-pool:vsphere secrets" ) \
  -l <( lpass show --note "tracker-bot-story-delivery" )
