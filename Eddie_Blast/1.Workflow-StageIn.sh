#!/bin/sh
 
###########################################
#                                         #
# This job stages a data directory on     #
# DataStore to Eddie HPC disk.            #
#                                         #
###########################################
 
# Grid Engine options can go here (always start with #$ )
# Name job and set to use current working directory
#$ -cwd
#$ -N WF-StageIn
 
# Choose the staging environment
#$ -q staging
 
# Hard runtime limit
#$ -l h_rt=01:00:00
 
# Job will restart from where it left off if it runs out of time or is otherwise
# terminated (so setting an accurate hard runtime limit is less important)
#$ -r yes
#$ -notify
trap 'exit 99' sigusr1 sigusr2 sigterm
 
# Source path on DataStore. It should start with one of /exports/csce/datastore, /exports/chss/datastore, /exports/cmvm/datastore or /exports/igmm/datastore
#   in this example, .../job_data contains a file of 10M random integers
SOURCE=/exports/sg/datastore/iti/groups/is_courses/CourseData/BLAST
 
# Destination path on Eddie. It should be on Eddie fast HPC disk, starting with one of:
# /exports/csce/eddie, /exports/chss/eddie, /exports/cmvm/eddie, /exports/igmm/eddie or /exports/eddie/scratch,
# in this example we use the scratch area:
DESTINATION=/exports/eddie/scratch/$USER/
 
# Do the copy with rsync
rsync -rl ${SOURCE} ${DESTINATION}
