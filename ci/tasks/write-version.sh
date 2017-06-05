#!/usr/bin/env bash

VERSION_ID=$(cat $PWD/ubuntu-trusty-tarball/version)

sed -i "s/\(\"bosh-ubuntu-trusty-os-image.tgz\": \).*/\1\"$VERSION_ID\"/" bosh-linux-stemcell-builder-versions-json/bosh-stemcell/os_image_versions.json
