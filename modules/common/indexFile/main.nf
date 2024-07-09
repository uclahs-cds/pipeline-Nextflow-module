/**
*   Module returns the expected path to a file's index file.
*   Note that this is not a check for the existence of the index file.
*/

def indexFile(Object given_file) {
    if(given_file.endsWith('.bam')) {
        return "${given_file}.bai"
        }
    else if(given_file.endsWith('.cram')){
        return "${given_file}.crai"
    }
    else if(given_file.endsWith('vcf.gz')) {
        return "${given_file}.tbi"
        }
    else {
        throw new Exception("Index file for ${given_file} file type not supported. Use .bam, .vcf.gz, or .cram files.")
        }
    }
