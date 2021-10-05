#!/bin/bash
#in your screen
$ qlogin -l h_vmem=4G
Your job nnnnnn ("QLOGIN") has been submitted
waiting for interactive job to be scheduled ...
Your interactive job nnnnnn has been successfully scheduled.
Establishing /exports/applications/gridengine/2011.11p1_155/util/qlogin_wrapper session to host node2f23.ecdf.ed.ac.uk ...

$ module load singularity
$ export SINGULARITY_TMPDIR=$TMPDIR
#$ export SINGULARITY_CACHEDIR=/exports/eddie/scratch/<USER>/singularity
$ export SINGULARITY_TMPDIR=$/exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/Install/Singularity
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
-------------------------------
Downloading containers
In the last section, we validated our Singularity installation by “running” a container from the Container Library. Let’s download that container using the pull command.

$ cd ~

$ singularity pull library://godlovedc/funny/lolcow
You’ll see a warning about running singularity verify to make sure that the container is trusted. We’ll talk more about that later.

For now, notice that you have a new file in your current working directory called lolcow_latest.sif

$ ls lolcow_latest.sif
lolcow_latest.sif


Entering containers with shell
Now let’s enter our new container and look around. We can do so with the shell command.

$ singularity shell lolcow_latest.sif



