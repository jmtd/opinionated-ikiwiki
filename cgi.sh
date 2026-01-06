#!/bin/bash
set -euo pipefail

# used in IkiWiki.pm as an example value in a few places
export HOME=/home/ikiwiki

exec /usr/local/bin/ikiwiki \
    --setup /home/ikiwiki/conf/setup \
    --verbose \
    --cgi
