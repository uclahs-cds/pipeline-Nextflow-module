/**
*   Module returns the expected path to a file's index file.
*   Note that this is not a check for the existence of the index file.
*/

def indexFile(Object given_file) {
    if(bam_cram_or_vcf.endsWith('.bam')) {
        return "${bam_cram_or_vcf}.bai"
        }
    else if(bam_cram_or_vcf.endsWith('.cram')){
        return "${bam_cram_or_vcf}.crai"
    }
    else if(bam_cram_or_vcf.endsWith('vcf.gz')) {
        return "${bam_cram_or_vcf}.tbi"
        }
    else {
        throw new Exception("Index file for ${bam_cram_or_vcf} file type not supported. Use .bam or .vcf.gz files.")
        }
    }
