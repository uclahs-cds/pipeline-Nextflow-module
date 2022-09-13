include { compress_VCF_bgzip; index_VCF_tabix } from './main.nf'
workflow compress_index_VCF {
    take:
        compress_index_ch

    main:
        compress_VCF_bgzip(compress_index_ch)
        index_VCF_tabix(compress_VCF_bgzip.out.vcf_gz)

    emit:
        index_out = index_VCF_tabix.out.index_out
}
