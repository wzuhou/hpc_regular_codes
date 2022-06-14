#!/bin/sh
# This script shows how to use aws-cli to download data from S3 amazon service
# see: https://github.com/aws/aws-cli
# Before start
# Install aws:pip or anaconda 
# Configure

aws configure

# AWS Access Key ID: MYACCESSKEY
# AWS Secret Access Key: MYSECRETKEY
# Default region name [us-west-2]: us-west-2
# Default output format [None]: gz

# Grid Engine options
#$ -N download
#$ -cwd
#$ -l h_vmem=4G
#$ -M zwu33@ed.ac.uk
#$ -m baes
#$ -pe sharedmem 4

export OMP_NUM_THREADS=$NSLOTS

# If you plan to load any software modules, then you must first initialise the modules framework.
. /etc/profile.d/modules.sh
module load anaconda
source activate py37

for i in `seq 48`; do \
source=`sed -n ${i}p list_file.txt`
#echo $source
outputFile="/exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/WCS/Raw_data/BSseq/BSseq_RNA/${source}"
amzFile="${folder}/${source}"
#Copy
aws s3 cp s3://${bucket}/${amzFile} ${outputFile} #Or just copy the S3 URL to modify
#Echo
echo "Downloading from ${amzFile} to ${outputFile}"
done

date
