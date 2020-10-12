# Opinionated Ikiwiki-in-a-box

This is an opinionated, containerized version of
[IkiWiki](https://ikiwiki.info).
Builds of the container are available at
<https://quay.io/repository/jdowland/opinionated-ikiwiki>. They're based on
the *slim* variant of the current Debian stable release, and are approximately
80 MiB compressed, 280 MiB on-disk.

 * The wiki is at [/](/);
 * The CGI end point is [/ikiwiki](/ikiwiki);
 * There are git repositories at
   * [/git/ikiwiki.git](/git/ikiwiki.git) — the wiki source
   * [/git/libdir.git](/git/libdir.git) — for custom plugins (default is empty)
   * [/git/templates.git](/git/templates.git) — for custom templates (default is empty)
 * the HTTPD is lighttpd
 * The c-compiler is `tcc`, rather than `gcc` (saving about 100 MiB)
 * There is no Python in the container

The following changes are made from a default IkiWiki installation:

 * theme plugin enabled and actiontabs selected
 * html5 by default
 * httpauth enabled
 * Python plugins are removed to fix a
   [bug](https://ikiwiki.info/bugs/inactive_python_plugins_cause_error_output_when_python_interpreter_is_missing/)

The IkiWiki version used is normally the latest tagged release with some
extra patches on top. See <https://github.com/jmtd/ikiwiki/blob/opinionated-doc/README.md>
for the details.

## Usage

    podman run --name my_ikiwiki -p 8080:8080 quay.io/jdowland/opinionated-ikiwiki:latest

Then access your wiki at <http://localhost:8080>
or pull/push to <http://localhost:8080/git/ikiwiki.git>

The default user is `admin` and password `password`. This is needed for
editing the wiki via the web interface or pushing/pulling from the git
repositories over HTTP.

## TODO

See [TODO](TODO.md).

## Who / License

[IkiWiki](https://ikiwiki.info) is by [Joey Hess](http://joeyh.name/)
and many others. *Opinionated IkiWiki* is a Project by
[Jonathan Dowland](https://jmtd.net). The code bits in this repository
are © 2020 Jonathan Dowland, and distributed under the terms of the GNU
Public License, version 3 (see [COPYING](COPYING)).
