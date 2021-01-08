#!/bin/bash
set -euo pipefail

# Detect situation where cloned repos and source repos are not associated
# (perhaps due to a volume mount) and re-create
# TODO: what about the other git repos?
if ! GIT_DIR=./src/.git git show-ref >/dev/null 2>&1; then
    mv src/.ikiwiki dot-ikiwiki
    rm -rf src
    git clone --quiet --shared conf/git/ikiwiki.git src
    mv dot-ikiwiki src/.ikiwiki

    # remove indexdb, which caches the stale commit refs.
    # See <https://ikiwiki.info/bugs/ikiwiki_explodes_when_git_rewrites_history/>
    rm -f src/.ikiwiki/indexdb

    # is this needed in other circumstances?
    ikiwiki --setup ~/conf/setup --rebuild --wrappers
fi

# launch the webserver
exec /usr/sbin/lighttpd -Df /etc/lighttpd/lighttpd.conf
