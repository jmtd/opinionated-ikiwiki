 * some of the automation stuff (init git repo) should happen at container
   start-up rather than at build-time, so it works if the user volume mounts an
   empty dir over the top. More generally volume handling
 * stop using ikiwiki automator and instead do it all in launch.sh, allowing
   override of individual pieces via env var definitions
 * can we get cgit at /git?
 * should we root the wiki at a subdir so /git and /ikiwiki are not shadowing it
    we are also shadowing /ikiwiki/
 * adjust ikiwiki plugin to generate htpasswd output of account DB for cgit
 * version control the setup file
 * remove need for suid wrapper (patch Wrapper.pm?)
 * force-pushing results in broken CSS until a site rebuild occurs (relates to
   theme use)
 * unauthenticated git pull, and split cgiauthurl for ikiwiki
 * launch.sh needs to re-clone the source repository if/because the relationship can be
   broken by persistent volumes (original value is clone of BUILD TIME repo, not whatever
   is volume mounted)
