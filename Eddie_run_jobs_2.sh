#!/bin/sh
###########################################
#                                         #
# Each compute node has fast local disk   #
# accessible through the $TMPDIR variable #
#                                         #
###########################################
 
# Grid Engine options
#$ -N UsingTmpdir
#$ -cwd
#$ -l h_vmem=2G
#$ -l h_rt=00:02:00
 
# Run the program
echo '======================================================================'
echo 'Timing writes to $TMPDIR' $TMPDIR', 10 x 100Mb'
for i in `seq 1` ; do time ( dd if=/dev/zero of=$TMPDIR/$JOB_ID-$i.tmp bs=10000 count=100000 2>&1 ; sync ) 2>&1 ; done
echo '======================================================================'
echo 'Timing writes to /exports/eddie/scratch, 10 x 100Mb'
for i in `seq 1` ; do time ( dd if=/dev/zero of=/exports/eddie/scratch/$JOB_ID-$i.tmp bs=100000 count=10000 2>&1 ; sync ) 2>&1 ; done
echo '======================================================================'
echo 'Timing reads from $TMPDIR' $TMPDIR', 10 x 100Mb'
for i in `seq 1` ; do time ( dd if=$TMPDIR/$JOB_ID-$i.tmp of=/dev/null bs=10000 count=100000 2>&1 ) 2>&1 ; done
echo '======================================================================'
echo 'Timing reads from /exports/eddie/scratch, 10 x 100Mb'
for i in `seq 1` ; do time ( dd if=/exports/eddie/scratch/$JOB_ID-$i.tmp of=/dev/null bs=100000 count=10000 2>&1 ) 2>&1 ; done
echo '======================================================================'
 
# Clean up
for i in `seq 1` ; do rm $TMPDIR/$JOB_ID-$i.tmp ; done
for i in `seq 1` ; do rm /exports/eddie/scratch/$JOB_ID-$i.tmp ; done
######################################################################


#!/bin/sh
###########################################
#                                         #
# This Job demonstrates trapping signals  #
# sent by the Grid Engine. This can be    #
# useful for application checkpointing.   #
#                                         #
###########################################
 
# Grid Engine options
#$ -N TrappingSignals
#$ -cwd
#$ -l h_rt=00:03:00
#$ -l s_rt=00:00:20
#$ -notify
#$ -M yourUUN@ed.ac.uk
#$ -m beas
 
# Trap incoming signals in the parent shell script, so it doesn't die. Signals
# are sent to the parent shell and all child processes (typically the main
# application to be run). The application can act accordingly on receipt of
# any signals. An example application (with code) is given here.
 
trap 'echo catch signal USR1 at `date +"%D %T"`' usr1
trap 'echo catch signal USR2 at `date +"%D %T"`' usr2
trap 'echo catch signal TERM at `date +"%D %T"`' term
 
# Run the program
echo '======================================================================'
./TrappingSignals/checkpointable_on_sigusr1
echo '======================================================================'

############################################################################



#!/bin/sh
############################################
#                                          #
# An array job (using -t) separates your   #
# job into an array of independent tasks.  #
#                                          #
# Note the use of $1 (input argument to    #
# the script) and the use of $SGE_TASK_ID. #
#                                          #
# Also note that the default output and    #
# error filenames take the form:           #
#  $JOB_NAME.o$JOB_ID.$TASK_ID             #
#  $JOB_NAME.e$JOB_ID.$TASK_ID             #
#                                          #
############################################
 
# Grid Engine options
#$ -N ArrayJob
#$ -cwd
#$ -l h_vmem=2G
#$ -l h_rt=00:02:00
#$ -t 1-100
#$ -e error
# $ -o $JOB_NAME-$USER-$HOSTNAME-$TASK_ID.o
# $ -e $JOB_NAME-$USER-$HOSTNAME-$TASK_ID.e
 
# Run the program below here (This is a simple shell script)
echo '========================================================================='
echo "This is task $SGE_TASK_ID of array job $JOB_ID. I am running on $HOSTNAME"
cat /exports/eddie/scratch/array/data.$SGE_TASK_ID 2>/dev/null
echo '========================================================================='


####### Dependency
#Submit these three jobs in this order:
 
#qsub 8.1a-Dependencies.sh ; 8.1b-Dependencies.sh ; 8.1c-Dependencies.sh
 
#Try submitting 8.1a a number of times, along with a single submission of 8.1b.
 
#What execution order do you expect? What happens?
#######################################
