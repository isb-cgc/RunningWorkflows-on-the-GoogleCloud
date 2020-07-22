#!usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: stringtie
stdout: transcript.log
requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: kathrinklee/rna-seq-pipeline-hisat2

inputs:
  gtf_file:
    type: File
    inputBinding:
      position: 1
      prefix: "-G"
  prefix1:
    type: string
    default: "--rf"
    inputBinding:
      position: 2
  prefix2:
    type: string
    default: "-e"
    inputBinding:
      position: 3
  prefix3:
    type: string
    default: "-B"
    inputBinding:
      position: 4
  gtf_transcript:
    type: string
    default: "final_transcript.gtf"
    inputBinding:
      position: 5
      prefix: "-o"
  tsv_file_name:
    type: string
    default: "final.tsv"
    inputBinding:
      position: 6
      prefix: "-A"
  gtf_ref:
    type: string
    default: "final_ref.gtf"
    inputBinding:
      position: 7
      prefix: "-C"
  bam_file:
    type: File
    inputBinding:
      position: 8
      prefix: "--rf"
outputs:
  gtf_transcript_file:
    type: File
    outputBinding:
      glob: "final_transcript.gtf"
  tsv_file:
    type: File
    outputBinding:
      glob: "final.tsv"
  gtf_ref_file:
    type: File
    outputBinding:
      glob: "final_ref.gtf"
