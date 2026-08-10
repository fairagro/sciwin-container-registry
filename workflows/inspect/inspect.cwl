#!/usr/bin/env cwl-runner

$namespaces:
  edam: http://edamontology.org/

$schemas:
- https://edamontology.org/EDAM.owl

baseCommand: inspect
class: CommandLineTool
cwlVersion: v1.2

inputs:
- default: docker://sciwin/python-datascience
  id: docker_sciwin_python_datascience
  inputBinding:
    position: 0
  type: string

outputs:
- format: edam:format_3464
  id: inspect_json
  outputBinding:
    glob: inspect.json
  type: File

requirements:
- class: DockerRequirement
  dockerPull: quay.io/skopeo/stable:latest
- class: NetworkAccess
  networkAccess: true
stdout: inspect.json
