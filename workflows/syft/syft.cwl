#!/usr/bin/env cwl-runner

$namespaces:
  edam: http://edamontology.org/

$schemas:
- https://edamontology.org/EDAM.owl

baseCommand: sciwin/python-datascience
class: CommandLineTool
cwlVersion: v1.2

inputs:
- default: json
  id: o
  inputBinding:
    prefix: -o
  type: string

outputs:
- format: edam:format_3464
  id: syft_json
  outputBinding:
    glob: syft.json
  type: File

requirements:
- class: DockerRequirement
  dockerPull: anchore/syft
- class: NetworkAccess
  networkAccess: true
stdout: syft.json
