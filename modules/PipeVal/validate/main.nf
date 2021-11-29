include { initOptions } from './functions.nf'

params.options = [:]
options = initOptions(params.options)

/*
    Nextflow module for validating files and directories

    input:
        mode: string identifying type of validation
        file_to_validate: path to file to validate
        
    params:
        params.log_output_dir: string(path)
        params.docker_image_version: string
*/
process run_validate_PipeVal {
    container options.docker_image
    label options.process_label

    publishDir path: "${options.log_output_dir}/process-log/PipeVal-${options.docker_image_version}",
        pattern: ".command.*",
        mode: "copy",
        saveAs: { "${task.process.replace(':','/')}-${task.index}/log${file(it).getName()}" }

    input:
        tuple val(mode), path(file_to_validate)

    output:
        path(".command.*")
        path("input_validation.txt"), emit: val_file

    script:
    """
    set -euo pipefail
    python3 -m validate -t ${mode} ${file_to_validate} > 'input_validation.txt'
    """
}