#!usr/bin/env cwl-runner
#Aligning the reads to the index database
cwlVersion: v1.0
class: CommandLineTool
baseCommand:

requirements:
  ShellCommandRequirement: {}
  DockerRequirement:
    dockerPull: kathrinklee/rna-seq-pipeline-hisat2
  InlineJavascriptRequirement: {}

arguments:
  - position: 1
    valueFrom: "mkdir"
  - position: 2
    valueFrom: "hisat2_align_out"
  - position: 3
    shellQuote: False
    valueFrom: '&& cd'
  - position: 4
    valueFrom: "hisat2_align_out"
  - position: 5
    shellQuote: False
    valueFrom: '&& hisat2'

inputs:
  hisat2_index_dir:
    type: Directory
    inputBinding:
      position: 6
      prefix: "-x"
      valueFrom: "${return inputs.hisat2_index_dir.path + '/'
                  + inputs.hisat2_index_dir.listing[0].nameroot.split('.').slice(0,-1).join('.')}"
  forward_file:
    type: File?
    inputBinding:
      position: 7
      prefix: "-1"
  rev_file:
    type: File?
    inputBinding:
      position: 8
      prefix: "-2"
  hisat2_align_out:
    type: string
    inputBinding:
      position: 9
      prefix: -S
  log:
    type: string
    default: "hisat2_align_out.log"
    inputBinding:
      position: 10
      prefix: --summary-file

outputs:
  hisat2_align_dir:
    type: Directory
    outputBinding:
      glob: "hisat2_align_out"

  sam_output:
    type: File
    outputBinding:
      glob: $('hisat2_align_out/' + inputs.hisat2_align_out)
