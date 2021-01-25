#!/bin/bash
lfs quota -h -u $USER /lustre/

ncdu

du -sch file_path #Summarize; C:total ;Human readable
