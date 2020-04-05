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
 * force-pushing breaks ikiwiki
    fatal: refusing to merge unrelated histories
    'git pull --prune origin' failed:  at /usr/local/share/perl/5.28.1/IkiWiki/Plugin/git.pm line 251.
    * undo the initial commit from automator so we can easily push an existing
      wiki into a new container
 * unauthenticated git pull, and split cgiauthurl for ikiwiki
