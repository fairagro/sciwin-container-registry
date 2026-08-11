#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

requirements:
- class: InitialWorkDirRequirement
  listing:
  - entryname: scripts/check_index.py
    entry:
      $include: ../../scripts/check_index.py
- class: DockerRequirement
  dockerPull: python:3.12-slim
- class: InlineJavascriptRequirement

inputs:
- id: index
  type: File?
  inputBinding:
    prefix: --index
- id: digest
  type: string
  inputBinding:
    prefix: --digest

outputs:
- id: exists
  type: boolean
  outputBinding:
    glob: exists.txt
    loadContents: true
    outputEval: $(self[0].contents.trim() === "true")

stdout: exists.txt

baseCommand:
- python3
- scripts/check_index.py
