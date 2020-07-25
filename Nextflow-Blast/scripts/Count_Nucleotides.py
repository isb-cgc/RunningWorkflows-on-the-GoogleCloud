import sys

#Input cotig fasta file
contigfile = open(sys.argv[1])

dic = {}
cur_contig = ''
cur_seq = []
linear = []
for line in contigfile:
    if line.startswith(">") and cur_contig == '':
	linear = line.split(" ")
        cur_contig = linear[0][1:].strip()
    elif line.startswith(">") and cur_contig != '':
        dic[cur_contig] = ''.join(cur_seq)
	linear = line.split(" ")
        cur_contig = linear[0][1:].strip()
        cur_seq = []
    else:
        cur_seq.append(line.rstrip())
        dic[cur_contig] = ''.join(cur_seq)

#print(dic)

#Input file that is a list of unique identifiers you want to grab from fasta
listofuniqueidentifiers = open(sys.argv[2])

count = 0
for lin in listofuniqueidentifiers:
    if lin.rstrip() in dic:
        count = len(dic[lin.rstrip()]) + count
print count
