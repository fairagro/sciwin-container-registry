#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool
$namespaces:
  edam: http://edamontology.org/

requirements:
- class: InitialWorkDirRequirement
  listing:
  - entryname: scripts/generate_api.py
    entry:
      $include: ../../scripts/generate_api.py
- class: DockerRequirement
  dockerPull: python:3.12-slim

inputs:
- id: db
  type: File
  format: edam:format_1926
  inputBinding:
    prefix: --db
- id: output
  type: string
  default: api
  inputBinding:
    prefix: --output

outputs:
- id: api
  type: Directory
  outputBinding:
    glob: api/

baseCommand:
- python3
- scripts/generate_api.py
$schemas:
- https://edamontology.org/EDAM.owl
