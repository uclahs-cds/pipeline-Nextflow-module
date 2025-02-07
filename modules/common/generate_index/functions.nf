/*
 *  Function to initialize default values and to generate a Groovy Map of options used by the process
 */
def initOptions(Map args) {
    def Map options = [:]
    options.output_dir              = args.output_dir ?: params.output_dir
    options.log_output_dir          = args.log_output_dir ?: "${params.log_output_dir}/process-log"
    options.main_process            = args.main_process ?: ''
    options.docker_image_version    = args.docker_image_version ?: '1.21'
    options.docker_image            = args.docker_image ?: "ghcr.io/uclahs-cds/samtools:${options.docker_image_version}"
    return options
}