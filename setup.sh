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

# Ikiwiki::Setup::Automator overwrites this value
sed -i \
    's#^git_wrapper: /home/ikiwiki/conf/git/ikiwiki.git/hooks/post-update#&.ikiwiki#' \
    conf/setup
mv /home/ikiwiki/conf/git/ikiwiki.git/hooks/post-update{,.ikiwiki}

# reclone with --shared setting
mv src/.ikiwiki dot-ikiwiki
rm -rf src
git clone --shared conf/git/ikiwiki.git src
mv dot-ikiwiki src/.ikiwiki

# early catch a force-push so we can rebuild the whole wiki
cp -t  /home/ikiwiki/conf/git/ikiwiki.git/hooks \
    pre-receive \
    post-update

# this is necessary despite the global setting as the local setting overrides it
GIT_DIR=/home/ikiwiki/conf/git/ikiwiki.git git config receive.denynonfastforwards false

# Set up git repos for libdir (plugins) and templates (page templates)
for r in libdir templates; do
    DIR="conf/git/$r.git"
    GIT_DIR="$DIR" git init
    git clone "$DIR" $r
    cat >"$DIR"/hooks/post-update <<EOF
#!/bin/bash
set -euo pipefail
set -x
unset "\${!GIT_@}"
cd "/home/ikiwiki/$r"
git pull
export HOME=/home/ikiwiki
/usr/local/bin/ikiwiki --setup /home/ikiwiki/conf/setup --rebuild
EOF
    chmod +x "$DIR"/hooks/post-update
done
