#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
  images:
    type: string[]

outputs:
  output_files:
    type: File[]
    outputSource: scan_image/output_file

steps:
  - id: scan_image
    in:
      image: images
    scatter: image
    run: scan-image/workflow.cwl
    out:
      - output_file
