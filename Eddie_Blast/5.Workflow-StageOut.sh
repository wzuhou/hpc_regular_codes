#!/bin/sh
 
###########################################
#                                         #
# This job stages the results from Eddie  #
# HPC disk to a directory on DataStore.   #
#                                         #
###########################################
 
# Grid Engine options
#$ -N WF-StageOut
#$ -cwd
#$ -l h_rt=00:01:00
#$ -hold_jid WF-Reduction
#$ -q staging
 
# Make job resubmit if it runs out of time
#$ -r yes
#$ -notify
trap 'exit 99' sigusr1 sigusr2 sigterm
 
# Source and destination directories
#
# Source path on Eddie. It should be on Eddie fast HPC disk, starting with one of:
# /exports/csce/eddie, /exports/chss/eddie, /exports/cmvm/eddie, /exports/igmm/eddie or /exports/eddie/scratch,
SOURCE=/exports/eddie/scratch/$USER/BLAST/results
#
# Destination path on DataStore. It should start with one of /exports/csce/datastore, /exports/chss/datastore, /exports/cmvm/datastore or /exports/igmm/datastore
DESTINATION=/exports/sg/datastore/iti/groups/is_courses/CourseData/BLAST_results/$USER/
 
# Copy with rsync
rsync -rl ${SOURCE} ${DESTINATION}
