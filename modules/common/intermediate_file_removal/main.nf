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
      saveAs: { "${task.process.split(':')[-1]}/${task.process.split(':')[-1]}-${task.index}/log${file(it).getName()}" }

    input:
    path(file_to_remove)
    val(ready_for_deletion_signal)

    output:
    path(".command.*")

    when:
    !options.save_intermediate_files

    script:
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
  
    if [[ -d "\$real_path_to_remove" ]]
    then
      rm -r "\$real_path_to_remove"
    else
      rm "\$real_path_to_remove"
    fi

    echo "Disk usage after deletion: "
    df -h ${workDir}
    """
}
