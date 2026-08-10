#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool
$namespaces:
  edam: http://edamontology.org/

requirements:
- class: DockerRequirement
  dockerPull: quay.io/skopeo/stable:latest
- class: NetworkAccess
  networkAccess: true

inputs:
- id: image
  type: string
  inputBinding:
    position: 0
    valueFrom: docker://$(self)

outputs:
- id: inspect_json
  type: File
  format: edam:format_3464
  outputBinding:
    glob: inspect.json
stdout: inspect.json

baseCommand: inspect
$schemas:
- https://edamontology.org/EDAM.owl
