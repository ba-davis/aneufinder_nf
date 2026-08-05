process BWA_MEM2 {

    tag "$sample"

    conda "${projectDir}/envs/bwa_mem2.yml"

    publishDir "${params.outdir}/aligned", mode: 'copy'

    input:
    tuple val(sample), path(reads)
    path reference

    output:
    tuple val(sample), path("${sample}.namesort.bam"), emit: namesort_bam

    script:
    """
    bwa-mem2 mem \
        -M \
        -t ${task.cpus} \
        -R "@RG\\tID:${sample}\\tLB:library\\tPL:ILLUMINA\\tPU:unit\\tSM:${sample}" \
        ${reference} \
        ${reads[0]} \
        ${reads[1]} \
    | samtools sort \
        -n \
        -@ ${task.cpus} \
        -o ${sample}.namesort.bam
    """

    stub:
    """
    touch ${sample}.namesort.bam
    """
}
