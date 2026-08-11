#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: Workflow

requirements:
- class: SubworkflowFeatureRequirement
- class: ScatterFeatureRequirement
- class: MultipleInputFeatureRequirement

inputs:
- id: images
  type:
    type: array
    items: string
- id: namespaces
  type:
    type: array
    items: string
- id: sql_scheme
  type: File
- id: old_index
  type: File?

outputs:
- id: index
  type: Directory
  outputSource: collect/index
- id: index_sqlite
  type: File
  outputSource: add_index/index_sqlite
- id: api
  type: Directory
  outputSource: generate_api/api

steps:
- id: discover_images
  in:
  - id: namespaces
    source: namespaces
  run: index/discover_images.cwl
  out:
  - images
- id: scan_image
  in:
  - id: image
    source:
    - images
    - discover_images/images
    linkMerge: merge_flattened
  - id: old_index
    source: old_index
  scatter: image
  run: scan-image/workflow.cwl
  out:
  - output
  - config
- id: collect
  in:
  - id: sboms
    source: scan_image/output
    pickValue: all_non_null
  - id: configs
    source: scan_image/config
    pickValue: all_non_null
  run: index/collect.cwl
  out:
  - index
- id: add_index
  in:
  - id: scheme
    source: sql_scheme
  - id: sboms
    source: collect/index
  - id: index
    source: old_index
  run: index/add_index.cwl
  out:
  - index_sqlite
- id: generate_api
  in:
  - id: db
    source: old_index
  run: index/generate_api.cwl
  out:
  - api
