#!/bin/bash
#for i in `cat Table_log`;
for i in `seq 1 33`;
do zcat ${i}/New_map/LOD3_gal6_CHR${i}.rnm.beagle.vcf.gz.10k.filtered.recode.phased_B5.vcf.gz.ibd.gz;done >LOD3_gal6_Merged.rnm.beagle.vcf.gz.10k.filtered.recode.phased_B5.vcf.gz.ibd
gzip -c LOD3_gal6_Merged.rnm.beagle.vcf.gz.10k.filtered.recode.phased_B5.vcf.gz.ibd>LOD3_gal6_Merged.rnm.beagle.vcf.gz.10k.filtered.recode.phased_B5.vcf.gz.ibd.gz


#remove duplicate lines
#awk '!seen[$0]++' Merged_strip_f3 >Merged_strip_f3.txt 
#rm Merged_strip_f3
