#samtools_stats_tool.cwl
#this task use sammtools to produce stats from bam files
cwlVersion: v1.0
class: CommandLineTool

baseCommand: [samtools, stats]

requirements:
  - class: InlineJavascriptRequirement

inputs:
  filein:
    type: File
    inputBinding:
      position: 1

outputs:
  statsout:
    type: File
    outputBinding:
      glob: "*.stats"

stdout: $(inputs.filein.path.split('/').pop() + '.stats')
