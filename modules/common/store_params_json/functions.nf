/*
 * Utility functions for logging parameters
 */

/*
 * Function to initialize default values and to generate a Groovy Map of options used by the process
 */
def initOptions(Map args) {
    Map options = [:]
    options.log_output_dir          = args.log_output_dir ?: params.log_output_dir
    return options
    }

