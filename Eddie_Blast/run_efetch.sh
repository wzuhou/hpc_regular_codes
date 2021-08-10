#Gene_name_Gal7_unmapped.txt.ID.cds.fa
PATH="$PATH:$PATH:$HOME/edirect/"

#cut -f 2 Gene_name_Gal7_unmapped.txt.ID.cds.fa.blastGal7.txt2> Gene_name_Gal7_unmapped.txt.ID.cds.fa.blastGal7.txt2.subjectID
#Note: Gene_name_Gal7_unmapped.txt.ID.cds.fa.blastGal7.txt2 is the output of blastn

# Efetch the subject name and the corresponding info
for i in `cat Gene_name_Gal7_unmapped.txt.ID.cds.fa.blastGal7.txt2.subjectID`; do efetch -db nuccore -id $i -format fasta | grep ">"; done >Gene_name_Gal7_unmapped.txt.ID.cds.fa.blastGal7.txt2.subjectID.efetch
