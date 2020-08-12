#!usr/bin/env cwl-runner
# creating a binary compression of Sam file
cwlVersion: v1.0
class: CommandLineTool
baseCommand: samtools
stdout: bam.log
requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: kathrinklee/rna-seq-pipeline-hisat2

inputs:
  first_prefix:
    type: string
    default: "sort"
    inputBinding:
      position: 1
  bam_out_name:
    type: string
    inputBinding:
      position: 2
      prefix: "-o"
  sam_file:
    type: File
    inputBinding:
      position: 3
outputs:
   bam_file:
     type: File
     outputBinding:
        glob: $(inputs.bam_out_name)
