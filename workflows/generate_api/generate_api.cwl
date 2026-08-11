#!/usr/bin/env cwl-runner

$namespaces:
  edam: http://edamontology.org/

$schemas:
- https://edamontology.org/EDAM.owl

baseCommand:
- python3
- scripts/generate_api.py
class: CommandLineTool
cwlVersion: v1.2

inputs:
- default:
    class: File
    location: ../../index/index.sqlite
  format: edam:format_1926
  id: db
  inputBinding:
    prefix: --db
  type: File
- default: api
  id: output
  inputBinding:
    prefix: --output
  type: string

outputs:
- id: api
  outputBinding:
    glob: api/
  type: Directory

requirements:
- class: InitialWorkDirRequirement
  listing:
  - entry:
      $include: ../../scripts/generate_api.py
    entryname: scripts/generate_api.py
- class: DockerRequirement
  dockerPull: python:3.12-slim
