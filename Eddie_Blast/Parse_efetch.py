#!/bin/python3

from sys import argv
####Usage
####python [this script.py] *.efetch > output.efetch.table
####
def parse_efetch(lines):
    """
    genes=[(ncbi,ID,species)]
    """
    genes=[]
    count=0
    substring='('
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
            count = line.count(substring)
            if count ==1 :
                ID=(line.split('(')[1]).split(')')[0]
            elif count == 2:
                ID=(line.split('(')[2]).split(')')[0]
            elif count ==3:
                ID=(line.split('(')[3]).split(')')[0]
            genes.append((ncbi,ID,species))
            count =0
            #print(geines)
    genes.append((ncbi,ID,species))
    #list(dict.fromkeys(genes))
    return genes

def removeDuplicates(lst):
      
    return [t for t in (set(tuple(i) for i in lst))]

if __name__ == "__main__":
    inp_fn=argv[1]
    parse_table=parse_efetch(open(inp_fn))
    parse_table2=removeDuplicates(parse_table)
    for i in parse_table2:
        print('{0}\t{1}\t{2}'.format(i[0],i[1],i[2]))
