/**
*   Module for standardized filename generation
*/

/**
*   Internal function to define common types for strings
*   #output string_types    list    List containing string types
*/
def STRING_TYPES() {
    return [String, GString]
}

/**
*   Sanitize string
*   @input  raw Object  Raw input object (String or GString) for cleaning
*   @output cleaned_str string  Cleaned string
*/
def sanitize_string(Object raw) {
    if (!STRING_TYPES().any{ raw in it }) {
        invalid_string('Input to sanitize')
    }

    // Keep only alphanumeric, -, _, ., and / characters
    def cleaned_str = raw.replaceAll(/[^a-zA-Z\d\-\_\.\/]/, '')
    // Replace _ with -
    cleaned_str = cleaned_str.replace('_', '-')
    return cleaned_str
}

/**
*   Throw empty string or not a string exception
*   @input  name    string  Name of argument
*/
def invalid_string(String name) {
    throw new Exception("${name} is either empty or not a string! Provide a non-empty string.")
}

/**
*   Generate a standardized file name given components.
*   @input  main_tool   Object  Main tool name and version (String or GString)
*   @input  dataset_id  Object  Name of dataset file belongs to (String or GString)
*   @input  sample_id   Object  Name of sample in file (String or GString)
*   @input  additional_args Map Additional optional arguments. Supported keys: 
*       additional_tools (List of additional tools to include in filename)
*       additional_information (String of additional information to add to end of filename)
*   @output filename    string  Formatted string for filename
*/
def generate_standard_filename(Object main_tool, Object dataset_id, Object sample_id, Map additional_args) {
    // Check type of basic inputs
    def basic_inputs = ['main_tool': main_tool, 'dataset_id': dataset_id, 'sample_id': sample_id]
    basic_inputs.each { key, val ->
        if (STRING_TYPES().any{ val in it } && val?.trim()) {
            basic_inputs[key] = sanitize_string(val)
        } else {
            invalid_string(key)
        }
    }

    // Check for additional tools
    def additional_tools = []
    if (additional_args.containsKey('additional_tools') &&
        additional_args['additional_tools'] &&
        additional_args['additional_tools'] in List) {
        additional_args['additional_tools'].each { tool ->
            if (STRING_TYPES().any{ tool in it } && tool?.trim()) {
                additional_tools.add(sanitize_string(tool))
            }
        }
    }

    // Check for additional information
    def additional_information = ''
    if (additional_args.containsKey('additional_information') &&
        additional_args['additional_information'] &&
        STRING_TYPES().any{ additional_args['additional_information'] in it }) {
        if (additional_args['additional_information']?.trim()) {
            additional_information = sanitize_string(additional_args['additional_information'])
        }
    }

    def ordered_name_elements = [basic_inputs['main_tool']] +
        additional_tools +
        [basic_inputs['dataset_id'], basic_inputs['sample_id']] +
        additional_information

    def filename_elements = []
    ordered_name_elements.each { item ->
        if (item) {
            filename_elements.add(item)
        }
    }

    return filename_elements.join('_')
}
