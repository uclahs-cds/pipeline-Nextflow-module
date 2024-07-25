/**
*   Module returns the expected path to a file's index file.
*   Note that this is not a check for the existence of the index file.
*/

def indexFile(Object given_file) {
    if(given_file.endsWith('.bam')) {
        index_file_name = "${given_file}.bai"
        }
    else if(given_file.endsWith('.cram')){
        index_file_name = "${given_file}.crai"
        }
    else if(given_file.endsWith('vcf.gz')) {
        index_file_name "${given_file}.tbi"
        }
    else {
        throw new Exception("Index file for ${given_file} file type not supported. Use .bam, .vcf.gz, or .cram files.")
        }

    def index_file = new File(index_file_name)
    if(index_file.exists()) {
        return index_file_name
        }
    else {
        throw new Exception("Index file not found. ${index_file_name} does not exist.")
    }
    }
