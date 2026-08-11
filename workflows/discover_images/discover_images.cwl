#!/usr/bin/env cwl-runner

$namespaces:
  edam: http://edamontology.org/

$schemas:
- https://edamontology.org/EDAM.owl

baseCommand:
- python3
- scripts/discover_images.py
class: CommandLineTool
cwlVersion: v1.2

inputs:
- default: atlassian
  id: namespaces
  inputBinding:
    prefix: --namespaces
  type: string
- default: sciwin
  id: sciwin
  inputBinding:
    position: 2
  type: string
- default: geosolutions
  id: geosolutions
  inputBinding:
    position: 3
  type: string

outputs:
- format: edam:format_3464
  id: images_json
  outputBinding:
    glob: images.json
  type: File

requirements:
- class: InitialWorkDirRequirement
  listing:
  - entry:
      $include: ../../scripts/discover_images.py
    entryname: scripts/discover_images.py
- class: DockerRequirement
  dockerFile:
    $include: ../../Dockerfile
  dockerImageId: sciwin-container
- class: NetworkAccess
  networkAccess: true
