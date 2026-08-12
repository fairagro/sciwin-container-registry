#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool
$namespaces:
  edam: http://edamontology.org/

requirements:
- class: InlineJavascriptRequirement
- class: DockerRequirement
  dockerPull: anchore/syft
- class: NetworkAccess
  networkAccess: true

inputs:
- id: image
  type: string
  inputBinding:
    position: 0
- id: output_format
  type: string
  default: json
  inputBinding:
    prefix: -o
- id: digest
  type: string

outputs:
- id: output
  type: File?
  outputBinding:
    glob: $(inputs.digest.split(":")[1]).json
    outputEval: |
      ${
        if (self.length === 0 || self[0].size === 0) {
          return null;
        }
        return self[0];
      }
stdout: $(inputs.digest.split(":")[1]).json

successCodes:
- 0
- 1
- 137 # ignore mem

baseCommand: []
$schemas:
- https://edamontology.org/EDAM.owl
