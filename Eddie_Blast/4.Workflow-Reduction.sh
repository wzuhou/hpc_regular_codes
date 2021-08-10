#!/bin/sh
###########################################
#                                         #
# This job performs a reduction of the    #
# results obtained from all tasks of the  #
# array job in script 9.3.                #
#                                         #
###########################################
 
# Grid Engine options
#$ -N WF-Reduction
#$ -cwd
#$ -l h_rt=00:00:30
#$ -hold_jid WF-Array
 
# Reduction of the Array job output.
echo '======================================================================'
echo Reduction of data started at $(date). \(Job ID: $JOB_ID, Job Name: $JOB_NAME\)
cd /exports/eddie/scratch/$USER/BLAST
mkdir results
cat *.o | grep -v === > results/all.out
cat *.e > results/all.err
echo Reduction finished at $(date).
echo '======================================================================'
