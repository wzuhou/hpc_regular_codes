#!/bin/bash

sed -i 's/\/\(.*\)\//\.\//g' $1

#for i in `ls *.md5`; do sh change_md5_name.sh $i ;done

#for i in `ls *.md5`; do md5sum --check  $i ;done >>md5_check_eddie

grep 'FAILED' md5_check_eddie |cut -f 1 -d':' |cut -f 2 -d'/' >Fail_list

##############
#lftp_get.sh
##############
for Files in `less Fail_list`; do
lftp<<END_SCRIPT
open sftp://$HOST
user $USER $PASSWD
cd /40-663824708/00_fastq
mget $Files
bye
END_SCRIPT
done

