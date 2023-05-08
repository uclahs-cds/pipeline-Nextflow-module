include {
    compress_VCF_bgzip
    index_VCF_tabix
    check_compression_bgzip
    uncompress_file_gunzip
    } from './modules.nf'
include { initOptions } from './functions.nf'

params.options = [:]
options = initOptions(params.options)

workflow compress_index_VCF {
    take:
        compress_index_ch

    main:
        check_compression_bgzip(compress_index_ch)

        check_compression_bgzip.out.checked_files
            .branch{
                compressed_files: it[2] == 'true'
                    return [it[0], it[1]]
                uncompressed_files: it[2] == 'false'
                    return [it[0], it[1]]
            }
            .set{ checked_files }

        checked_files.uncompressed_files
            .set{ input_ch_compress }

        if (options.unzip_and_rezip) {
            uncompress_file_gunzip(checked_files.compressed_files)

            uncompress_file_gunzip.out.uncompressed_files
                .mix(input_ch_compress)
                .set{ input_ch_compress }
        }

        compress_VCF_bgzip(input_ch_compress)

        compress_VCF_bgzip.out.vcf_gz
            .set{ input_ch_index }

        if (!options.unzip_and_rezip) {
            checked_files.compressed_files
                .mix(input_ch_index)
                .set{ input_ch_index }
        }

        index_VCF_tabix(input_ch_index)

    emit:
        index_out = index_VCF_tabix.out.index_out
}
