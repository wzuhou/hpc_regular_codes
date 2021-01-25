#!/bin/bash
lfs quota -h -u $USER /lustre/
#lfs quota -h -u $USER /lustre/nobackup/WUR/ABGC/wu090/Bantam/

ncdu

du -sch file_path #Summarize; C:total ;Human readable
