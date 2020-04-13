#!/bin/bash
set -euo pipefail
set -x

# configure and launch IkiWiki

git config --global user.name "ikiwiki-in-a-box automator"
git config --global user.email null@example.org
git config --global http.receivepack true
git config --global receive.denynonfastforwards false

# creates ~/conf/git,
# ~/conf/git/src.git, with an initial commit on master branch,
# clones it to ~/git; runs ikiwiki, generates ~/public_html,
# ~/src/.ikiwiki (including userdb with admin:password) and generates
# wrappers
printf "password\npassword" | ikiwiki --setup auto.setup
rm auto.setup

# can't seem to force this in auto.setup
sed -i \
    's#^git_wrapper: /home/ikiwiki/conf/git/ikiwiki.git/hooks/post-update#&.ikiwiki#' \
    setup

# early catch a force-push so we can rebuild the whole wiki
cp -t  /home/ikiwiki/conf/git/ikiwiki.git/hooks \
    pre-receive \
    post-update

# this is necessary despite the global setting as the local setting overrides it
GIT_DIR=/home/ikiwiki/conf/git/ikiwiki.git git config receive.denynonfastforwards false

# Set up git repos for libdir (plugins) and templates (page templates)
# XXX: tracking branches won't be set up without initial commits
for r in libdir templates; do
    DIR="conf/git/$r.git"
    GIT_DIR="$DIR" git init \
        && git clone "$DIR" $r \
        && echo "cd /home/ikiwiki/$r && git pull" > "$DIR"/hooks/post-update \
        && chmod +x "$DIR"/hooks/post-update
done

# set up htpasswd file
htpasswd -cb /home/ikiwiki/conf/htpasswd admin password
