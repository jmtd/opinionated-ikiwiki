#!/bin/bash
set -euo pipefail
set -x

# necessary to sync with a volume-mounted repository
ikiwiki --setup ~/setup --rebuild --wrappers

# launch the webserver
exec /usr/sbin/lighttpd -Df /etc/lighttpd/lighttpd.conf
