/*
 *  Utility functions for intermediate file removal
 */


/*
 *  Function to initialize default values and to generate a Groovy Map of options used by the process
 */
def initOptions(Map args) {
    def Map options = [:]
    options.log_output_dir          = args.log_output_dir ?: params.log_output_dir
    options.docker_image_version    = args.docker_image_version ?: '4.0.0-rc.2'
    options.docker_image            = "ghcr.io/uclahs-cds/pipeval:${options.docker_image_version}"
    options.process_label           = args.containsKey('process_label') ? args.process_label : 'none'
    options.main_process            = args.main_process ? args.main_process : ''
    options.validate_extra_args     = args.validate_extra_args ?: ''
    return options
}
