#!/usr/bin/env nextflow
myBamSample = Channel.fromPath('/home/thinh_vo/sample/*.bam')
params.outdir = 'Sam_results'

process bamFilesProcessing {
    cpus 1
    publishDir params.outdir, mode: 'copy'
    echo true
    container "gcr.io/genomics-tools/samtools"
    input:
    file query_file from myBamSample
    output:
    file "${query_file}_stats.txt" into outChannel
    """
    echo "processing ${query_file}"
    samtools stats ${query_file} > ${query_file}_stats.txt
    """
}
process grep_tool{
    publishDir params.outdir, mode: 'copy'
    echo true
    input:
    file x from outChannel
    output:
    file "${x}.grep_out.txt" into grepChannel
    """
    echo "processing grep"
    grep --with-filename '^GCF' ${x} > ${x}.grep_out.txt
    """
}
process cut_tool{
    publishDir params.outdir, mode: 'copy'
    echo true
    input:
    file y from grepChannel
    output:
    file "${y}.cut_out.txt" into cutChannel
    """
    echo "processing cut"
    cut -d '/' -f 9- ${y} > ${y}.cut_out.txt
    """
}
process cat_tool {
    publishDir params.outdir, mode: 'copy', overwrite: true
    echo true
    input:
    file z from cutChannel
    output:
    file "final_gc_stats_out.txt" into finalChannel
    """
    echo "finalizing $z"
    cat ${z} >> final_gc_stats_out.txt
    """
}

finalChannel
      .collectFile(storeDir:'Sam_results')
      .println{ it.text }
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! Open the following report in your result folder\n" : "Oops .. something went wrong" )
}
