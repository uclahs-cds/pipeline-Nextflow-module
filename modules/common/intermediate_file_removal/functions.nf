/*
 *  Utility functions for intermediate file removal
 */


/*
 *  Function to initialize default values and to generate a Groovy Map of options used by the process
 */
def initOptions(Map args) {
    def Map options = [:]
    options.output_dir              = args.output_dir ?: params.output_dir
    options.log_output_dir          = args.log_output_dir ?: params.log_output_dir
    options.save_intermediate_files = args.containsKey('save_intermediate_files') ? args.save_intermediate_files : true
    options.docker_image            = args.docker_image ?: 'blcdsdockerregistry/pipeval:2.1.6'
    options.process_label           = args.containsKey('process_label') ? args.process_label : 'none'
    return options
}
