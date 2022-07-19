# Nextflow Modules


- [Overview](#overview)
- [Available Modules](#available-modules)
  - [Intermediate file removal](#intermediate-file-removal)
  - [Genomic interval extraction](#genomic-interval-extraction)
  - [Standardized Filename Generator](#standardized-filename-generator)
  - [PipeVal](#pipeval)
    - [Validate](#validate)
- [License](#License)


## Overview

A set of Nextflow modules commonly used across pipelines.

## Available Modules

### Intermediate file removal

#### Description

Module for deleting intermediate files from disk as they're no longer needed by downstream processes. Symbolic links are followed to the actual file and both are deleted.

Tools used: GNU `rm` and `readlink`.

Inputs:
  - `file_to_remove`: path to file to be deleted
  - `ready_for_deletion_signal`: val to indicate that file is no longer needed by any processes

Parameters:
  - `output_dir`: directory for storing outputs
  - `log_output_dir`: directory for storing log files
  - `save_intermediate_files`: boolean indicating whether this process should run (disable when intermediate files need to be kept)
  - `docker_image`: docker image within which process will run. The default is: `blcdsdockerregistry/pipeval:2.1.6`
  - `process_label`: assign Nextflow process label to process to control resource allocation. For specific CPU and memory allocation, include static allocations in node-specific config files

#### How to use

1. Add this repository as a submodule in the pipeline of interest
2. Include the `remove_intermediate_files` process from the module `main.nf` with a relative path
3. Use the `addParams` directive when importing to specify any params
4. Call the process with the inputs where needed

### Genomic interval extraction

#### Description

Module for extracting the genome intervals from a reference genome dictionary.

Tools used: GNU `grep`, `cut`, and `sed`.

Inputs:
  - reference_dict: path to reference genome dictionary

Parameters:
  - `output_dir`: directory for storing outputs
  - `log_output_dir`: directory for storing log files
  - `save_intermediate_files`: boolean indicating whether the extracted intervals should be copied to the output directory
  - `docker_image`: docker image within which process will run. The default is: `blcdsdockerregistry/pipeval:2.1.6`
  - `process_label`: assign Nextflow process label to process to control resource allocation. For specific CPU and memory allocation, include static allocations in node-specific config files

#### How to use

1. Add this repository as a submodule in the pipeline of interest
2. Include the `extract_GenomeIntervals` process from the module `main.nf` with a relative path
3. Use the `addParams` directive when importing to specify any params
4. Call the process with the inputs where needed

### Standardized Filename Generator

#### Description

Module containing function to take components of a filename and combine them in a standardized format, returned as a string.

Tools used: Groovy functions

Inputs:
  - `main_tool`: string containing name and version of main tool used for generating file
  - `dataset_id`: string identifying dataset the file belongs to
  - `sample_id`: string identifying the same contained in the file
  - `additional_args`: Map containing additional optional arguments. Available args:
    - `additional_tools`: list of strings identifying any additional tools to include in filename
    - `additional_information`: string containing any additional information to be included at the end of the filename

Outputs:
  - String representing the standardized filename

#### Hot to use

1. Add this repository as a submodule in the pipeline of interest
2. Include the `generate_standard_filename` function from the module `main.nf` with a relative path in any Nextflow file requiring use of the function
3. Call the function as needed with the approriate inputs and use returned value to set file names

### PipeVal

#### Validate

##### Description

Module for validating files and directories using PipeVal

Tools used: `PipeVal`.

Inputs:
  - `mode`: string identifying type of validation
  - `file_to_validate`: path for file or directory to validate

Parameters:
  - `log_output_dir`: directory for storing log files
  - `docker_image_version`: PipeVal docker image version within which process will run. The default is: `2.1.6`
  - `process_label`: assign Nextflow process label to process to control resource allocation. For specific CPU and memory allocation, include static allocations in node-specific config files
  - `main_process`: Set output directory to the specified main process instead of `PipeVal-2.1.6 `

##### How to use

1. Add this repository as a submodule in the pipeline of interest
2. Include the `run_validate_PipeVal` process from the module `main.nf` with a relative path
3. Use the `addParams` directive when importing to specify any params
4. Call the process with the inputs where needed
5. Aggregate and save the output validation files as needed


## License

Author: Yash Patel (YashPatel@mednet.ucla.edu)

pipeline-Nextflow-module is licensed under the GNU General Public License version 2. See the file LICENSE for the terms of the GNU GPL license.

pipeline-Nextflow-module comprises a set of commonly used Nextflow modules.

Copyright (C) 2021 University of California Los Angeles ("Boutros Lab") All rights reserved.

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
