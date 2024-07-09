include { initOptions } from './functions.nf'

params.options = [:]
options = initOptions(params.options)

/*
*/

process convert_cram2bam_SAMtools {
    container options.docker_image_samtools

    publishDir path: "${options.intermediate_output_dir}/${task.process.split(':')[-1].replace('_', '-')}",
        enabled: options.save_intermediate_files,
        pattern: "*.bam",
        mode: 'copy'

    publishDir path: "${options.process_log_output_dir}/${task.process.split(':')[-1].replace('_', '-')}",
        pattern: ".command.*",
        mode: "copy",
        saveAs: { "log${file(it).getName()}" }

    input:
        tuple( val(sample_name), path(sample_cram) )
        path( reference_genome )


    output:
        tuple val(sample_name), path("uncrammed_${sample.baseName}.bam"), emit: bam
        file ".command.*"


    script:
    """
    samtools \
            view \
            -b \
            --threads ${task.cpus} \
            -T ${reference_genome} \
            -o "uncrammed_${sample.baseName}.bam" \
            ${options.extra_args} \
            ${sample}
    """
}
