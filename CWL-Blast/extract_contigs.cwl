
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python
stdout: extracted_contigs.txt

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  script3:
    type: File
    inputBinding:
      position: 1
  fasta_file:
    type: File
    inputBinding:
      position: 2
  headers_file:
    type: File
    inputBinding:
      position: 3
  opt:
    type: string
    default: "extracted_contigs.txt"
    inputBinding:
      position: 4
outputs:
  Extract:
    type: stdout
