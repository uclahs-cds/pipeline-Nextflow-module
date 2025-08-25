/*
    Nextflow module for checking if file is bgzip compressed.

    input:
        file_to_check: path to the file
        id: string identifying the sample_id of the file
    params:
        log_output_dir: string(path)
*/

process check_compression_bgzip {
    container "${META.getOrDefault('docker_image', 'ghcr.io/uclahs-cds/samtools:1.21')}"
    publishDir path: "${META.log_output_dir}",
               mode: "copy",
               pattern: ".command.*",
               saveAs: { "${task.process.replace(':', '/')}/${META.id}/log${file(it).getName()}" }

    // This process uses the publishDir method to save the log files
    ext capture_logs: false

    input:
    tuple val(META), path(file_to_check)

    output:
    tuple val(META), path(file_to_check), env(IS_COMPRESSED), emit: checked_files
    path ".command.*"

    shell '/bin/bash', '-uo', 'pipefail'

    script:
    """
    IS_COMPRESSED='true'

    bgzip -t ${file_to_check}

    if [ "\$?" -ne 0 ]
    then
        IS_COMPRESSED='false'
    fi
    """
}

/*
    Nextflow module for uncompressing bgzip-ed file.

    input:
        file_to_uncompress: path to the file
        id: string identifying the sample_id of the file
    params:
        log_output_dir: string(path)
*/

process uncompress_file_gunzip {
    container "${META.getOrDefault('docker_image', 'ghcr.io/uclahs-cds/samtools:1.21')}"
    publishDir path: "${META.log_output_dir}",
               mode: "copy",
               pattern: ".command.*",
               saveAs: { "${task.process.replace(':', '/')}/${META.id}/log${file(it).getName()}" }

    // This process uses the publishDir method to save the log files
    ext capture_logs: false

    input:
    tuple val(META), path(file_to_uncompress)

    output:
    tuple val(META), path(uncompressed_file), emit: uncompressed_files
    path ".command.*"

    script:
    filename = file(file_to_uncompress).getName()
    uncompressed_file = filename.lastIndexOf('.').with{ it != -1 ? filename[0..<it] : filename }
    """
    set -euo pipefail
    gunzip -c ${file_to_uncompress} > ${uncompressed_file}
    """
}

/*
    Nextflow module for compressing VCF files, including: gff and vcf.

    input:
        file_to_compress: path to the VCF file
        id: string identifying the sample_id of the VCF
    params:
        output_dir: string(path)
        log_output_dir: string(path)
        save_intermediate_files: bool.
        bgzip_extra_args: string(extra options for bgzip)
*/
process compress_VCF_bgzip {
    container "${META.getOrDefault('docker_image', 'ghcr.io/uclahs-cds/samtools:1.21')}"

    publishDir path: "${
            META.getOrDefault('is_output_file', true)
            ? META.output_dir + "/output"
            : META.output_dir + "/intermediate/" + task.process.replace(':', '/')
        }",
        mode: "copy",
        enabled: "${META.getOrDefault('is_output_file', true) || META.getOrDefault('save_intermediate_files', false) }",
        pattern: "*.gz"

    publishDir path: "${META.log_output_dir}",
               mode: "copy",
               pattern: ".command.*",
               saveAs: { "${task.process.replace(':', '/')}/${META.id}/log${file(it).getName()}" }

    // This process uses the publishDir method to save the log files
    ext capture_logs: false

    input:
    tuple val(META), path(file_to_compress)

    output:
    tuple val(META), path("*.gz") , emit: vcf_gz
    path("*.gz{OUTPUT,INTERMEDIATE}"), optional: true
    path ".command.*"

    script:
    """
    set -euo pipefail
    bgzip ${META.getOrDefault('bgzip_extra_args', ''} ${file_to_compress}
    """
}

/*
    Nextflow module for index VCF files, including: gff and vcf.

    input:
        file_to_index: path to the VCF file
        id: string identifying the sample_id of the indexed VCF
    params:
        output_dir: string(path)
        log_output_dir: string(path)
        save_intermediate_files: bool.
        tabix_extra_args: string(extra options used to index VCF)
*/
process index_VCF_tabix {
    container "${META.getOrDefault('docker_image', 'ghcr.io/uclahs-cds/samtools:1.21')}"

    publishDir path: "${
            META.getOrDefault('is_output_file', true)
            ? META.output_dir + "/output"
            : META.output_dir + "/intermediate/" + task.process.replace(':', '/')
        }",
        mode: "copy",
        enabled: "${META.getOrDefault('is_output_file', true) || META.getOrDefault('save_intermediate_files', false) }",
        pattern: "*.{tbi,csi}"

    publishDir path: "${META.log_output_dir}",
               mode: "copy",
               pattern: ".command.*",
               saveAs: { "${task.process.replace(':', '/')}/${META.id}/log${file(it).getName()}" }
    
    // This process uses the publishDir method to save the log files
    ext capture_logs: false

    input:
    tuple val(META), path(file_to_index)

    output:
    tuple val(META), path(file_to_index), path("*.{tbi,csi}"), emit: index_out
    path("*{OUTPUT,INTERMEDIATE}"), optional: true
    path ".command.*"

    script:
    is_output_file = META.getOrDefault('is_output_file', true)
    save_as_intermediate = !is_output_file && params.getOrDefault('save_intermediate_files', false)
    """
    set -euo pipefail
    tabix ${META.getOrDefault('tabix_extra_args', ''} -p \$(basename $file_to_index .gz | tail -c 4) $file_to_index
    """
}
