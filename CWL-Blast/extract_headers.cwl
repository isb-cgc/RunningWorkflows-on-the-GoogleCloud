
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python
stdout: Headers.txt

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  script1:
    type: File
    inputBinding:
      position: 1
  blastn_out:
    type: File
    inputBinding:
      position: 2
  file_name:
    type: string
    default: "Headers.txt"
    inputBinding:
      position: 3
outputs:
  Headers:
    type: stdout
