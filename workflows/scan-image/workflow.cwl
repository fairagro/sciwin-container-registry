#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: Workflow

requirements:
- class: SubworkflowFeatureRequirement

inputs:
- id: image
  type: string

outputs:
- id: output_dir
  type: Directory?
  outputSource: syft/output_dir

steps:
- id: inspect
  in:
  - id: image
    source: image
  run: inspect.cwl
  out:
  - inspect_json
- id: syft
  in:
  - id: digest
    source: digest/digest
  - id: image
    source: image
  run: syft.cwl
  out:
  - output_dir
- id: digest
  in:
  - id: inspect_json
    source: inspect/inspect_json
  run: digest.cwl
  out:
  - digest
