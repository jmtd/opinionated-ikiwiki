#!/bin/bash
set -euo pipefail

# necessary to sync with a volume-mounted repository
ikiwiki --setup ~/conf/setup --rebuild --wrappers

# launch the webserver
exec /usr/sbin/lighttpd -Df /etc/lighttpd/lighttpd.conf
