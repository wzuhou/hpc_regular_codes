#!/bin/sh

# Grid Engine options
#$ -N lftp
#$ -cwd
#$ -l h_vmem=8G
#$ -M zwu33@ed.ac.uk
#$ -m baes

HOST=gweusftp.brooks.com
USER=<USER>
PASSWD=<"password">

#cd <base directory for your put file>

lftp<<END_SCRIPT
open sftp://$HOST
user $USER $PASSWD
cd /40-640946939/00_fastq
mget *
bye
END_SCRIPT

##########################
#Alternative: interactive#
##########################
cd <base directory for your put file>

sftp <USER>@<HOST>
sftp>> <password>
cd <yor_folder>
mget *
bye
