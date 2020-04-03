# Opinionated Ikiwiki-in-a-box

This is an opinionated, containerized version of [IkiWiki](https://ikiwiki.info).

 * The wiki is at [/](/);
 * The CGI end point is [/ikiwiki](/ikiwiki);
 * There are git repositories at
   * [/git/ikiwiki.git](/git/ikiwiki.git) — the wiki source
   * [/git/libdir.git](/git/libdir.git) — for custom plugins (default is empty)
   * [/git/templates.git](/git/templates.git) — for custom templates (default is empty)

The default user is `admin`. This IkiWiki is configured to use HTTP authentication.
The same credential store is used for the Git repositories.

The following changes are made from a default IkiWiki installation:

 * httpauth enabled
 * html5 by default
 * theme plugin enabled and actiontabs selected
