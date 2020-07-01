#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  ScatterFeatureRequirement: {}

hints:
  DockerRequirement:
    dockerPull: chrishah/samtools:1.9

inputs:
  filein: File[]

outputs:
  pipeline_result:
    type: File
    outputSource: step4/catout

steps:

  step1:
    run: samtools_stats_tool.cwl
    scatter: [filein]
    scatterMethod: dotproduct
    in:
      filein: filein
    out:
      [statsout]

  step2:
    run: grep_tool.cwl
    scatter: [input_file]
    scatterMethod: dotproduct
    in:
      input_file: step1/statsout
    out:
      [grepout]

  step3:
    run: cut_tool.cwl
    scatter: [input_file]
    scatterMethod: dotproduct
    in:
      input_file: step2/grepout
    out:
      [cutout]

  step4:
    run: cat_tool.cwl
    in:
      filein: step3/cutout
    out:
      [catout]
