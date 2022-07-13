/*
 *  Utility functions for intermediate file removal
 */


/*
 *  Function to initialize default values and to generate a Groovy Map of options used by the process
 */
def initOptions(Map args) {
    def Map options = [:]
    options.workflow_output_dir     = args.containsKey('workflow_output_dir') ? args.workflow_output_dir: args.output_dir
    options.workflow_log_output_dir = args.containsKey('workflow_log_output_dir') ? args.workflow_log_output_dir: args.log_output_dir
    options.docker_image            = args.docker_image ?: 'blcdsdockerregistry/samtools:1.15.1'
    options.process_label           = args.containsKey('process_label') ? args.process_label : 'none'
    options.save_intermediate_files = args.containsKey('save_intermediate_files') ? args.save_intermediate_files : false
    options.save_output_files       = args.containsKey('save_output_files') ? args.save_output_files : true
    options.extra_args              = args.containsKey('extra_args') ? args.extra_args : ''
    return options
}
