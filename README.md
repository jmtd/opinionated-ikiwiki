# Opinionated Ikiwiki-in-a-box

This is an opinionated, containerized version of
[IkiWiki](https://ikiwiki.info).
Builds of the container are available at
<https://quay.io/repository/jdowland/opinionated-ikiwiki>.

 * The wiki is at [/](/);
 * The CGI end point is [/ikiwiki](/ikiwiki);
 * There are git repositories at
   * [/git/ikiwiki.git](/git/ikiwiki.git) — the wiki source
   * [/git/libdir.git](/git/libdir.git) — for custom plugins (default is empty)
   * [/git/templates.git](/git/templates.git) — for custom templates (default is empty)

The following changes are made from a default IkiWiki installation:

 * theme plugin enabled and actiontabs selected
 * html5 by default
 * Python plugins are removed to fix a bug

## Usage

    podman run --name my_ikiwiki -p 8080:8080 quay.io/jdowland/opinionated-ikiwiki:latest

Then access your wiki at <http://localhost:8080>
or pull/push to <http://localhost:8080/git/ikiwiki.git>

The default web user is `admin` and password `password`.
The Git repositories URIs are currently unprotected.

## TODO

See [TODO](TODO).

## Who / License

[IkiWiki](https://ikiwiki.info) is by [Joey Hess](http://joeyh.name/)
and many others. *Opinionated IkiWiki* is a Project by
[Jonathan Dowland](https://jmtd.net). The code bits in this repository
are © 2020 Jonathan Dowland, and distributed under the terms of the GNU
Public License, version 3 (see [COPYING](COPYING)).
