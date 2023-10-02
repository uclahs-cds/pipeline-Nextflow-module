/* groovylint-disable CompileStatic */
import groovy.json.JsonOutput

process store_params_json {
    output:
    path 'pipeline_params.json' 

    exec:
    json_params = JsonOutput.prettyPrint(JsonOutput.toJson(params))
    writer = file("${task.workDir}/pipeline_params.json")
    writer.write(json_params)
}
