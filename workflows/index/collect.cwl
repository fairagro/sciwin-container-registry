#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

requirements:
- class: InlineJavascriptRequirement
- class: ShellCommandRequirement

inputs:
- id: sboms
  type: File[]

outputs:
- id: index
  type: Directory
  outputBinding:
    glob: sbom

baseCommand: []
arguments:
- valueFrom: |-
    mkdir -p sbom/sha256$(inputs.sboms.length ? " && cp " + inputs.sboms.map(function(f){return "\"" + f.path + "\""}).join(" ") + " sbom/sha256/" : "")
  shellQuote: false
