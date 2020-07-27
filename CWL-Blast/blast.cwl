#!usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: blastn
stdout: Blastn.out

requirements:
  ShellCommandRequirement: {}
  DockerRequirement:
    dockerPull: ncbi/blast:latest
  InlineJavascriptRequirement: {}

inputs:
  db_dir:
    type: Directory
    inputBinding:
      position: 1
      prefix: "-db"
      valueFrom: "${return inputs.db_dir.path + '/SampleDB'}"
  fasta_file:
    type: File
    inputBinding:
      position: 2
      prefix: "-query"

  type_opt:
    type: string
    default: "6"
    inputBinding:
      position: 3
      prefix: "-outfmt"

  blastn_out:
    type: string
    default: "Blastn.out"
    inputBinding:
      position: 4
      prefix: -out

outputs:
  blastn_result:
     type: stdout
