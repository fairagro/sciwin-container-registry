#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool
$namespaces:
  edam: http://edamontology.org/

requirements:
- class: InlineJavascriptRequirement
- class: InitialWorkDirRequirement
  listing:
  - entryname: scripts/discover_images.py
    entry:
      $include: ../../scripts/discover_images.py
- class: DockerRequirement
  dockerFile:
    $include: ../../Dockerfile
  dockerImageId: sciwin-container
- class: NetworkAccess
  networkAccess: true

inputs:
- id: namespaces
  type: string[]
  inputBinding:
    prefix: --namespaces

outputs:
- id: images
  type: string[]
  outputBinding:
    glob: images.json
    loadContents: true
    outputEval: $(JSON.parse(self[0].contents))

baseCommand:
- python3
- scripts/discover_images.py
$schemas:
- https://edamontology.org/EDAM.owl
