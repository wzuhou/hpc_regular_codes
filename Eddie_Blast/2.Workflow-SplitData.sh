#!/bin/sh
###########################################
#                                         #
# This job splits the input data into     #
# multiple input files, ready for all     #
# tasks in the array job that follows     #
# in script 9.3.                          #
#                                         #
###########################################
 
# Grid Engine options
#$ -N WF-Split
#$ -cwd
#$ -l h_rt=00:00:30
#$ -hold_jid WF-StageIn
 
# Stage 2 of the job.
echo '======================================================================'
echo Split of data started at $(date). \(Job ID: $JOB_ID, Job Name: $JOB_NAME\)
# Split the data into a number of pieces
cd /exports/eddie/scratch/$USER/BLAST
split -d -l 1000 ests.fasta est_split
echo Split of data finished at $(date).
echo '======================================================================'
