# Nextflow Modules


- [Nextflow Modules](#nextflow-modules)
  - [Overview](#overview)
  - [Available Modules](#available-modules)
    - [Intermediate file removal](#intermediate-file-removal)
      - [Description](#description)
      - [How to use](#how-to-use)
    - [Genomic interval extraction](#genomic-interval-extraction)
      - [Description](#description-1)
      - [How to use](#how-to-use-1)
    - [Standardized Filename Generator](#standardized-filename-generator)
      - [Description](#description-2)
      - [How to use](#how-to-use-2)
    - [PipeVal](#pipeval)
      - [Validate](#validate)
        - [Description](#description-3)
        - [How to use](#how-to-use-3)
      - [generate-checksum](#generate-checksum)
        - [Description](#description-4)
        - [How to use](#how-to-use-4)
    - [Compress and Index VCF File](#compress-and-index-vcf-file)
        - [Description](#description-5)
        - [How to use](#how-to-use-5)
    - [Return Expected Index File](#return-expected-index-file)
        - [Description](#description-6)
        - [How to use](#how-to-use-6)
    - [SAMtools](#samtools)
      - [CRAM2BAM](#cram2bam)
        - [Description](#description-7)
        - [How to use](#how-to-use-7)
  - [License](#license)


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
  - `docker_image`: docker image within which process will run. The default is: `ghcr.io/uclahs-cds/pipeval:3.0.0`
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
  - `docker_image`: docker image within which process will run. The default is: `ghcr.io/uclahs-cds/pipeval:3.0.0`
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

Additional functions:
  - `sanitize_string` - Pass input string to sanitize, keeping only alphanumeric, `-`, `/`, and `.` characters and replacing `_` with `-`
    - Inputs:
      - `raw`: string to sanitize

Outputs:
  - String representing the standardized filename

#### How to use

1. Add this repository as a submodule in the pipeline of interest
2. Include the `generate_standard_filename` and any additional necessary functions from the module `main.nf` with a relative path in any Nextflow file requiring use of the function
3. Call the functions as needed with the approriate inputs and use returned value to set file names

### PipeVal

#### Validate

##### Description

Module for validating files and directories using PipeVal

Tools used: `PipeVal`.

Inputs:
  - `file_to_validate`: path for file or directory to validate

Parameters:
  - `log_output_dir`: directory for storing log files
  - `docker_image_version`: PipeVal docker image version within which process will run. The default is: `4.0.0-rc.2`
  - `process_label`: assign Nextflow process label to process to control resource allocation. For specific CPU and memory allocation, include static allocations in node-specific config files
  - `main_process`: Set output directory to the specified main process instead of `PipeVal-4.0.0-rc.2`

##### How to use

1. Add this repository as a submodule in the pipeline of interest
2. Include the `run_validate_PipeVal` process from the module `main.nf` with a relative path
3. Use the `addParams` directive when importing to specify any params
4. Call the process with the inputs where needed
5. Aggregate and save the output validation files as needed

#### generate-checksum

##### Description

Module for generating checksums for files using PipeVal

Tools used: `PipeVal`.

Inputs:
  - `input_file`: path for file to generate a checksum

Parameters:
  - `output_dir`: directory for storing checksums
  - `log_output_dir`: directory for storing log files
  - `docker_image_version`: PipeVal docker image version within which process will run. The default is: `4.0.0-rc.2`
  - `process_label`: assign Nextflow process label to process to control resource allocation. For specific CPU and memory allocation, include static allocations in node-specific config files
  - `main_process`: Set output directory to the specified main process instead of `PipeVal-4.0.0-rc.2`
  - `checksum_alg`: Type of checksum to generate. Choices: `sha512`(default), `md5`

##### How to use

1. Add this repository as a submodule in the pipeline of interest
2. Include the `generate_checksum_PipeVal` process from the module `main.nf` with a relative path
3. Use the `addParams` directive when importing to specify any params
4. Call the process with the inputs where needed

### Compress and Index VCF File
##### Description
Module for compressing and indexing VCF/GFF files, the input should be compressed or uncompressed *.vcf or *.gff files.

Tools used: `tabix`, `bgzip`.

Inputs:
  - id: string identifying the `id` of the indexed VCF. For more than one VCFs, the `id` should be unique for each sample.
  - file_to_index: path for VCF file to compress and index.

Parameters:
  - output_dir: directory to store compressed VCF and index files.
  - log_output_dir: directory to store log files.
  - docker_image: SAMtools docker image version within which process will run. The default is: `1.15.1`
  - process_label: assign Nextflow process label to process to control resource allocation. For specific CPU and memory allocation, include static allocations in node-specific config files
  - is_output_file: determine the output of this process should be saved to `output` or `intermediate` folder. For `intermediate` process, using `addParams` to specify `is_output_file: false`. The default is `true`.
  - save_intermediate_files: whether the index files should be saved to the intermediate output directory.
  - unzip_and_rezip: whether compressed files should be uncompressed and re-compressed using `bgzip`. The default is `false`.

##### How to use
1. Add this repository as a submodule in the pipeline of interest.
2. Include the `compress_index_VCF` workflow from the module `main.nf` with a relative path.
3. Use the `addParams` directive when importing to specify any params.
4. Call the process with the input channel, a tuple with `id` and `file_path`.

### Return Expected Index File
##### Description
Module returns the expected path to the index file for a given input file.
NOTE! This does not check for the existence of the index file.

Inputs:
 - input_file: currently supports BAM or VCF

Output:
 - The input file path with the expected index extension appended: currently `.bai` for BAM files and `.tbi` for VCF files

##### How to use
1. Add this repository as a submodule in the pipeline of interest.
2. Include the `indexFile` function from the module `main.nf` with a relative path.
3. Call the function as needed with the approriate input and use returned value as index file name

### SAMtools

#### CRAM2BAM

##### Description

Module for converting from CRAM to BAM format.

Tools used: `samtools view`.

Inputs:
  - `tuple(sample_name, path/to/sample/CRAM)`: name and path to CRAM sample
  - `path/to/reference/genome`: path to the reference genome

Outputs:
  - `tuple(sample_name, path/to/sample/CRAM)`: name and path to converted BAM sample

Parameters:
  - `docker_image_samtools`: docker image for running SAMtools. default: `"ghcr.io/uclahs-cds/samtools:1.20"`
  - `intermediate_output_dir`: directory for intermediate outputs.
  - `save_intermediate_files`: when true will save intermediate files.
  - `process_log_output_dir`: directory for storing process log.
  - `extra_args`: optional extra arguments for `samtools view` command.

##### How to use

1. Add this repository as a submodule in the pipeline of interest
2. Include the `convert_cram2bam_SAMtools` process from the module `main.nf` with a relative path
3. Use the `addParams` directive when importing to specify any params
4. Call the process with the inputs where needed

## License

Author: Yash Patel (YashPatel@mednet.ucla.edu)

pipeline-Nextflow-module is licensed under the GNU General Public License version 2. See the file LICENSE for the terms of the GNU GPL license.

pipeline-Nextflow-module comprises a set of commonly used Nextflow modules.

Copyright (C) 2021 University of California Los Angeles ("Boutros Lab") All rights reserved.

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
