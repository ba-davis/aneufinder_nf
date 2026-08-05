process TRIMGALORE {

    conda "${projectDir}/envs/trim_galore.yml"

    tag "$sample"

    publishDir "${params.outdir}/trimmed", mode: 'copy'

    input:
    tuple val(sample), path(reads)

    output:
    tuple val(sample),
      path("*_val_1.fq.gz"),
      path("*_val_2.fq.gz"),
      emit: trimmed_reads

    path "*_trimming_report.txt", emit: reports

    script:
    """
    trim_galore \
        --paired \
        --fastqc \
        --cores ${task.cpus} \
        ${reads[0]} \
        ${reads[1]}
    """

    stub:
    """
    touch ${sample}_R1_val_1.fq.gz
    touch ${sample}_R2_val_2.fq.gz
    touch ${sample}_R1_trimming_report.txt
    touch ${sample}_R2_trimming_report.txt
    """
}
