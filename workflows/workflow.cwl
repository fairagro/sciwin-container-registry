#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.2

inputs:
- id: images
  type:
    items: string
    type: array
- id: sql_scheme
  type: File

outputs:
- id: index
  outputSource: collect/index
  type: Directory
- id: index_sqlite
  outputSource: add_index/index_sqlite
  type: File

requirements:
- class: SubworkflowFeatureRequirement
- class: ScatterFeatureRequirement

steps:
- id: scan_image
  in:
  - id: image
    source: images
  out:
  - output
  run: scan-image/workflow.cwl
  scatter: image
- id: collect
  in:
  - id: sboms
    source: scan_image/output
  out:
  - index
  run: index/collect.cwl
- id: add_index
  in:
  - id: scheme
    source: sql_scheme
  out:
  - index_sqlite
  run: index/add_index.cwl
