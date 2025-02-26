include { initOptions } from './functions.nf'

params.options = [:]
options = initOptions(params.options)

/*
    Nextflow module for extracting genome intervals from reference dictionary

    input:
        reference_dict: path to .dict associated with reference genome

    params:
        params.output_dir: string(path)
        params.log_output_dir: string(path)
        params.save_intermediate_files: bool.
*/
process extract_GenomeIntervals {
    container options.docker_image
    label options.process_label

    publishDir path: "${options.output_dir}/intermediate/${task.process.replace(':', '/')}",
               mode: "copy",
               pattern: "genomic_intervals.list",
               enabled: options.save_intermediate_files
    publishDir path: "${options.log_output_dir}/process-log",
               mode: "copy",
               pattern: ".command.*",
               saveAs: { "${task.process.replace(':', '/').replace('_', '-')}/log${file(it).getName()}" }

    // This process uses the publishDir method to save the log files
    ext capture_logs: false

    input:
    path(reference_dict)

    output:
    path("genomic_intervals.list"), emit: genomic_intervals
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
