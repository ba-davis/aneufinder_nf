nextflow.enable.dsl = 2

include { FASTQC } from './modules/fastqc'
include { TRIMGALORE } from './modules/trim_galore'
include { BWA_MEM2 } from './modules/bwa_mem2'
include { FILTER_BAM } from './modules/filter_bam'

workflow {

    read_pairs = Channel
        .fromFilePairs(params.input, checkIfExists: true)
    read_pairs.view()

    FASTQC(read_pairs)

    TRIMGALORE(read_pairs)

    trimmed_reads = TRIMGALORE.out.trimmed_reads
    reference = file(params.reference_fasta, checkIfExists: true)
    
    BWA_MEM2(trimmed_reads, reference)

    namesort_bam = BWA_MEM2.out.namesort_bam
    FILTER_BAM(namesort_bam)
}
