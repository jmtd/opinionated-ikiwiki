# Opinionated Ikiwiki-in-a-box container

This is an opinionated, containerized version of
[IkiWiki](https://ikiwiki.info), the wiki compiler / static site generator.
Builds of the container are available at
<https://quay.io/repository/jdowland/opinionated-ikiwiki>. They're based on
the *slim* variant of the current Debian stable release, and are approximately
114 MiB (compressed)

 * The container runs a web server (lighttpd), with
   * The wiki content at [/](/);
   * The CGI end point at [/ikiwiki](/ikiwiki);
   * There are git repositories at
     * [/git/ikiwiki.git](/git/ikiwiki.git) — the wiki source
     * [/git/libdir.git](/git/libdir.git) — for custom plugins (default is empty)
     * [/git/templates.git](/git/templates.git) — for custom templates (default is empty)
 * The c-compiler is `tcc`, rather than `gcc` (saving about 100 MiB)
 * There is no Python in the container
 * the Markdown flavour is [Discount](https://www.pell.portland.or.us/~orc/Code/discount/)
 * The various data/configuration locations are consolidated under `/home/ikiwiki/conf`, containing:
  * `git`, the above-mentioned git repositories
  * `htpasswd`, for auth
  * `setup`, the ikiwiki configuration file

The following changes are made from a default IkiWiki installation:

 * theme plugin enabled and actiontabs theme selected
 * html5 by default
 * httpauth enabled
 * Python plugins are removed to fix a
   [bug](https://ikiwiki.info/bugs/inactive_python_plugins_cause_error_output_when_python_interpreter_is_missing/)
 * Comments are enabled and permitted on any non-Discussion page,
   in Markdown or plain text format. Comments require an account.
   All comments by non-admins are held for moderation.
 * [Admonitions](https://ikiwiki.info/plugins/contrib/admonition/) are
   installed and enabled
 * A styled-table CSS class is provided (fullwidth_table)
 * Tables can have separate headers (in the `header` argument) 114.1 MiB 
 * You can defined aliases for PageSpecs in the setup file

The IkiWiki version used is normally the latest tagged release with some
extra patches on top. See <https://github.com/jmtd/ikiwiki/blob/opinionated-doc/README.md>
for the details.

## Usage

    podman run \
        --name my_ikiwiki \
        -p 8080:8080 \
        --mount type=volume,source=myIkiWikiData,target=/home/ikiwiki/conf \
        quay.io/jdowland/opinionated-ikiwiki:latest

Then access your wiki at <http://localhost:8080>
or pull/push to <http://localhost:8080/git/ikiwiki.git>

### Specifying the admin password

The default user is `admin` and a random password is generated when the
container is first started up, and echoed to `stderr`.  This is needed for
editing the wiki via the web interface or pushing/pulling from the git
repositories over HTTP.

On the first container start-up, you can override the random password
generation by supplying one in the `PASSWORD` environment variable. The
variable is unset before the HTTPD daemon starts. It is, unfortunately,
preserved in the container's metadata, and visible via `podman inspect`.

You could instead alter the admin password by editing the `htpasswd`
file after container start-up. See "Adding users" below.

### Persistent data

All the wiki persistent data should be in `/home/ikiwiki/conf` in the
container and I recommend you mark that as a _volume_, as in the example
invocation above, where the volume has been named _myIkiWikiData_, and
will persist beyond the lifetime of the running container, and could
be mounted in another instance, etc.

NOTE: specifying the volume using the `--mount` syntax (as in the above
example) ensures that new volumes are pre-populated with the correct content
from the container. This is important for the container to work! If you instead
bind mount an empty directory over that path, things will break.

### Adding users

Opinionated IkiWiki relies upon the users and their passwords being
defined in `/home/ikiwiki/conf/htpasswd`. To add more users, modify
that file, with e.g. `htpasswd` from the `apache2-utils` Debian package,
e.g.

    $ VOLPATH=$(podman volume inspect -f '{{ .Mountpoint }}' myIkiWikiData)
    $ htpasswd ${VOLPATH}/htpasswd newuser

Once a user exists in the `htpasswd` file, you could grant them admin
rights either by editing `/home/ikiwiki/conf/setup` by hand or using
"Preferences → Setup" on the web.

### Rebuilding the wiki

Sometimes you might want to trigger a full wiki rebuild, such as after
hand-editing the `setup` file:

    $ podman exec -ti my_ikiwiki ikiwiki --setup conf/setup --rebuild --wrappers

## TODO

See [TODO](TODO.md).

## Who / License

[IkiWiki](https://ikiwiki.info) is by [Joey Hess](http://joeyh.name/)
and many others. *Opinionated IkiWiki* is a Project by
[Jonathan Dowland](https://jmtd.net). The code bits in this repository
are © 2020 Jonathan Dowland, and distributed under the terms of the GNU
Public License, version 3 (see [COPYING](COPYING)).
