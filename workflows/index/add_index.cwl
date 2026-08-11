#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool
$namespaces:
  edam: http://edamontology.org/

requirements:
- class: InitialWorkDirRequirement
  listing:
  - entryname: scripts/add_index.py
    entry:
      $include: ../../scripts/add_index.py
  - entryname: index.sqlite
    writable: true
    entry: $(inputs.index)
- class: DockerRequirement
  dockerPull: python:3.12-slim
- class: InlineJavascriptRequirement

inputs:
- id: sboms
  type: Directory
  inputBinding:
    prefix: --sboms
- id: scheme
  type: File
  format: edam:format_3788
  inputBinding:
    prefix: --scheme
- id: index
  type: File?
  inputBinding:
    prefix: --index

outputs:
- id: index_sqlite
  type: File
  format: edam:format_1926
  outputBinding:
    glob: index.sqlite

baseCommand:
- python3
- scripts/add_index.py
$schemas:
- https://edamontology.org/EDAM.owl
