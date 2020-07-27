#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
requirements:
  SubworkflowFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
  ShellCommandRequirement: {}
hints:
  DockerRequirement:
    dockerPull: ncbi/blast:latest
inputs:
  fasta_file: File
  blastn_db: Directory
  script1: File
  script2: File
  script3: File
outputs:
  Blastn_file:
    type: File
    outputSource: step1/blastn_result
  Headers_txt:
    type: File
    outputSource: step2/Headers
  NucleoCount_txt:
    type: File
    outputSource: step3/Count
  Extracted_contigs_txt:
    type: File
    outputSource: step4/Extract
steps:
  step1:
    run: blast.cwl
    in:
      fasta_file: fasta_file
      db_dir: blastn_db
    out:
      [blastn_result]
  step2:
    run: extract_headers.cwl
    in:
      script1: script1
      blastn_out: step1/blastn_result
    out:
      [Headers]
  step3:
    run: count_nucleotides.cwl
    in:
      script2: script2
      fasta_file: fasta_file
      headers_file: step2/Headers
    out:
      [Count]
  step4:
    run: extract_contigs.cwl
    in:
      script3: script3
      fasta_file: fasta_file
      headers_file: step2/Headers
    out:
      [Extract]
