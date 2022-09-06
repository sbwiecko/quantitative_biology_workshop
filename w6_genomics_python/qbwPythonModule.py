'''
Course module for the MIT Quantitative Biology Workshop - Updated
'''

__author__='Sara JC Gosline'
__email__='sgosline@mit.edu'
# 11/15/18 bug fixes by Amy Gill and Stephen Rosen - gill.signals@gmail.com
# Python 3 compatibility and fixing file-close error in loadFasta

#6/21/19 more tweaks by Monika Avello - mavello@mit.edu
#removed instances of 'rU' from open() since no longer utilized 

##package imports enable the parsing of different types of files
import csv
import zipfile
import contextlib
import io
import gc


def loadFasta(filename):
    '''
    Takes zipped FASTA-formatted file and reads into dictionary of strings. This is Woanders' modified function, vastly improving load times for Windows users.
    '''
    seqdict={}
    lcount=0

    zf = None

    if zipfile.is_zipfile(filename):
        print('will load from zip')
        zf = zipfile.ZipFile(filename,'r')
        fn = zf.namelist()[0]

        # py2 vs py3 means we need to explicitly open this file as "text" not "bytes"
        # in py3.6+ mode='U' was removed from ZipFile.open , so use io.TextIOWrapper
        # to ensure it works in py2.7, py3.5, and py3.6+
        lines = io.TextIOWrapper(zf.open(fn))
        
    else:
        print('will load from non-zip')
        lines = io.TextIOWrapper(zf.open(filename))

    try:
        curr_header,curr_seq='',[] #initialize blank string & empty list
        for row in lines:
            lcount+=1
            if lcount % 10000==0:
                print('Parsed line ' + str(lcount))

            if row.startswith('>'):
                if curr_header != '': #this means it's not the first
                    seqdict[curr_header]=''.join(curr_seq) #add sequence
                    curr_seq=[]
                    gc.collect() #request that memory be freed
                curr_header=row[1:].strip()
            else:
                curr_seq.append(row.strip())
        print('Found '+str(len(seqdict))+' sequences in FASTA file')

        return seqdict
    
    finally:
        zf.close()


def loadGeneFile(filename,getCoding=False):
    '''
    Takes tab-delimited gene table from UCSC genome browser 
    and loads gene locations
    '''
    genedict={}
    chroms=set()
    fields=['name','chrom','strand','txStart','txEnd','cdsStart','cdsEnd','exonCount','exonStarts','exonEnds','proteinID','alignID']
    reader=csv.DictReader(open(filename),fieldnames=fields,delimiter='\t')
    for line in reader:
        if getCoding:
            start=int(line['cdsStart'])
            end=int(line['cdsEnd'])
        else:
            start=int(line['txStart'])
            end=int(line['txEnd'])
        genedict[line['name']]={'chr':line['chrom'],'start':start,'end':end,'strand':line['strand']}
        chroms.add(line['chrom'])
    print('Parsed info for '+str(len(genedict))+' genes on '+str(len(chroms))+' chromosomes')
    return genedict
    


def getTssOnChroms(gene_info,chrom):
    starts={}
    for g in gene_info.keys():
        if gene_info[g]['chr']==chrom:    
            if gene_info[g]['strand']=='+':
                starts[g]=gene_info[g]['start']
            else:
                starts[g]=gene_info[g]['end']
    return starts