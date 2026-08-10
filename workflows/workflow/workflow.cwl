#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.2

inputs: []
outputs: []
requirements:
- class: SubworkflowFeatureRequirement

steps:
- id: inspect
  in: []
  out:
  - inspect_json
  run: ../inspect/inspect.cwl
