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
