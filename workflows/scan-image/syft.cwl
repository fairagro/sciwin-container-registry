#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool
$namespaces:
  edam: http://edamontology.org/

requirements:
- class: InlineJavascriptRequirement
- class: DockerRequirement
  dockerPull: anchore/syft
- class: NetworkAccess
  networkAccess: true

inputs:
- id: image
  type: string
  inputBinding:
    position: 0
- id: output_format
  type: string
  default: json
  inputBinding:
    prefix: -o
- id: digest
  type: string

outputs:
- id: output_dir
  type: Directory
  outputBinding:
    glob: $(inputs.digest.split(":")[1])/
stdout: $(inputs.digest.split(":")[1])/sbom.json

baseCommand: []
$schemas:
- https://edamontology.org/EDAM.owl
