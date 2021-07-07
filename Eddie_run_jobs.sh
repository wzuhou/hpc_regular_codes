#!/bin/bash
#For all submission scripts, when you have submitted a job, you can monitor its progress easily with the following command:
watch -n 10 qstat -r -u $USER

###########################################
#                                         #
# Submit a job which uses some installed  #
# applications, using:                    #
# "module load <application>"             #
#                                         #
###########################################
 
# Grid Engine options
#$ -N loading_software
#$ -cwd
#$ -l h_vmem=2G
#$ -l h_rt=00:02:00
#$ -M yourUUN@ed.ac.uk
#$ -m baes
#$ -o $JOB_NAME-$USER-$HOSTNAME.o
#$ -e $JOB_NAME-$USER-$HOSTNAME.e
 
# If you plan to load any software modules, then you must first initialise the modules framework.
. /etc/profile.d/modules.sh
 
# Then, you must load the modules themselves
module load R
module load intel/2016
 
# Run the program
echo '======================================================================'
echo 'Hello World!'
echo "This job is running on $HOSTNAME"
echo 'The current date and time is: ' `date`
echo '======================================================================'
echo 'Print the Intel compiler version:'
icc --version
echo '======================================================================'
echo 'Print the R version:'
R --version
echo '======================================================================'


#Log into an interactive node with:
qlogin


#You do not need to have a submission script at all! Rather, you can supply arguments to qsub on the command line, and name your
#application directly, after using the -b option. Sometimes it also helps to use -V and -v to supply/tailor your current environment.
#For example:
 
qsub -cwd -b y -N CatReadme cat README
 
module load R
qsub -cwd -V -b y R --version
 
qsub -v MYVAR=myvalue -b y -N EnvGrepMyvar "env|grep MYVAR"
#In addition, you can (with or without a submission script) set defaults for Grid Engine in your ~/.sge_request file, 
#or a .sge_request file if present in the directory


###############################################################################
#                                                                             #
# This job reports the available memory and tests allocation up to that limit #
#                                                                             #
###############################################################################
 
# Grid Engine options
#$ -N memory
#$ -cwd
#$ -l h_vmem=8G
#$ -pe sharedmem 1
#$ -l h_rt=00:02:00
 
# Initialise the modules framework and load required modules
. /etc/profile.d/modules.sh
 
# Preamble
echo '========================================================================'
echo $(ulimit -v) KB virtual memory is usable.
echo Stack size is $(ulimit -s)
echo '========================================================================'
 
# Run the program
echo '========================================================================'
./memorycheck
echo '========================================================================'

#Runs this job on the GPU nodes. See the Wiki for details of different gpgpus available. Currently we have a number of NVIDIA Tesla K80s.


#############################################
#                                           #
# This job runs a simple OpenMP application #
#                                           #
#############################################
 
# Grid Engine options
#$ -N OpenMP-hello
#$ -cwd
#$ -pe sharedmem 4
#$ -l h_rt=00:05:00
 
# Initialise the modules framework and load required modules
. /etc/profile.d/modules.sh
 
# set number of threads using $NSLOTS (provided by Grid Engine)
export OMP_NUM_THREADS=$NSLOTS
 
# Run the program
echo '========================================================================'
echo OMP_NUM_THREADS=$OMP_NUM_THREADS
./HelloWorld_OpenMP/hello
echo '========================================================================'

##########################################
#                                        #
# This job runs a simple MPI application #
#                                        #
##########################################
 
# Grid Engine options
#$ -N MPI-hello
#$ -cwd
#$ -pe mpi 16
#$ -l h_rt=00:05:00
 
# Initialise the modules framework and load required modules
. /etc/profile.d/modules.sh
 
# Load openmpi module
module load openmpi/1.10.1
 
# Run the program
echo '========================================================================'
mpirun -np $NSLOTS ./HelloWorld_MPI/hello_gcc
echo '========================================================================'


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


###########################################
#                                         #
# This job demonstrates dependencies.     #
# You can define dependencies between     #
# jobs by a list of wildcarded job names  #
# (a wc_job_list in Grid Engine terms).   #
#                                         #
# This is the second of three scripts.    #
# You can submit all 8.1x scripts at      #
# the same time.                          #
#                                         #
###########################################
 
# Grid Engine options
#$ -N WildcardStage2
#$ -cwd
#$ -l h_rt=00:00:30
#$ -o Wildcard.o
#$ -e Wildcard.e
#$ -hold_jid WildcardStage1
 
# Stage 2 of the job.
echo '======================================================================'
echo Stage 2 started at $(date). \(Job ID: $JOB_ID, Job Name: $JOB_NAME\)
sleep 10
echo Stage 2 finished at $(date).
echo '======================================================================'


###########################Staging############################
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



###########################################
#                                         #
# An array job (using -t) separates your  #
# job into an array of independent tasks  #
#                                         #
# Note the use of $SGE_TASK_ID            #
#                                         #
###########################################
 
# Grid Engine options
#$ -N WF-Array
#$ -cwd
#$ -t 1-54
#$ -hold_jid WF-Split
#$ -o /exports/eddie/scratch/$USER/BLAST/$TASK_ID.blast.o
#$ -e /exports/eddie/scratch/$USER/BLAST/$TASK_ID.blast.e
 
. /etc/profile.d/modules.sh
module load igmm/apps/ncbi_blast/2.4.0
 
# Run the program below here (This is a simple shell script)
echo '========================================================================='
cd /exports/eddie/scratch/$USER/BLAST
blastx -outfmt "6" -query est_split$(printf "%02d" $((SGE_TASK_ID - 1))) -db nem.fasta
echo '========================================================================='
