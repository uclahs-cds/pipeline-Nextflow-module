include { initOptions } from './functions.nf'

params.options = [:]
options = initOptions(params.options)

/**
*   Nextflow module for validating files and directories
*
*   @input  file_to_validate    path    File or directory to validate
*
*   @params log_output_dir  path    Directory for saving log files
*   @params docker_image_version    string  Version of PipeVal image for validation
*   @params main_process    string  (Optional) Name of main output directory
*/
process run_validate_PipeVal {
    container options.docker_image
    label options.process_label

    publishDir path: { options.main_process ?
        "${options.log_output_dir}/process-log/${options.main_process}" :
        "${options.log_output_dir}/process-log/PipeVal-${options.docker_image_version}"
        },
        pattern: ".command.*",
        mode: "copy",
        saveAs: { "${task.process.split(':')[-1]}/${task.process.split(':')[-1]}-${task.index}/log${file(it).getName()}" }

    // This process uses the publishDir method to save the log files
    ext capture_logs: false

    input:
        path(file_to_validate)

    output:
        path(".command.*")
        path("validation.txt"), emit: validation_result
        path(file_to_validate), emit: validated_file

    script:
    """
    set -euo pipefail
    pipeval validate ${file_to_validate} ${options.validate_extra_args} > 'validation.txt'
    """
}
