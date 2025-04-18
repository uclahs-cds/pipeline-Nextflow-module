include { initOptions } from './functions.nf'

params.options = [:]
options = initOptions(params.options)

/**
*   Nextflow module for generating checksums
*
*   @input  file_to_validate    path    File to generate checksum
*
*   @params output_dir  path    Directory for saving checksums
*   @params log_output_dir  path    Directory for saving log files
*   @params docker_image_version    string  Version of PipeVal image for validation
*   @params checksum_alg    string  (Optional) Select between 'sha512'(default) or 'md5'
*   @params main_process    string  (Optional) Name of main output directory
*/
process generate_checksum_PipeVal {
    container options.docker_image
    label options.process_label

    publishDir path: { options.main_process ?
        "${options.log_output_dir}/process-log/${options.main_process}" :
        "${options.log_output_dir}/process-log/PipeVal-${options.docker_image_version}"
        },
        pattern: ".command.*",
        mode: "copy",
        saveAs: { "${task.process.replace(':', '/')}/${task.process.split(':')[-1]}-${task.index}/log${file(it).getName()}" }

    publishDir path: "${options.output_dir}",
        pattern: "*.${options.checksum_alg}",
        mode: "copy"

    // This process uses the publishDir method to save the log files
    ext capture_logs: false

    input:
        path(input_file)

    output:
        path(".command.*")
        path("*.${options.checksum_alg}")

    script:
    """
    set -euo pipefail

    if command -v pipeval &> /dev/null
    then
        pipeval generate-checksum -t ${options.checksum_alg} ${input_file} ${options.checksum_extra_args}
    else
        generate-checksum -t ${options.checksum_alg} ${input_file} ${options.checksum_extra_args}
    fi
    """
}
