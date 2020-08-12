#!/usr/bin/env nextflow

params.outdir = "$baseDir/results"
params.indexDir = "$baseDir/reference"
params.refGenome = "$baseDir/data/sample.fa"
params.forRead = "$baseDir/data/sample_1.fq"
params.revRead = "$baseDir/data/sample_2.fq"
params.gtfFile = "$baseDir/data/sample.gtf"
/*Building index file for alignment using hisat2 */
process buildIndex {
    publishDir params.indexDir, mode: 'copy'
    echo true
    input:
    path refGenome from params.refGenome

    output:
    path 'index*' into index_ch

    """
    echo "Building Indices"
    hisat2-build ${refGenome} index
    """
}
/*Aligning the reads to the index database */
process align {
    publishDir params.outdir, mode: 'copy'
    echo true
    input:
    path forRead from params.forRead
    path revRead from params.revRead
    file indices from index_ch.collect()

    output:
    path "sample.sam" into sam_ch

    script:
    index_base = indices[0].toString() - ~/.\d.ht2l?/

    """
    echo "Aligning Reads"
    hisat2 -x ${index_base} --dta  --rna-strandness RF -1 ${forRead} -2 ${revRead} -S sample.sam
    """

}
/*creating a binary compression of Sam file */
process create_bam {
    publishDir params.outdir, mode: 'copy'
    echo true
    input:
    path samFile from sam_ch
    output:
    path "sample.bam" into bam_ch

    """
    echo "Creating bam file"
    samtools view -bh ${samFile} | samtools sort - -o sample.bam; samtools index sample.bam
    """

}
/*Quantify and produce transcript from Bam file */
process create_transcript {
    publishDir params.outdir, mode: 'copy'
    echo true
    input:
    path bamFile from bam_ch
    path gtfFile from params.gtfFile
    output:
    path "final_transcript.gtf" into transcript_ch
    path "sample.tsv" into tsv_ch
    path "final_ref.gtf" into transcript_ref_ch
    """
    echo "Creating transcript"
    stringtie -G ${gtfFile} --rf  -e -B -o final_transcript.gtf -A sample.tsv -C final_ref.gtf --rf ${bamFile}
    """
}
