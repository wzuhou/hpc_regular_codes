#!/bin/bash
#Efficiently delete large directory containing thousands of files

mkdir empty_dir
#this is not recommanded, since you may erase all your data
#rsync -a --delete empty_dir/    yourdirectory/ 

find . -name "*.pdf" -print0| xargs -0 rm
