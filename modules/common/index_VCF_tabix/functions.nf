/*
 *  Utility functions for compressing and indexing VCFs.
 */


/*
 *  Function to initialize default values and to generate a Groovy Map of options used by the process
 */
def initOptions(Map args) {
    def Map options = [:]
    options.output_dir              = args.containsKey('output_dir') ? args.output_dir : params.output_dir
    options.log_output_dir          = args.containsKey('log_output_dir') ? args.log_output_dir : "${params.log_output_dir}/process-log"
    options.docker_image            = args.docker_image ?: 'blcdsdockerregistry/samtools:1.15.1'
    options.process_label           = args.containsKey('process_label') ? args.process_label : 'none'
    options.save_intermediate_files = args.containsKey('save_intermediate_files') ? args.save_intermediate_files : false
    options.is_output_file       = args.containsKey('is_output_file') ? args.is_output_file : true
    options.bgzip_extra_args              = args.containsKey('bgzip_extra_args') ? args.extra_args : ''
    options.tabix_extra_args              = args.containsKey('tabix_extra_args') ? args.extra_args : ''
    return options
}
