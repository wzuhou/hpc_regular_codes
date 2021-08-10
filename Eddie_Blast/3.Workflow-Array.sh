#!/bin/sh
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
