#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

requirements:
- class: InlineJavascriptRequirement
- class: ShellCommandRequirement

inputs:
- id: sboms
  type: File[]
- id: configs
  type: File[]

outputs:
- id: index
  type: Directory
  outputBinding:
    glob: sbom

baseCommand: []
arguments:
- valueFrom: |-
    ${
      var cmd = "mkdir -p sbom/sha256";
      if (inputs.sboms.length) {
        cmd += " && cp " + inputs.sboms.map(function(f){return "\"" + f.path + "\"";}).join(" ") + " sbom/sha256/ && gzip -9 -f sbom/sha256/*.json";
      }
      if (inputs.configs.length) {
        cmd += " && cp " + inputs.configs.map(function(f){return "\"" + f.path + "\"";}).join(" ") + " sbom/sha256/ && gzip -9 -f sbom/sha256/*.config.json";
      }
      return cmd;
    }
  shellQuote: false
