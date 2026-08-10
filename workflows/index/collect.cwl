#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

requirements:
- class: InlineJavascriptRequirement
- class: InitialWorkDirRequirement
  listing: |
    $([{
      class: "Directory",
      basename: "sbom/sha256",
      listing: inputs.sboms
    }])

inputs:
- id: sboms
  type: File[]

outputs:
- id: index
  type: Directory
  outputBinding:
    glob: sbom

baseCommand: 'true'
