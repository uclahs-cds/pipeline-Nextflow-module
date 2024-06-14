/*
 *  Utility functions for generating checksum 
 */


/*
 *  Function to initialize default values and to generate a Groovy Map of options used by the process
 */
def initOptions(Map args) {
    def Map options = [:]
    options.log_output_dir          = args.log_output_dir ?: params.log_output_dir
    options.docker_image_version    = args.docker_image_version ?: '5.0.0-rc.3'
    options.output_dir              = args.output_dir ?: params.output_dir
    options.docker_image            = "ghcr.io/uclahs-cds/pipeval:${options.docker_image_version}"
    options.process_label           = args.containsKey('process_label') ? args.process_label : 'none'
    options.main_process            = args.main_process ? args.main_process : ''
    options.checksum_alg            = args.checksum_alg ? args.checksum_alg : 'sha512'
    options.checksum_extra_args     = args.checksum_extra_args ?: ''
    return options
}
