git_diet
========

Sometimes you just don't want git to keep absolutely everything that has ever been committed to a repo.  Maybe you need to trim down your repo size to put it on github or push it to heroku, or maybe you are just a little fastidious.  Either way, here's hoping some of the scripts in here can help you.

These scripts have only been tested on Mac OS X.  All help very very welcome :D

find\_fattest_objects.sh
--------------------
Shows the largest objects in the git repo of the current directory

    find_fattest_objects.sh [-n <number_of_objects>] [-d] [-f]
    
      OPTIONS
        -n  Show the n largest files in the repo (default 10)
        -d  Filter out files that are currently in the project
        -f  Show file paths only (useful for piping into other scripts)
        

purge\_objects.sh
--------------------
Purge all history of the given objects from the repo

    purge_objects.sh <file>...

      OPTIONS
        file  One or more file paths to purge

Example
=======
To delete the 50 largest objects in your repo that are files that are not in your project anymore

     find_fattest_objects.sh -n50 -d -f | xargs purge_objects.sh 
