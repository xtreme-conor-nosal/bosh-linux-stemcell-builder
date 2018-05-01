#!/bin/bash

set -eu

function git_commit() {
  local repo=${1?'GitHub repository path is required.'}

  pushd $repo
    git add bosh-stemcell/os_image_versions.json
    git config user.name "CI Bot"
    git config user.email "ci@localhost"
    git commit -m "Bump OS image for ${OS_NAME}"
  popd
}

function main() {
  local metalink="${PWD}/bosh-linux-stemcell-builder/bosh-stemcell/image-metalinks/${OS_NAME}.meta4"

  meta4 create --metalink "${metalink}"
  meta4 import-file --metalink "${metalink}" "${PWD}/image-tarball/*.tgz"
  meta4 file-set-url --metalink "${metalink}" "$(cat "${PWD}/image-tarball/url")"

  rsync -avzp bosh-linux-stemcell-builder/ bosh-linux-stemcell-builder-push
  git_commit bosh-linux-stemcell-builder-push
}

main
