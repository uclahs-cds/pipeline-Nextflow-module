include {
    compress_VCF_bgzip
    index_VCF_tabix
    check_compression_bgzip
    uncompress_file_gunzip
    } from './modules.nf'

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

        checked_files.compressed_files
            .branch{
                recompress: it[0].getOrDefault('unzip_and_rezip', false)
                    return it
                passthrough: true
                    return it
            }
            .set{ processing_split_files }

        uncompress_file_gunzip(processing_split_files.recompress)

        uncompress_file_gunzip.out.uncompressed_files
            .mix(checked_files.uncompressed_files)
            .set{ input_ch_compress }

        compress_VCF_bgzip(input_ch_compress)

        compress_VCF_bgzip.out.vcf_gz
            .mix(processing_split_files.passthrough)
            .set{ input_ch_index }

        index_VCF_tabix(input_ch_index)

    emit:
        index_out = index_VCF_tabix.out.index_out
}
