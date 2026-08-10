#!/usr/bin/env cwl-runner

$namespaces:
  edam: http://edamontology.org/

$schemas:
- https://edamontology.org/EDAM.owl

baseCommand: scripts/add_index.py
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

outputs: []
requirements:
- class: InitialWorkDirRequirement
  listing:
  - entry:
      $include: ../../scripts/add_index.py
    entryname: scripts/add_index.py
- class: DockerRequirement
  dockerPull: python:3.12-slim
