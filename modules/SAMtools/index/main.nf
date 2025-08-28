/*
    Nextflow module generating index files

    input:
        META: dictionary of metadata for running process; any given metadata will be treated as immutable and passed through the process
            Available key definitions:
                docker_image (optional): String
                log_output_dir (required): String
                output_dir (required): String
                id (required): String
        alignment_file: a BAM or CRAM alignment file

    params:
        output_dir:  path    Directory for saving checksums
        log_output_dir:  path    Directory for saving log files
        docker_image_version:    string Version of SAMtools image
        main_process:    string  (Optional) Name of main output directory
*/

process run_index_SAMtools {
    container "${META.getOrDefault('docker_image', 'ghcr.io/uclahs-cds/samtools:1.21')}"
    publishDir path: "${META.log_output_dir}/process-log",
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
