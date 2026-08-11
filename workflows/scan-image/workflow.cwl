#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: Workflow

requirements:
- class: SubworkflowFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: image
  type: string
- id: old_index
  type: File?

outputs:
- id: output
  type: File?
  outputSource: syft/output
- id: config
  type: File?
  outputSource: inspect_config/config_json

steps:
- id: inspect
  in:
  - id: image
    source: image
  run: inspect.cwl
  out:
  - inspect_json
- id: digest
  in:
  - id: inspect_json
    source: inspect/inspect_json
  run: digest.cwl
  out:
  - digest
- id: check_index
  in:
  - id: index
    source: old_index
  - id: digest
    source: digest/digest
    valueFrom: $(self.split(":").pop())
  run: check_index.cwl
  out:
  - exists
- id: syft
  in:
  - id: digest
    source: digest/digest
  - id: image
    source: image
  - id: skip
    source: check_index/exists
  when: $(!inputs.skip)
  run: syft.cwl
  out:
  - output
- id: inspect_config
  in:
  - id: digest
    source: digest/digest
  - id: image
    source: image
  - id: skip
    source: check_index/exists
  when: $(!inputs.skip)
  run: inspect_config.cwl
  out:
  - config_json
