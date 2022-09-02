include { initOptions } from './functions.nf'

params.options = [:]
options = initOptions(params.options)

/*
    Nextflow module for index VCF files, including: gff and vcf.

    input:
        file_to_compress/index: path to the VCF file
        id: string identifying the sample_id of the indexed VCF
    params:
        output_dir: string(path)
        log_output_dir: string(path)
        save_intermediate_files: bool.
*/

process compress_VCF_bgzip {
    container options.docker_image
    publishDir path: "${options.output_dir}/output",
               mode: "copy",
               pattern: "*.gz",
               enabled: options.is_output_file
    publishDir path: "${options.output_dir}/intermediate/${task.process.replace(':', '/')}",
               mode: "copy",
               pattern: "*.gz",
               enabled: !options.is_output_file && options.save_intermediate_files
    publishDir path: "${options.log_output_dir}",
               mode: "copy",
               pattern: ".command.*",
               saveAs: { "${task.process.replace(':', '/')}-${id}/log${file(it).getName()}" }

    input:
    tuple val(id), path(file_to_compress)

    output:
    tuple val(id), path("*.gz") , emit: vcf_gz
    path ".command.*"

    script:
    """
    set -euo pipefail
    bgzip ${options.bgzip_extra_args} ${file_to_compress}
    """
}


process index_VCF_tabix {
    container options.docker_image
    publishDir path: "${options.output_dir}/output",
               mode: "copy",
               pattern: "*.{tbi,csi}",
               enabled: options.is_output_file
    publishDir path: "${options.output_dir}/intermediate/${task.process.replace(':', '/')}",
               mode: "copy",
               pattern: "*.{tbi,csi}",
               enabled: !options.is_output_file && options.save_intermediate_files
    publishDir path: "${options.log_output_dir}",
               mode: "copy",
               pattern: ".command.*",
               saveAs: { "${task.process.replace(':', '/')}-${id}/log${file(it).getName()}" }

    input:
    tuple val(id), path(file_to_index)

    output:
    tuple val(id), path("*.{tbi,csi}"), emit: index
    tuple val(id), path(file_to_index), path("*.{tbi,csi}"), emit: index_out
    path ".command.*"

    script:
    """
    set -euo pipefail
    tabix ${options.tabix_extra_args} -p \$(basename $file_to_index .gz | tail -c 4) $file_to_index
    """
}
