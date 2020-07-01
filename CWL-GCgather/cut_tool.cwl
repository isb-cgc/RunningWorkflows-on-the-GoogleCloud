#cut_tool.cwl

cwlVersion: v1.0

class: CommandLineTool

baseCommand: cut
arguments:
  - "-d "
  - "-f"
  - "1,5-"

inputs:
  input_file:
    type: File
    inputBinding:
      position: 1

outputs:
  cutout:
    type: stdout
