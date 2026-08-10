#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.2

inputs:
- id: images
  type:
    items: string
    type: array

outputs:
- id: output_files
  outputSource: scan_image/output_file
  type:
    items: File
    type: array

requirements:
- class: SubworkflowFeatureRequirement
- class: ScatterFeatureRequirement

steps:
- id: scan_image
  in:
  - id: image
    source: images
  out:
  - output_file
  run: scan-image/workflow.cwl
  scatter: image
- id: collect
  in: []
  out:
  - index
  run: collect.cwl
