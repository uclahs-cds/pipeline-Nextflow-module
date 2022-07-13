include { initOptions } from './functions.nf'

params.options = [:]
options = initOptions(params.options)

/*
    Nextflow module for index sequencing files, including: gff, bed, sam, vcf.

    input:
        sequencing file: path to files
    params:
        params.workflow_output_dir: string(path)
        params.workflow_output_dir: string(path)
        params.save_intermediate_files: bool.
*/

process index_VCF_tabix {
    container options.docker_image_samtools
    publishDir path: "${params.workflow_output_dir}/output",
               mode: "copy",
               pattern: "*.{tbi,csi}"
               enabled: !options.save_intermediate_files
    publishDir path: "${params.workflow_output_dir}/intermediate/${task.process.replace(':', '/')}",
               mode: "copy",
               pattern: "*.{tbi,csi}"
               enabled: options.save_intermediate_files
    publishDir path: "${params.workflow_output_log_dir}",
               mode: "copy",
               pattern: ".command.*",
               saveAs: { "${task.process.replace(':', '/')}/log${file(it).getName()}" }

    input:
    path file_to_index

    output:
    path "*.{tbi,csi}", emit: index
    path ".command.*"

    script:
    """
    set -euo pipefail
    tabix -p \$(basename $file_to_index .gz | tail -c 4) $file_to_index
    """
}
