include { initOptions } from './functions.nf'

params.options = [:]
options = initOptions(params.options)

/*
    Nextflow module for removing intermediate files. Follows symlinks to remove original files.

    input:
        file_to_remove: path to file to be removed
        ready_for_deletion_signal: val to indicate that deletion can proceed.
            Included for cases where multiple processes are using the intermediate files.

    params:
        params.log_output_dir: string(path)
        params.save_intermediate_files: bool.
*/
process remove_intermediate_files {
    container options.docker_image
    label options.process_label

    publishDir path: "${options.log_output_dir}",
      pattern: ".command.*",
      mode: "copy",
      saveAs: { "${task.process.replace(':', '/')}/${task.process.split(':')[-1]}-${task.index}/log${file(it).getName()}" }

    // This process uses the publishDir method to save the log files
    ext capture_logs: false

    input:
    path(input_file_to_remove), stageAs: "delete.file"
    val(ready_for_deletion_signal)

    output:
    path(".command.*")

    when:
    !options.save_intermediate_files

    script:
    file_to_remove = "delete.file"
    """
    set -euo pipefail

    echo "Disk usage before deletion: "
    df -h ${workDir}

    if [[ -L ${file_to_remove} ]]
    then
      real_path_to_remove="`readlink -f ${file_to_remove}`"
      unlink "${file_to_remove}"
    else
      real_path_to_remove="${file_to_remove}"
    fi
  
    rm -r "\$real_path_to_remove"

    echo "Disk usage after deletion: "
    df -h ${workDir}
    """
}
