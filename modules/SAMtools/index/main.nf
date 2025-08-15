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
        publishDir path: { META.containsKey("main_process") ?
        "${META.log_output_dir}/process-log/${META.main_process}" :
        "${META.log_output_dir}/process-log/SAMtools-${META.docker_image_version}"
        },
        pattern: ".command.*",
        mode: "copy",
        saveAs: { "${task.process.replace(':', '/')}/${META.id}/log${file(it).getName()}" }

    publishDir path: "${META.output_dir}",
        mode: "copy",
        pattern: "${alignment_file}.*"

    ext capture_logs: false

    input:
    tuple val(META), path(alignment_file)

    output:
    tuple val(META), path("${alignment_file}.*"), emit: index
    path(".command.*")

    script:
    """
    set -euo pipefail

    samtools index ${alignment_file}
    """
}
