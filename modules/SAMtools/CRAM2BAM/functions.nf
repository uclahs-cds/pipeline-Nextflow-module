/*
 *  Utility functions for cram2bam_SAMtools
 */


/*
 *  Function to initialize default values and to generate a Groovy Map of options used by the process
 */
def initOptions(Map args) {
    def Map options = [:]
    options.docker_image_samtools = args.docker_image_samtools ?: "ghcr.io/uclahs-cds/samtools:1.20"
    options.intermediate_output_dir = args.intermediate_output_dir ?: params.intermediate_output_dir
    options.save_intermediate_files = args.containsKey('save_intermediate_files') ? args.save_intermediate_files : true
    options.process_log_output_dir = args.process_log_output_dir ?: params.process_log_output_dir
    options.extra_args = args.extra_args ?: ''
    return options
}
