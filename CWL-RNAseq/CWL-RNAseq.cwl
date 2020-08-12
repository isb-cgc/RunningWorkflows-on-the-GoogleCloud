#!/usr/bin/env cwl-runner
#main script that connect all the helpers scripts and input file together
cwlVersion: v1.0
class: Workflow
requirements:
  SubworkflowFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
  ShellCommandRequirement: {}
hints:
  DockerRequirement:
    dockerPull: kathrinklee/rna-seq-pipeline-hisat2
inputs:
  fasta_file: File
  out_name: string
  hisat2_align_out: string
  forward_file: File
  rev_file: File
  bam_out_name: string
  gtf_file: File
outputs:
  index_files:
    type: Directory
    outputSource: step1/ht
  index_log:
    type: File
    outputSource: step1/log
  hisat2_align_folder:
    type: Directory
    outputSource: step2/hisat2_align_dir
  samFile:
    type: File
    outputSource: step2/sam_output
  bamFile:
    type: File
    outputSource: step3/bam_file
  gtf_transcript_file:
    type: File
    outputSource: step4/gtf_transcript_file
  tsv_file:
    type: File
    outputSource: step4/tsv_file
  gtf_ref_file:
    type: File
    outputSource: step4/gtf_ref_file

steps:
  step1:
    run: index_build.cwl
    in:
      fasta_file: fasta_file
      out_name: out_name
    out:
      [ht, log]
  step2:
    run: hisat2_align.cwl
    in:
      hisat2_align_out: hisat2_align_out
      hisat2_index_dir: step1/ht
      forward_file: forward_file
      rev_file: rev_file
    out:
      [hisat2_align_dir, sam_output]
  step3:
    run: create_bam.cwl
    in:
      sam_file: step2/sam_output
      bam_out_name: bam_out_name
    out:
      [bam_file]
  step4:
    run: create_transcript.cwl
    in:
      gtf_file: gtf_file
      bam_file: step3/bam_file
    out:
      [gtf_transcript_file, tsv_file, gtf_ref_file]
