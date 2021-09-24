#!/bin/bash
#in your screen
$ qlogin -l h_vmem=4G
Your job nnnnnn ("QLOGIN") has been submitted
waiting for interactive job to be scheduled ...
Your interactive job nnnnnn has been successfully scheduled.
Establishing /exports/applications/gridengine/2011.11p1_155/util/qlogin_wrapper session to host node2f23.ecdf.ed.ac.uk ...

$ module load singularity
$ export SINGULARITY_TMPDIR=$TMPDIR
$ export SINGULARITY_CACHEDIR=/exports/eddie/scratch/<USER>/singularity
$ singularity run library://crown421/default/juliabase
INFO:    Downloading library image
INFO:    Convert SIF file to sandbox...
Singularity> cat /etc/os-release 
PRETTY_NAME="Debian GNU/Linux 8 (jessie)"
NAME="Debian GNU/Linux"
VERSION_ID="8"
VERSION="8 (jessie)"
ID=debian
HOME_URL="http://www.debian.org/"
SUPPORT_URL="http://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
Singularity> exit
exit
INFO:    Cleaning up image...

$ logout
Connection to node2f23.ecdf.ed.ac.uk closed.
/exports/applications/gridengine/2011.11p1_155/util/qlogin_wrapper exited with exit code 0
