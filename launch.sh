#!/bin/bash
set -euo pipefail

# Detect situation where cloned repos and source repos are not associated
# (perhaps due to a volume mount) and re-create
associate_git_dir()
{
    dir="$1"

    # XXX: to handle src ≠ ikiwiki.
    # let's rename it so this can be avoided.
    src="$dir"
    shift
    if [ $# -gt 0 ]; then
        src="$1"
    fi

    if ! GIT_DIR=./$dir/.git git show-ref >/dev/null 2>&1; then
        rm -rf $dir
        git clone --quiet --shared conf/git/$src.git $dir
        return 1 # signal we did something
    fi
    return 0
}

acted=0
mv src/.ikiwiki dot-ikiwiki
if [ ! associate_git_dir "src" "ikiwiki" ]; then
    acted=1
    mv dot-ikiwiki src/.ikiwiki
    # remove indexdb, which caches the stale commit refs.
    # See <https://ikiwiki.info/bugs/ikiwiki_explodes_when_git_rewrites_history/>
    rm -f src/.ikiwiki/indexdb
fi

associate_git_dir "libdir"    || acted=1
associate_git_dir "templates" || acted=1

# if we re-associated any git repositories, rebuild the wiki
[ "$acted" -eq 0 ] || ikiwiki --setup ~/conf/setup --rebuild --wrappers

touch /home/ikiwiki/conf/htpasswd
if ! grep -q ^admin: /home/ikiwiki/conf/htpasswd; then
    if test -z "${PASSWORD-}"; then
        PASSWORD="$(pwgen -s 32)"
    fi
    echo "$PASSWORD" | htpasswd -i /home/ikiwiki/conf/htpasswd admin
    echo "$PASSWORD" >&2
    unset PASSWORD
fi

# launch the webserver
exec /usr/sbin/lighttpd -Df /etc/lighttpd/lighttpd.conf
