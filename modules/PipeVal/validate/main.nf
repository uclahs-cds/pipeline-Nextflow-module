/**
*   Nextflow module for validating files and directories
*
*   @input META val Dictionary of metadata for running process
*   @input  file_to_validate    path    File or directory to validate
*
*   @params log_output_dir  path    Directory for saving log files
*   @params docker_image_version    string  Version of PipeVal image for validation
*   @params main_process    string  (Optional) Name of main output directory
*/
process run_validate_PipeVal {
    container "${META.getOrDefault('docker_image', 'ghcr.io/uclahs-cds/pipeval:5.0.0-rc.3')}"

    publishDir path: "${META.log_output_dir}/process-log",
        pattern: ".command.*",
        mode: "copy",
        saveAs: { "${task.process.replace(':', '/')}/${task.process.split(':')[-1]}-${task.index}/log${file(it).getName()}" }

    // This process uses the publishDir method to save the log files
    ext capture_logs: false

    input:
        tuple val(META), path(file_to_validate)

    output:
        path(".command.*")
        path("validation.txt"), emit: validation_result
        tuple val(META), path(file_to_validate), emit: validated_file

    script:
    extra_args = META.getOrDefault('validate_extra_args', '')
    """
    set -euo pipefail

    if command -v pipeval &> /dev/null
    then
        pipeval validate ${file_to_validate} ${extra_args} > 'validation.txt'
    else
        validate ${file_to_validate} ${extra_args} > 'validation.txt'
    fi
    """
}
