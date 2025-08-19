/*
    Nextflow module for extracting genome intervals from reference dictionary

    input:
        META: dictionary of metadata for running process
        reference_dict: path to .dict associated with reference genome

    params:
        params.output_dir: string(path)
        params.log_output_dir: string(path)
        params.save_intermediate_files: bool.
*/
process extract_GenomeIntervals {
    container "${META.getOrDefault('docker_image', 'ghcr.io/uclahs-cds/pipeval:5.0.0-rc.3')}"

    // label "${META.getOrDefault('process_label', 'none')}"

    publishDir path: "${META.output_dir}/intermediate/${task.process.replace(':', '/')}",
        mode: "copy",
        pattern: "genomic_intervals.list",
        enabled: params.getOrDefault('save_intermediate_files', false)
    publishDir path: "${META.log_output_dir}/process-log",
        mode: "copy",
        pattern: ".command.*",
        saveAs: { "${task.process.replace(':', '/')}/log${file(it).getName()}" }

    // This process uses the publishDir method to save the log files
    ext capture_logs: false

    input:
    tuple val(META), path(reference_dict)

    output:
    tuple val(META), path("genomic_intervals.list"), emit: genomic_intervals
    path(".command.*")

    script:
    """
    set -euo pipefail
    grep -e "^@SQ" ${reference_dict} | \
    cut -f 2 | \
    sed -e 's/SN://g' \
    > genomic_intervals.list
    """
}
