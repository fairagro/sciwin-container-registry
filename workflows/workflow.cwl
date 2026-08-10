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
    type: Directory[]
    outputSource: scan_image/output_dir

steps:
  - id: scan_image
    in:
      image: images
    scatter: image
    run: scan-image/workflow.cwl
    out:
      - output_dir
