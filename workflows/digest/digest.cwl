#!/usr/bin/env cwl-runner

$namespaces:
  edam: http://edamontology.org/

$schemas:
- https://edamontology.org/EDAM.owl

baseCommand: .Digest
class: CommandLineTool
cwlVersion: v1.2

inputs:
- default:
    class: File
    location: ../../inspect.json
  format: edam:format_3464
  id: inspect_json
  inputBinding:
    position: 0
  type: File

outputs:
- id: digest
  outputBinding:
    glob: digest
  type: Directory

requirements:
- class: DockerRequirement
  dockerPull: ghcr.io/jqlang/jq:latest
stdout: digest
