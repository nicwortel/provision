#!/usr/bin/env bash
# Installs everything the playbook needs before it can run. Requires root.

# Abort on the first failure, so a broken apt step cannot pass for success.
set -eu

apt-get update
apt-get install --yes software-properties-common

# Ubuntu 26.04 ships ansible 13.1.0; the PPA has 14.x.
apt-add-repository --yes ppa:ansible/ansible

apt-get update
# python3-debian backs the deb822_repository module and git backs the git
# module. Neither is part of a default Ubuntu install, and neither is pulled in
# by the ansible package.
apt-get install --yes ansible git python3-debian sudo
