#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.2

inputs:
- id: image
  type: string

outputs:
- id: output_file
  type: File

requirements:
- class: SubworkflowFeatureRequirement

steps:
- id: inspect
  in:
  - id: image
    source: image
  out:
  - inspect_json
  run: ../inspect/inspect.cwl
- id: syft
  in:
  - id: digest
    source: digest/digest
  - id: image
    source: image
  out:
  - output_file
  run: ../syft/syft.cwl
- id: digest
  in:
  - id: inspect_json
    source: inspect/inspect_json
  out:
  - digest
  run: ../digest/digest.cwl
