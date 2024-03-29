#!usr/bin/env cwl-runner
#Building index file for alignment using hisat2
cwlVersion: v1.0
class: CommandLineTool
baseCommand:
stdout: hisat2_build.log
requirements:
   ShellCommandRequirement: {}
   InlineJavascriptRequirement: {}
   DockerRequirement:
      dockerPull: kathrinklee/rna-seq-pipeline-hisat2

arguments:
  - position: 1
    valueFrom: "mkdir"
  - position: 2
    valueFrom: $(inputs.fasta_file.nameroot)
  - position: 3
    shellQuote: False
    valueFrom: '&& cd'
  - position: 4
    valueFrom: $(inputs.fasta_file.nameroot)
  - position: 5
    shellQuote: False
    valueFrom: '&& hisat2-build'
inputs:
  fasta_file:
    type: File
    inputBinding:
      position: 6
  out_name:
    type: string
    inputBinding:
      position: 7
outputs:
   ht:
      type: Directory
      outputBinding:
         glob: $(inputs.fasta_file.nameroot)
   log:
      type: stdout
