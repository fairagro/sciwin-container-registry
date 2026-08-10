#!/usr/bin/env cwl-runner

$namespaces:
  edam: http://edamontology.org/

$schemas:
- https://edamontology.org/EDAM.owl

baseCommand:
- python3
- scripts/add_index.py
class: CommandLineTool
cwlVersion: v1.2

inputs:
- default:
    class: Directory
    location: ../../sbom
  id: sboms
  inputBinding:
    prefix: --sboms
  type: Directory
- default:
    class: File
    location: ../../index.sql
  format: edam:format_3788
  id: scheme
  inputBinding:
    prefix: --scheme
  type: File
- default: index.sqlite
  id: index
  inputBinding:
    prefix: --index
  type: string

outputs:
- format: edam:format_1926
  id: index_sqlite
  outputBinding:
    glob: $(inputs.index)
  type: File

requirements:
- class: InitialWorkDirRequirement
  listing:
  - entry:
      $include: ../../scripts/add_index.py
    entryname: scripts/add_index.py
- class: DockerRequirement
  dockerPull: python:3.12-slim
- class: InlineJavascriptRequirement
