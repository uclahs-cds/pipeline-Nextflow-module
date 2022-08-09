/*
 *  Utility functions for intermediate file removal
 */


/*
 *  Function to initialize default values and to generate a Groovy Map of options used by the process
 */
def initOptions(Map args) {
    def Map options = [:]
    options.log_output_dir          = args.log_output_dir ?: params.log_output_dir
    options.docker_image_version    = args.docker_image_version ?: '3.0.0'
    options.docker_image            = "blcdsdockerregistry/pipeval:${options.docker_image_version}"
    options.process_label           = args.containsKey('process_label') ? args.process_label : 'none'
    options.main_process            = args.main_process ? args.main_process : ''
    return options
}
