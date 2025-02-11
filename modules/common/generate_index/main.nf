include { initOptions } from './functions.nf'

params.options = [:]
options = initOptions(params.options)

/*
    Nextflow module generating index files

    input:
        alignment_file: a BAM or CRAM alignment file

    params:
        output_dir:  path    Directory for saving checksums
        log_output_dir:  path    Directory for saving log files
        docker_image_version:    string Version of SAMtools image
        main_process:    string  (Optional) Name of main output directory
*/

process run_index_SAMtools {
    container options.docker_image
        publishDir path: { options.main_process ?
        "${options.log_output_dir}/process-log/${options.main_process}" :
        "${options.log_output_dir}/process-log/SAMtools-${options.docker_image_version}"
        },
        pattern: ".command.*",
        mode: "copy",
        saveAs: { "${task.process.split(':')[-1]}/${task.process.split(':')[-1]}-${task.index}/log${file(it).getName()}" }

    publishDir path: "${options.output_dir}",
        mode: "copy",
        pattern: "${alignment_file}.*"

    ext capture_logs: false

    input:
    path(alignment_file)

    output:
    path("${alignment_file}.*"), emit: index
    path(".command.*")

    script:
    """
    set -euo pipefail

    samtools index ${alignment_file}
    """
}
