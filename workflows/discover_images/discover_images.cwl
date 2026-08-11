#!/usr/bin/env cwl-runner


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

outputs: []
requirements:
- class: InitialWorkDirRequirement
  listing:
  - entry:
      $include: ../../scripts/discover_images.py
    entryname: scripts/discover_images.py
- class: DockerRequirement
  dockerPull: python:3.12-slim
- class: NetworkAccess
  networkAccess: true
