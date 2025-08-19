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
    container "${META.getOrDefault('docker_image', 'ghcr.io/uclahs-cds/bcftools:1.21')}"
    publishDir path: "${META.log_output_dir}",
        pattern: ".command.*",
        mode: "copy",
        saveAs: { "${task.process.replace(':', '/')}/${META.id}/log${file(it).getName()}" }

    publishDir path: "${META.output_dir}",
        mode: "copy",
        pattern: "*.vcf.gz"

    ext capture_logs: false

    input:
    tuple val(META), path(bcf_file), path(bcf_index)

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
