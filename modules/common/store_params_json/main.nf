/* groovylint-disable CompileStatic */
import groovy.json.JsonOutput

process store_params_json {
    publishDir path: "${params.log_output_dir}/param-log",
    mode: 'copy',
    pattern: '*.json'

    output:
    path 'pipeline_params.json'

    exec:
    json_params = JsonOutput.prettyPrint(JsonOutput.toJson(params))
    writer = file("${task.workDir}/pipeline_params.json")
    writer.write(json_params)
}
