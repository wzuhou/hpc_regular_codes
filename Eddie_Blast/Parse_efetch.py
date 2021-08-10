#!/bin/python3

from sys import argv

####Usage
####py [this script.py] *.efetch > output.efetch.table
####
def parse_efetch(lines):
    """
    genes=[(ncbi,ID,species)]
    """
    genes=[]
    #count=0
    ncbi=''
    ID=''
    species=''
    species1=''
    species2=''
    for line in lines:
        if not line.strip():
            continue
        if line.startswith(">"):
            ncbi= (line.split(' ')[0]).split('>')[1]
            #count= count-1
            species1=line.split(' ')[2]
            species2=line.split(' ')[3]
            species=species1+' ' +species2
            ID=(line.split('(')[1]).split(')')[0]
            genes.append((ncbi,ID,species))
            #print(geines)
    genes.append((ncbi,ID,species))
    return genes

if __name__ == "__main__":
    inp_fn=argv[1]
    parse_table=parse_efetch(open(inp_fn))
    for i in parse_table:
        print('{0}\t{1}\t{2}'.format(i[0],i[1],i[2]))
