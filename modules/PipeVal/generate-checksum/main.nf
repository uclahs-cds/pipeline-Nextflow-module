/**
*   Nextflow module for generating checksums
*
*   @input META val Dictionary of metadata for running process
*   @input  file_to_validate    path    File to generate checksum
*
*   @params output_dir  path    Directory for saving checksums
*   @params log_output_dir  path    Directory for saving log files
*   @params docker_image_version    string  Version of PipeVal image for validation
*   @params checksum_alg    string  (Optional) Select between 'sha512'(default) or 'md5'
*   @params main_process    string  (Optional) Name of main output directory
*/
process generate_checksum_PipeVal {
    container "${META.getOrDefault('docker_image', 'ghcr.io/uclahs-cds/pipeval:5.0.0-rc.3')}"

    label "${META.getOrDefault('process_label', 'none')}"

    publishDir path: "${META.log_output_dir}/process-log",
        pattern: ".command.*",
        mode: "copy",
        saveAs: { "${task.process.replace(':', '/')}/${task.process.split(':')[-1]}-${task.index}/log${file(it).getName()}" }

    publishDir path: "${META.output_dir}",
        pattern: "*.${checksum_alg}",
        mode: "copy"

    // This process uses the publishDir method to save the log files
    ext capture_logs: false

    input:
        tuple val(META), path(input_file)

    output:
        path(".command.*")
        tuple val(META), path("*.${checksum_alg}")

    script:
    checksum_alg = META.getOrDefault('checksum_alg', 'sha512')
    extra_args = META.getOrDefault('validate_extra_args', '')
    """
    set -euo pipefail

    if command -v pipeval &> /dev/null
    then
        pipeval generate-checksum -t ${checksum_alg} ${input_file} ${extra_args}
    else
        generate-checksum -t ${checksum_alg} ${input_file} ${extra_args}
    fi
    """
}
