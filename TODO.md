 Roadmap
 =======

1.0-0:
 * what's broken?

 * Does volume handling work properly? enumerate the edge cases to consider

 * PATH is missing /usr/local/bin in some situations (web-initiated rebuilds)
    is this still true?

1.1-0:
    possibly apache as httpd
        mod_perl
        multiplexed git URI
        setuid wrapper got rid of
        no need for libc-dev, cc etc

 * can we get cgit at /git?
 * possibly adjust ikiwiki plugin to generate htpasswd output of account DB for cgit

Maybe:

 * stop using ikiwiki automator and instead do it all in launch.sh, allowing
   override of individual pieces via env var definitions (Why?)
 * version control the setup file
    ./themes is an underlay directory added by the plugin at one point
 * unauthenticated git pull, and split cgiauthurl for ikiwiki
 * include Pagespec Aliases plugin
