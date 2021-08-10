#!/bin/sh
###########################################
#                                         #
# This job cleans up local temporary      #
# files after the workflow is complete.   #
#                                         #
###########################################
 
# Grid Engine options
#$ -N WF-Cleanup
#$ -cwd
#$ -l h_rt=00:01:00
#$ -l s_rt=00:00:20
#$ -hold_jid WF-StageOut
 
echo === Cleanup ran these commands ===
echo rm *.o *.e est_split* all.* ests.fasta nem.*
echo rm -rf results
echo ======================================
cd /exports/eddie/scratch/$USER/BLAST
rm *.o *.e est_split* ests.fasta nem.*
rm -rf results
