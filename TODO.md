 * some of the automation stuff (init git repo) should happen at container
   start-up rather than at build-time, so it works if the user volume mounts an
   empty dir over the top. More generally volume handling
 * stop using ikiwiki automator and instead do it all in launch.sh, allowing
   override of individual pieces via env var definitions
 * can we get cgit at /git?
 * should we root the wiki at a subdir so /git is not shadowing it
 * adjust ikiwiki plugin to generate htpasswd output of account DB for cgit
 * version control the setup file
 * remove need for suid wrapper (patch Wrapper.pm?)
 * force-pushing results in broken CSS until a site rebuild occurs (relates to
   theme use)
    ./themes is an underlay directory added by the plugin at one point
 * unauthenticated git pull, and split cgiauthurl for ikiwiki
 * when a force-push-triggered rebuild is triggered, do any stale files in ~/public_html
   from the prior version remain, or does ikiwiki clean them up?

 * PATH is missing /usr/local/bin in some situations (web-initiated rebuilds)
 * image size has ballooned from 80/280 to 120/364 MiB. Why?
