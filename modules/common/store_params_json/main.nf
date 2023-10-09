
/* groovylint-disable CompileStatic */
import groovy.json.JsonOutput

include { initOptions } from './functions.nf'

void store_params_json() {
    Map ps = [:]
    def options = initOptions(ps)
    json_params = JsonOutput.prettyPrint(JsonOutput.toJson(params))
    File file = new File("${options.log_output_dir}/nextflow-log/params.json")
    File logdir = new File("${options.log_output_dir}/nextflow-log")
    logdir.mkdirs()
    file.write(json_params)
}
