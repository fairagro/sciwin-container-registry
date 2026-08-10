#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool
$namespaces:
  edam: http://edamontology.org/

requirements:
- class: InlineJavascriptRequirement
- class: DockerRequirement
  dockerPull: ghcr.io/jqlang/jq:latest

inputs:
- id: raw
  type: boolean
  default: true
  inputBinding:
    prefix: -r
- id: selector
  type: string
  default: .Digest
  inputBinding:
    position: 0
- id: inspect_json
  type: File
  format: edam:format_3464
  inputBinding:
    position: 1

outputs:
- id: digest
  type: string
  outputBinding:
    glob: digest
    loadContents: true
    outputEval: $(self[0].contents.trim())
stdout: digest

baseCommand: []
$schemas:
- https://edamontology.org/EDAM.owl
