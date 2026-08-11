#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool
$namespaces:
  edam: http://edamontology.org/

requirements:
- class: InlineJavascriptRequirement
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
- id: digest
  type: string

outputs:
- id: config_json
  type: File
  format: edam:format_3464
  outputBinding:
    glob: $(inputs.digest.split(":")[1]).config.json
stdout: $(inputs.digest.split(":")[1]).config.json

baseCommand:
- inspect
- --config
$schemas:
- https://edamontology.org/EDAM.owl
