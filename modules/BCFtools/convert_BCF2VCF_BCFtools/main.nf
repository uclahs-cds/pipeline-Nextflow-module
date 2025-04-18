include { initOptions } from './functions.nf'

params.options = [:]
options = initOptions(params.options)

/*
    Nextflow module converting a BCF to a VCF file

    input:
        bcf_file: a BCF file

    params:
        output_dir:  path    Directory for saving VCF
        log_output_dir:  path    Directory for saving log files
        docker_image_version:    string Version of BCFtools image
*/

process convert_BCF2VCF_BCFtools {
    container options.docker_image
        publishDir path: "${options.log_output_dir}",
        pattern: ".command.*",
        mode: "copy",
        saveAs: { "${task.process.replace(':', '/')}/${sample}/log${file(it).getName()}" }

    publishDir path: "${options.output_dir}",
        mode: "copy",
        pattern: "*.vcf.gz"

    ext capture_logs: false

    input:
    tuple val(sample), path(bcf_file), path(bcf_index)

    output:
    path("*.vcf.gz"), emit: vcf
    path(".command.*")

    script:
    """
    set -euo pipefail

    bcf_file_base=\$(basename ${bcf_file} .bcf)
    vcf_file=\${bcf_file_base}.vcf.gz

    bcftools view ${bcf_file} -Oz -o \${vcf_file}
    """
    }
