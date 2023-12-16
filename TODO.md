 Roadmap
 =======

(what's the current version? where is it defined?)

1.0-0:
 * Does volume handling work properly? enumerate the edge cases to consider

1.1-0:
    possibly apache as httpd
        mod_perl (for performance: TODO: measure prior performance)
        multiplexed git URI (i.e., serve humans HTML at the same URI)
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
