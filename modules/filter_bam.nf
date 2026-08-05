process FILTER_BAM {

    tag "$sample"

    conda "${projectDir}/envs/bwa_mem2.yml"

    publishDir "${params.outdir}/filtered", mode: 'copy'

    input:
    tuple val(sample), path(bam)

    output:
    tuple val(sample), path("${sample}.mapq${params.mapq}.bam"), emit: filtered_bam

    script:
    """
    # skip secondary hits (0x0100) and unmapped reads (0x0004)
    samtools view \
      -b \
      -F 0x104 \
      ${bam} \
      > ${sample}.primary.bam

    # fix mate info for markdup later
    samtools fixmate \
      -m \
      ${sample}.primary.bam \
      ${sample}.fixmate.bam

    # sort by coordinate for markdup and indexing
    samtools sort \
      -@ ${task.cpus} \
      -o ${sample}.sorted.bam \
      ${sample}.fixmate.bam

    # remove duplicates
    samtools markdup \
      -@ ${task.cpus} \
      -r \
      ${sample}.sorted.bam \
      ${sample}.dedup.bam

    # Filter MAPQ (default 30)
    samtools view \
      -b \
      -q ${params.mapq} \
      ${sample}.dedup.bam \
      > ${sample}.mapq${params.mapq}.bam

    # Index the final bam file
    samtools index ${sample}.mapq${params.mapq}.bam
    """

    stub:
    """
    touch ${sample}.mapq${params.mapq}.bam
    touch ${sample}.mapq${params.mapq}.bam.bai
    """
}
