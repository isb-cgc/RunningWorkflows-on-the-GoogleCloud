#cat_tool.cwl
#this task gather all the GC content to a text file
cwlVersion: v1.0

class: CommandLineTool

baseCommand: cat

inputs:
  filein:
    type: File[]
    inputBinding:
      position: 1

outputs:
  catout:
    type: stdout

stdout: final_output.txt
