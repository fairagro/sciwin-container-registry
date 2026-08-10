#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: Workflow

requirements:
- class: SubworkflowFeatureRequirement
- class: ScatterFeatureRequirement

inputs:
- id: images
  type:
    type: array
    items: string

outputs:
- id: index
  type: Directory
  outputSource: collect/index

steps:
- id: scan_image
  in:
  - id: image
    source: images
  scatter: image
  run: scan-image/workflow.cwl
  out:
  - output
- id: collect
  in:
    sboms: scan_image/output
  run: index/collect.cwl
  out:
  - index
