include { initOptions } from './functions.nf'

params.options = [:]
options = initOptions(params.options)

/*
    Nextflow module for index VCF files, including: gff and vcf.

    input:
        sequencing file: path to the VCF file
        id: string identifying the sample_id of the indexed VCF
    params:
        output_dir: string(path)
        log_output_dir: string(path)
        save_intermediate_files: bool.
*/

process index_VCF_tabix {
    container options.docker_image
    publishDir path: "${options.output_dir}/output",
               mode: "copy",
               pattern: "*.tbi",
               enabled: options.is_output_file
    publishDir path: "${options.output_dir}/intermediate/${task.process.replace(':', '/')}",
               mode: "copy",
               pattern: "*.tbi",
               enabled: !options.is_output_file && options.save_intermediate_files
    publishDir path: "${options.log_output_dir}",
               mode: "copy",
               pattern: ".command.*",
               saveAs: { "${task.process.replace(':', '/')}-${id}/log${file(it).getName()}" }

    input:
    tuple val(id), path(file_to_index)

    output:
    tuple val(id), path("*.tbi"), emit: index
    path ".command.*"

    script:
    """
    set -euo pipefail
    tabix ${options.extra_args} -p \$(basename $file_to_index .gz | tail -c 4) $file_to_index
    """
}