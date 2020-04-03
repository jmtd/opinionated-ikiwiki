#!/bin/bash
set -euo pipefail
# configure and launch IkiWiki

# stop using ikiwiki automator and instead do it all here, allowing override
# of individual pieces via env var definitions




# more todo
git config --global user.name "ikiwiki-in-a-box automator" \
    && git config --global user.email null@example.org \
    && printf "password\npassword" | ikiwiki --setup auto.setup

# Set up git repos for libdir (plugins) and templates (page templates)
for r in libdir templates; do
    DIR="conf/git/$r.git"
    GIT_DIR="$DIR" git init \
        && git clone "$DIR" $r \
        && echo "cd /home/ikiwiki/$r && git pull" > "$DIR"/hooks/post-update \
        && chmod +x "$DIR"/hooks/post-update
done

# fix git repo settings for access via HTTP
# TODO: just do globally?
for r in conf/git/*.git; do
    (
        cd $r
        git config http.receivepack true
        git config receive.denynonfastforwards false
    )
done

# launch the webserver
exec /usr/sbin/lighttpd -Df /etc/lighttpd/lighttpd.conf
