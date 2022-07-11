/*
 *  Utility functions for intermediate file removal
 */


/*
 *  Function to initialize default values and to generate a Groovy Map of options used by the process
 */
def initOptions(Map args) {
    def Map options = [:]
    options.log_output_dir          = args.containsKey('output_log_dir') ? params.output_log_dir : params.log_output_dir
    options.workflow_output_dir     = args.containsKey('workflow_output_dir') ? options.workflow_output_dir: params.output_dir
    options.workflow_log_output_dir = args.containsKey('workflow_log_output_dir') ? options.workflow_log_output_dir: params.log_output_dir
    options.docker_image            = args.docker_image ?: 'blcdsdockerregistry/samtools:1.15.1'
    options.process_label           = args.containsKey('process_label') ? args.process_label : 'none'
    return options
}
