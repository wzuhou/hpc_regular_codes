#!/bin/bash
#Efficiently delete large directory containing thousands of files

mkdir empty_dir
rsync -a --delete empty_dir/    yourdirectory/
