#!/usr/bin/env nextflow
params.outdir = "$baseDir/results"
params.db = "$baseDir/db/SampleDB"
params.query = "$baseDir/data/sample.fa"
params.script1 = "$baseDir/scripts/Extract_Headers.py"
params.script2 = "$baseDir/scripts/Count_Nucleotides.py"
params.script3 = "$baseDir/scripts/Extract_Contigs.py"
db_dir = file(params.db).parent
db_name = file(params.db).name
process Blastn{
    publishDir params.outdir, mode: 'copy'
    input:
    path db from db_dir
    path query from params.query

    output:
    path 'Blastn.out' into blastn_ch

    "blastn -db $db/$db_name -query ${query} -outfmt 6 -out Blastn.out"
}
process Extract_Headers{
    publishDir params.outdir, mode: 'copy'
    input:
    path script1 from params.script1
    path blastn_out from blastn_ch

    output:
    path 'Headers.txt' into headers_ch

    """
    python ${script1} ${blastn_out} Headers.txt
    """
}
process Count_Nucleotides{
    publishDir params.outdir, mode: 'copy'
    input:
    path script2 from params.script2
    path headers from headers_ch
    path query from params.query
    output:
    path 'NucleoCount.txt' into script2_out_ch

    """
    python ${script2} ${query} ${headers} > NucleoCount.txt
    """
}
process Extract_Contigs{
    publishDir params.outdir, mode: 'copy'
    input:
    path script3 from params.script3
    path headers from headers_ch
    path query from params.query
    output:
    path 'extracted_contigs.txt' into extracted_contigs_ch

    """
    python ${script3} ${query} ${headers} extracted_contigs.txt
    """
}
