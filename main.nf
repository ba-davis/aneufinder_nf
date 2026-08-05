nextflow.enable.dsl = 2

include { FASTQC } from './modules/fastqc'
include { TRIMGALORE } from './modules/trim_galore'

workflow {

    read_pairs = Channel
        .fromFilePairs(params.input, checkIfExists: true)

    read_pairs.view()

    FASTQC(read_pairs)
    TRIMGALORE(read_pairs)
}

