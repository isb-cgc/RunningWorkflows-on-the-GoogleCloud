
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python
stdout: NucleoCount.txt

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  script2:
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
    default: "NucleoCount.txt"
    inputBinding:
      position: 4
      prefix: ">"
outputs:
  Count:
    type: stdout
